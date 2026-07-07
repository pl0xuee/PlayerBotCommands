-- Combat & Target Commands
local Combat = {}

local function attack(args)
    local target = args[1] or "target"
    print("|cff00ffff[Combat]|r Attacking: " .. target)
    -- Command implementation
end

local function assist(args)
    local mainTank = args[1] or "player"
    print("|cff00ffff[Combat]|r Assisting: " .. mainTank)
    -- Command implementation
end

local function tank(args)
    print("|cff00ffff[Combat]|r Tank mode activated")
    -- Command implementation
end

local function offtank(args)
    print("|cff00ffff[Combat]|r Offtank mode activated")
    -- Command implementation
end

local function pullrange(args)
    local range = args[1] or "30"
    print("|cff00ffff[Combat]|r Pull range: " .. range .. "y")
    -- Command implementation
end

local function grind(args)
    print("|cff00ffff[Combat]|r Grind mode activated")
end

local function co(args)
    if not args[1] then
        print("|cff00ffff[Combat]|r Use: /pb co +tank,+assist,+dps,+cc,+heal")
        return
    end
    print("|cff00ffff[Combat]|r co strategy update: " .. table.concat(args, " "))
end

local function nc(args)
    if not args[1] then
        print("|cff00ffff[Combat]|r Use: /pb nc +strategy")
        return
    end
    print("|cff00ffff[Combat]|r nc strategy update: " .. table.concat(args, " "))
end

-- Register commands
PLAYERBOT:RegisterCommand("attack", "combat", attack)
PLAYERBOT:RegisterCommand("assist", "combat", assist)
PLAYERBOT:RegisterCommand("tank", "combat", tank)
PLAYERBOT:RegisterCommand("offtank", "combat", offtank)
PLAYERBOT:RegisterCommand("pull", "combat", pullrange)
PLAYERBOT:RegisterCommand("grind", "combat", grind)
PLAYERBOT:RegisterCommand("co", "combat", co)
PLAYERBOT:RegisterCommand("nc", "combat", nc)

return Combat
