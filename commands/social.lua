-- Social & Group Commands
local Social = {}

local function join(args)
    print("|cff00ffff[Social]|r Bot joined group")
    -- Command implementation
end

local function leave(args)
    print("|cff00ffff[Social]|r Bot left group")
    -- Command implementation
end

local function role(args)
    if not args[1] then
        print("|cffff0000[Social]|r Specify role: tank, dps, healer")
        return
    end
    local role = string.lower(args[1])
    print("|cff00ffff[Social]|r Role set to: " .. role)
    -- Command implementation
end

local function trade(args)
    print("|cff00ffff[Social]|r Trading enabled")
    -- Command implementation
end

local function invite(args)
    if not args[1] then
        print("|cffff0000[Social]|r Specify player name")
        return
    end
    print("|cff00ffff[Social]|r Inviting: " .. args[1])
    -- Command implementation
end

-- Register commands
PLAYERBOT:RegisterCommand("join", "social", join)
PLAYERBOT:RegisterCommand("leave", "social", leave)
PLAYERBOT:RegisterCommand("role", "social", role)
PLAYERBOT:RegisterCommand("trade", "social", trade)
PLAYERBOT:RegisterCommand("invite", "social", invite)

return Social
