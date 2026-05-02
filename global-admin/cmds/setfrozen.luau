local cloneref = cloneref or function(...) return ... end
local Players = cloneref(game:GetService("Players"))

return function(args: { state: true? })
  local c = Players.LocalPlayer.Character
  local pp = c.PrimaryPart or c:WaitForChild("HumanoidRootPart")
  pp.Anchored = args.state
end
