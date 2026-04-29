local cloneref = cloneref or function(...) return ... end
local Players = cloneref(game:GetService("Players"))

return function()
  local h = Players.LocalPlayer.Character and Players.LocalPlayer.Character:WaitForChild("Humanoid")
  if not h then
    return
  end
  h.Health = 0
end
