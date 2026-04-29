local cloneref = cloneref or function(...) return ... end
local TextChatService = cloneref(game:GetService("TextChatService"))
local textChannels = TextChatService:WaitForChild("TextChannels")
local defaultChannel = textChannels and textChannels:WaitForChild("RBXGeneral")

if not defaultChannel then
  return function() end
end

return function(message: string)
  defaultChannel:SendAsync(message)
end
