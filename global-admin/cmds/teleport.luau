local cloneref = cloneref or function(...) return ... end
local queue_on_teleport = queue_on_teleport or function() end

local TeleportService = cloneref(game:GetService("TeleportService"))
local ExperienceService = cloneref(game:GetService("ExperienceService"))

local function teleportToJobId(jobId: string?)
  if typeof(jobId) ~= "string" then
    return
  end

  queue_on_teleport([[
    local TeleportService = game:GetService("TeleportService")
    TeleportService:TeleportToPlaceInstance(game.PlaceId, "]]..jobId..[[")
  ]])
end

return function(args: { placeId: number, jobId: string? })
  teleportToJobId(args.jobId)
  ExperienceService:LaunchExperience({args.placeId}) -- Unauthorized experience bypass
  TeleportService:Teleport(args.placeId) -- 3rd party teleports allowed + executor disables ExperienceService (???)
end
