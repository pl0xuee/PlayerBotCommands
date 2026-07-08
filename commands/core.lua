-- Core & General Commands
local Core = {}

local function help(args)
    if args[1] then
        local category = string.lower(args[1])
        print("|cff00ffff[PlayerBot - " .. category .. "]|r")
        -- Display category-specific help
        print("Use /pb help to see all categories")
    else
        print("|cff00ffff[PlayerBot Command Categories]|r")
        print("|cffFFD100Core:|r /pb help, /pb status, /pb info")
        print("|cffFFD100Movement:|r /pb follow, /pb stay, /pb move")
        print("|cffFFD100Combat:|r /pb attack, /pb assist, /pb tank")
        print("|cffFFD100Spells:|r /pb cast, /pb buff, /pb heal")
        print("|cffFFD100Social:|r /pb join, /pb leave, /pb role")
        print("|cffFFD100Admin:|r /pb toggle, /pb reset, /pb config")
    end
end

local function status(args)
    print("|cff00ffff[Bot Status]|r")
    print("Bots Online: 5/5")
    print("Mode: Combat Ready")
    print("Formation: Auto")
end

local function info(args)
    print("|cff00ffff[PlayerBot v" .. PLAYERBOT.version .. "]|r")
    print("Azerothcore WOTLK 3.3.5")
    print("For commands: /pb help")
end

local function ui(args)
    if PLAYERBOT.ToggleUI then
        PLAYERBOT:ToggleUI()
    else
        print("|cffff0000[PlayerBot]|r UI is not available")
    end
end

local function chatmode(args)
    print("|cff00ffff[PlayerBot]|r Chat routing is automatic (RAID first, then PARTY).")
end

-- Register commands
PLAYERBOT:RegisterCommand("help", "core", help)
PLAYERBOT:RegisterCommand("status", "core", status)
PLAYERBOT:RegisterCommand("info", "core", info)
PLAYERBOT:RegisterCommand("ui", "core", ui)
PLAYERBOT:RegisterCommand("chatmode", "core", chatmode)

return Core
