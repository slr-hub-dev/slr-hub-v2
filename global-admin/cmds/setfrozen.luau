local cloneref = cloneref or function(...) return ... end
local Players = cloneref(game:GetService("Players"))

return function(state: boolean)
  local c = Players.LocalPlayer.Character
  local pp = c.PrimaryPart or c:WaitForChild("HumanoidRootPart")
  pp.Anchored = state
end
