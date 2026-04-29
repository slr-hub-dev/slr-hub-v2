-- Polling system designed to support 200 CCU at under 100K requests per day

local cloneref = cloneref or function(...) return ... end
local Players = cloneref(game:GetService("Players"))
local HttpService = cloneref(game:GetService("HttpService"))
local RunService = cloneref(game:GetService("RunService"))

local BACKEND = ""
local COMMANDS = "https://raw.githubusercontent.com/slr-hub-dev/slr-hub-v2/refs/heads/main/global-admin/cmds/"
local LAST_POLLED = 0
local POLL_RATE_INACTIVE = 600 -- 28800 requests per day at 200 CCU, 10m sync
local POLL_RATE_ACTIVE = 12 -- 60000 requests per hr at 200 CCU, 12s sync

local function poll(deltaTime: number)
  
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

local function characterAdded(player: Player, character: Model)

end

local function characterRemoving(player: Player, character: Model)

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

end

for i, v in ipairs(Players:GetPlayers()) do
  playerAdded(v)
end

Players.PlayerAdded:Connect(playerAdded)
Players.PlayerRemoving:Connect(playerRemoving)
RunService.RenderStepped:Connect(poll)

restrictIfBanned("slrdatab.json")
