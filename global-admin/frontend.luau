-- Polling system designed to support 200 CCU at under 100K requests per day

local cloneref = cloneref or function(...) return ... end
local Players = cloneref(game:GetService("Players"))
local HttpService = cloneref(game:GetService("HttpService"))
local RunService = cloneref(game:GetService("RunService"))

local cache = { eventIds = {}, commands = {}}

local BACKEND = ""
local COMMANDS = "https://raw.githubusercontent.com/slr-hub-dev/slr-hub-v2/refs/heads/main/global-admin/cmds/"
local LAST_POLLED = 0
local POLL_RATE_INACTIVE = 600 -- 28800 requests per day at 200 CCU, 10m sync
local POLL_RATE_ACTIVE = 12 -- 60000 requests per hr at 200 CCU, 12s sync

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

  local backendData = game:HttpGet(BACKEND)
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
