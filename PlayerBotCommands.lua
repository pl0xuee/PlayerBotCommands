-- PlayerBotCommands - Main Addon Entry Point
PLAYERBOT = {}
PLAYERBOT.version = "1.1"
PLAYERBOT.commands = {}
PLAYERBOT.capabilities = {}
PLAYERBOT.lastSentCommand = ""
PLAYERBOT.lastChatType = ""

local function getCommandCount()
    local total = 0
    for _, cmds in pairs(PLAYERBOT.commands) do
        for _ in pairs(cmds) do
            total = total + 1
        end
    end
    return total
end

function PLAYERBOT:HasRegisteredCommand(command)
    local cmd = string.lower(command or "")
    for _, cmds in pairs(self.commands) do
        if cmds[cmd] then
            return true
        end
    end
    return false
end

function PLAYERBOT:GetChatType()
    if GetNumRaidMembers and GetNumRaidMembers() > 0 then
        return "RAID"
    end

    if GetNumPartyMembers and GetNumPartyMembers() > 0 then
        return "PARTY"
    end

    return nil
end

function PLAYERBOT:BuildCommandText(command, args)
    local cmd = string.lower(command or "")
    local text = cmd

    if args and #args > 0 then
        text = cmd .. " " .. table.concat(args, " ")
    end

    return text
end

function PLAYERBOT:SendBotCommand(command, args)
    local message = self:BuildCommandText(command, args)
    local chatType = self:GetChatType()

    if not message or message == "" then
        return false
    end

    if not chatType then
        print("|cffffaa00[PlayerBot]|r Not in party/raid, command not sent: " .. message)
        return false
    end

    SendChatMessage(message, chatType)
    self.lastSentCommand = message
    self.lastChatType = chatType

    if self.UI and self.UI.RefreshHeader then
        self.UI:RefreshHeader()
    end

    return true
end

function PLAYERBOT:SetCapability(command, available)
    if not command or command == "" then
        return
    end
    self.capabilities[string.lower(command)] = available and true or false
end

function PLAYERBOT:IsCapabilityAvailable(command)
    local cmd = string.lower(command or "")
    if cmd == "" then
        return false
    end

    local known = self.capabilities[cmd]
    if known ~= nil then
        return known
    end

    return self:HasRegisteredCommand(cmd)
end

function PLAYERBOT:EnsureFallbackCommands()
    if getCommandCount() > 0 then
        return
    end

    local function reg(name, category, message)
        self:RegisterCommand(name, category, function(args)
            print(message)
        end)
    end

    reg("help", "core", "|cff00ffff[PlayerBot]|r Use /pb ui for GUI or /pb <command>")
    reg("status", "core", "|cff00ffff[Bot Status]|r Mode: Ready")
    reg("info", "core", "|cff00ffff[PlayerBot]|r v" .. self.version)

    reg("follow", "movement", "|cff00ffff[Movement]|r Following target")
    reg("stay", "movement", "|cff00ffff[Movement]|r Holding position")
    reg("move", "movement", "|cff00ffff[Movement]|r Formation updated")
    reg("idle", "movement", "|cff00ffff[Movement]|r Idle mode enabled")

    reg("attack", "combat", "|cff00ffff[Combat]|r Attack order sent")
    reg("assist", "combat", "|cff00ffff[Combat]|r Assist mode enabled")
    reg("tank", "combat", "|cff00ffff[Combat]|r Tank mode enabled")
    reg("offtank", "combat", "|cff00ffff[Combat]|r Offtank mode enabled")
    reg("pull", "combat", "|cff00ffff[Combat]|r Pull range updated")
    reg("interrupt", "combat", "|cff00ffff[Combat]|r Interrupt mode enabled")

    reg("cast", "spells", "|cff00ffff[Spells]|r Cast request sent")
    reg("buff", "spells", "|cff00ffff[Spells]|r Buff routine started")
    reg("heal", "spells", "|cff00ffff[Spells]|r Heal routine started")
    reg("cc", "spells", "|cff00ffff[Spells]|r Crowd control enabled")

    reg("join", "social", "|cff00ffff[Social]|r Join request sent")
    reg("leave", "social", "|cff00ffff[Social]|r Leave request sent")
    reg("role", "social", "|cff00ffff[Social]|r Role updated")
    reg("trade", "social", "|cff00ffff[Social]|r Trade mode enabled")
    reg("invite", "social", "|cff00ffff[Social]|r Invite sent")

    reg("toggle", "admin", "|cff00ffff[Admin]|r Toggle applied")
    reg("reset", "admin", "|cff00ffff[Admin]|r Reset requested")
    reg("config", "admin", "|cff00ffff[Admin]|r Config opened")
    reg("debug", "admin", "|cff00ffff[Admin]|r Debug mode updated")
    reg("updateai", "admin", "|cff00ffff[Admin]|r AI update requested")

    self:RegisterCommand("ui", "core", function(args)
        if self.ToggleUI then
            self:ToggleUI()
        end
    end)

    print("|cffffff00[PlayerBot]|r Command modules missing, fallback commands loaded")
end

-- Initialize addon
function PLAYERBOT:Init()
    self:EnsureFallbackCommands()
    print("|cff00ffff[PlayerBot]|r Command system initialized (" .. getCommandCount() .. " commands)")
    self:LoadCommands()
end

-- Register command handler
function PLAYERBOT:RegisterCommand(name, category, callback)
    if not self.commands[category] then
        self.commands[category] = {}
    end
    self.commands[category][name] = callback
end

-- Execute command
function PLAYERBOT:Execute(command, args)
    self:EnsureFallbackCommands()
    local cmd = string.lower(command)
    local sent = self:SendBotCommand(cmd, args)
    
    for category, cmds in pairs(self.commands) do
        if cmds[cmd] then
            cmds[cmd](args)
            self:SetCapability(cmd, true)

            if self.UI and self.UI.RefreshSections then
                self.UI:RefreshSections()
            end
            return true
        end
    end
    
    self:SetCapability(cmd, false)
    if self.UI and self.UI.RefreshSections then
        self.UI:RefreshSections()
    end

    if sent then
        self:SetCapability(cmd, true)
        if self.UI and self.UI.RefreshSections then
            self.UI:RefreshSections()
        end
        return true
    end

    print("|cffff0000[PlayerBot]|r Unknown command: " .. command)
    return false
end

-- Load all command modules
function PLAYERBOT:LoadCommands()
    -- Commands are registered by individual modules
end

-- Chat command handler
SLASH_PLAYERBOT1 = "/pb"
SLASH_PLAYERBOT2 = "/pbot"

function SlashCmdList.PLAYERBOT(msg, editbox)
    if msg == "" then
        if PLAYERBOT.ToggleUI then
            PLAYERBOT:ToggleUI()
        else
            PLAYERBOT:ShowHelp()
        end
        return
    end
    
    local args = {}
    for arg in msg:gmatch("%S+") do
        table.insert(args, arg)
    end
    
    local command = table.remove(args, 1)
    PLAYERBOT:Execute(command, args)
end

-- Display help
function PLAYERBOT:ShowHelp()
    print("|cff00ffff[PlayerBot Commands]|r")
    print("|cffFFD100Usage: /pb <command> [arguments]|r")
    print("Try: /pb help <category> or /pb ui")
end

-- Addon load event
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, addon)
    if addon == "PlayerBotCommands" then
        PLAYERBOT:Init()
        if PLAYERBOT.ToggleUI then
            PLAYERBOT:ToggleUI()
        end
    end
end)
