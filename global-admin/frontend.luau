local cloneref = cloneref or function(...) return ... end
local http_request = request or http_request or http.request

local HttpService = cloneref(game:GetService("HttpService"))

local lastPolled = 0
local currentChannel = 1

local BACKENDS = loadstring(game:HttpGet("https://raw.githubusercontent.com/slr-hub-dev/slr-hub-v2/refs/heads/main/global-admin/backends.luau"))()
local CONFIGURATION = loadstring(game:HttpGet("https://raw.githubusercontent.com/slr-hub-dev/slr-hub-v2/refs/heads/main/config/admin-frontend.luau"))()

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

local function onAdminEventsReceieved({})

end

local function poll(enabled: boolean?, START_TIMESTAMP: number)
  local pollRate = enabled and CONFIGURATION.POLL_RATE_ACTIVE or CONFIGURATION.POLL_RATE_INACTIVE

  if os.time() - lastPolled < pollRate then
    task.wait()
    return poll(enabled, START_TIMESTAMP)
  end

  local lastPolled = os.time()
  local success, data = pcall(function()
    return HttpService:JSONDecode(http_get("data"))
  end)

  if not success or not data or not data.state or not data.state.enabled or not data.events then
    return poll(data.state and data.state.enabled or nil, START_TIMESTAMP)
  end
  
  onAdminEventsReceieved(data.events)
  poll(data.state.enabled, START_TIMESTAMP)
end

poll(nil, http_get("time"))
