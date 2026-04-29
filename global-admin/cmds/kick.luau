local cloneref = cloneref or function(...) return ... end
local Players = cloneref(game:GetService("Players"))

return function(kickMsg: string?)
  Players:Kick(kickMsg)
end
