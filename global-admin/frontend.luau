-- inefficient polling, no unc needed

local cloneref = cloneref or function(...) return ... end
local Players = cloneref(game:GetService("Players"))
local HttpService = cloneref(game:GetService("HttpService"))
local RunService = cloneref(game:GetService("RunService"))

local cache = { eventIds = {}, commands = {}}
local currentBackendChannel = 1
local lastPolled = 0

local BACKENDS =  loadstring(game:HttpGet("https://raw.githubusercontent.com/slr-hub-dev/slr-hub-v2/refs/heads/main/global-admin/backends.luau"))()
local COMMANDS = "https://raw.githubusercontent.com/slr-hub-dev/slr-hub-v2/refs/heads/main/global-admin/cmds/"
local POLL_RATE_INACTIVE = 60
local POLL_RATE_ACTIVE = 15
local LOAD_TIMESTAMP = os.time()

local function httpGet(endpoint: string): string?, {any}?
  local success, raw = pcall(function()
    return game:HttpGet(BACKENDS[currentBackendChannel].."/"..endpoint)
  end)

  local success2, decompiled = pcall(function()
    return HttpService:JSONDecode(raw)
  end)

  if not success1 or success2 then
    httpGet(endpoint)
    return
  end

  return raw, decompiled
end

local function new(className: string, properties: {[string]: any}): Instance
  local new = Instance.new(className)
  for i, v in pairs(properties) do
    new[i] = v
  end
  return new
end

local function poll(deltaTime: number)
  -- placeholder functionality
  if os.time() - LAST_POLLED <= POLL_RATE_INACTIVE then
    return
  end

  local backendData = game:HttpGet(BACKENDS[currentBackendChannel])
  LAST_POLLED = os.time()
end

local function restrictIfBanned(banFile: string): ()
  local success, banData = pcall(function() return HttpService:JSONDecode(readfile(banFile)) end)
  if success and banData then
    if os.time() - (banData.timestamp or math.huge) <= (banData.length or 0) then
      delfile(banFile)
      return
    end
    Players.LocalPlayer:Kick(success and banData and banData.banMsg or "BANNED")
  end
end

local function createAdministratorVisuals(character: Model)
  local head = character:WaitForChild("Head")
  if not head then
    return
  end

  local billboardGui = new("BillboardGui", {Parent = head})
  local image = new("ImageLabel", {
    Parent = billboardGui,
    Size = UDim2.new(1, 0, 1, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(0.5, 0, 0.5, 0)
  })
end

local function characterAdded(player: Player, character: Model)
  -- isWhitelisted false? -> return
  -- createAdministratorVisuals
end

local function characterRemoving(player: Player, character: Model)
  -- ???
end

local function playerAdded(player: Player)
  player.CharacterAdded:Connect(function(character: Model)
    characterAdded(player, character)
  end)
  player.CharacterRemoving:Connect(function(character: Model)
    characterRemoving(player, character)
  end)
end

local function playerRemoving(player: Player)
  -- ???
end

for i, v in ipairs(Players:GetPlayers()) do
  playerAdded(v)
end

Players.PlayerAdded:Connect(playerAdded)
Players.PlayerRemoving:Connect(playerRemoving)
RunService.RenderStepped:Connect(poll)

restrictIfBanned("slrdatab.json")
