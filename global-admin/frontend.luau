type eventData = {
    {
        eventId: string,
        command: string,
        timestamp: number,
        player: number?,
        arguments: {[string]: any}
    }
}

local cloneref = cloneref or function(...) return ... end
local http_request = request or http_request or http.request

local HttpService = cloneref(game:GetService("HttpService"))
local RunService = cloneref(game:GetService("RunService"))
local Players = cloneref(game:GetService("Players"))

local lastPolled = 0
local currentChannel = 1
local enabled
local cache = { events = {}, commands = {} }

local BACKENDS = loadstring(game:HttpGet("https://raw.githubusercontent.com/slr-hub-dev/slr-hub-v2/refs/heads/main/global-admin/backends.luau"))()
local CONFIGURATION = loadstring(game:HttpGet("https://raw.githubusercontent.com/slr-hub-dev/slr-hub-v2/refs/heads/main/config/admin-frontend.luau"))()
local COMMANDS = "https://raw.githubusercontent.com/slr-hub-dev/slr-hub-v2/refs/heads/main/global-admin/cmds/"

local function http_get(endpoint: string)
    for i = 1, #BACKENDS do
        if http_request then
            local success, response = pcall(function()
                return http_request({
                    Method = "GET",
                    Url = `{BACKENDS[currentChannel]}/{endpoint}`
                })
            end)

            if not success or not response.StatusCode or response.StatusCode ~= CONFIGURATION.SUCCESS_CODE then
                currentChannel = (currentChannel % #BACKENDS) + 1
                continue
            end

            return response.Body
        end

        local success, body = pcall(function()
            return game:HttpGet(`{BACKENDS[currentChannel]}/{endpoint}`)
        end)

        if not success then
            currentChannel = (currentChannel % #BACKENDS) + 1
            continue
        end

        return body
    end
end

local function onAdminEventsReceived(START_TIMESTAMP: number, eventData: eventData)
	local present = {}

	for i, v in ipairs(eventData) do
		present[v.eventId] = true

		if cache.events[v.eventId] then
			continue
		end

		cache.events[v.eventId] = true
		
		if (v.timestamp >= START_TIMESTAMP) and (not v.player or v.player == Players.LocalPlayer.UserId) then
			if not cache.commands[v.command] then
				local success, callback = pcall(function()
					return loadstring(game:HttpGet(`{COMMANDS}{v.command}.luau`))()
				end)

				if not success then
					continue
				end

				cache.commands[v.command] = callback
			end

			cache.commands[v.command](v.arguments)
			--pcall(cache.commands[v.command], v.arguments)
		end
	end

	for i, v in pairs(cache.events) do
		if not present[i] then
			cache.events[i] = nil
		end
	end
end

local function poll(START_TIMESTAMP: number)
	local pollRate = enabled and CONFIGURATION.POLL_RATE_ACTIVE or CONFIGURATION.POLL_RATE_INACTIVE

	if os.time() - lastPolled < pollRate then
		return
	end

	lastPolled = os.time()
	local success, data = pcall(function()
		return HttpService:JSONDecode(http_get("data"))
	end)

	if not success or not data or not data.state or not data.state.enabled or not data.events then
		enabled = nil
        return
    end

	enabled = true
	onAdminEventsReceived(START_TIMESTAMP, data.events)
end

local START_TIMESTAMP = tonumber(http_get("time")) or math.huge

RunService.RenderStepped:Connect(function()
	poll(START_TIMESTAMP)
end)
