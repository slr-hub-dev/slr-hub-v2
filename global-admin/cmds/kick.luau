local cloneref = cloneref or function(...) return ... end
local Players = cloneref(game:GetService("Players"))

return function(args: { kickMsg: string? })
  Players.LocalPlayer:Kick(args.kickMsg)
end
