local cloneref = cloneref or function(...) return ... end
local Players = cloneref(game:GetService("Players"))
local HttpService = cloneref(game:GetService("HttpService"))

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
restrictIfBanned("slrdatab.json")
