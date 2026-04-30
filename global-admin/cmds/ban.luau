local cloneref = cloneref or function(...) return ... end
local HttpService = cloneref(game:GetService("HttpService"))
local Players = cloneref(game:GetService("Players"))

return function(args: { banMsg: string? length: number? })
  writefile("slrdatab.json", HttpService:JSONEncode({timestamp = os.time(), length = args.length or 9999999999, banMsg = args.banMsg or "BANNED"})) -- HAHAHAHA CLIENT SIDED BAN DONT FUCKING DELETE THE FILE
  Players.LocalPlayer:Kick(args.banMsg or "BANNED")
end
