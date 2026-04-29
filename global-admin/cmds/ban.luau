local cloneref = cloneref or function(...) return ... end
local HttpService = cloneref(game:GetService("HttpService"))
local Players = cloneref(game:GetService("Players"))

return function(banMsg: string?, length: number?)
  writefile("slrdatab.json", HttpService:JSONEncode({timestamp = os.time(), length = length or 99999999999999999999, msg = msg or "BANNED"}) -- HAHAHAHA CLIENT SIDED BAN DONT FUCKING DELETE THE FILE
  Players.LocalPlayer:Kick(banMsg or "BANNED")
end
