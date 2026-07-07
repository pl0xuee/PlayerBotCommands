-- Utility Helper Functions
local Helpers = {}

-- Format color text
function Helpers:ColorText(text, color)
    color = color or "00ffff"
    return "|cff" .. color .. text .. "|r"
end

-- Print message with prefix
function Helpers:PrintMsg(msg, category)
    category = category or "PlayerBot"
    print("|cff00ffff[" .. category .. "]|r " .. msg)
end

-- Parse command arguments
function Helpers:ParseArgs(input)
    local args = {}
    for arg in input:gmatch("%S+") do
        table.insert(args, arg)
    end
    return args
end

-- Check if player is in group
function Helpers:IsInGroup()
    return GetNumGroupMembers() > 1 or IsInRaid()
end

-- Get bot count
function Helpers:GetBotCount()
    -- Implementation for getting active bot count
    return 0
end

-- Format distance
function Helpers:FormatDistance(yards)
    return yards .. "y"
end

return Helpers
