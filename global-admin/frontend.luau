local cloneref = cloneref or function(...) return ... end
local Players = cloneref(game:GetService("Players"))

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
