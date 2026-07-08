-- Compact PlayerBot command center with category paging
PLAYERBOT = PLAYERBOT or {}
PLAYERBOT.UI = PLAYERBOT.UI or {}

local UI = PLAYERBOT.UI

local layout = {
    panelWidth = 486,
    panelHeight = 236,
    sideWidth = 104,
    browserWidth = 346,
    browserHeight = 188,
    actionCols = 3,
    actionRows = 4,
    actionButtonWidth = 106,
    actionButtonHeight = 20,
    actionGapX = 6,
    actionGapY = 4,
}

local SOLID = "Interface\\Buttons\\WHITE8x8"

-- Modern Wrath of the Lich King inspired theme: deep frost slate + warm gold trim.
local palette = {
    panel = { 0.035, 0.050, 0.078, 0.96 },
    header = { 0.075, 0.105, 0.150, 0.98 },
    section = { 0.060, 0.082, 0.120, 0.92 },
    accent = { 0.36, 0.74, 0.95, 1.00 },
    accentSoft = { 0.90, 0.75, 0.38, 1.00 },
    gold = { 0.90, 0.75, 0.38, 1.00 },
    goldBright = { 1.00, 0.86, 0.48, 1.00 },
    frost = { 0.36, 0.74, 0.95, 1.00 },
    border = { 0.20, 0.28, 0.38, 1.00 },
    borderInner = { 0.02, 0.03, 0.05, 0.90 },
    text = { 0.95, 0.97, 1.00, 1.00 },
    muted = { 0.72, 0.78, 0.86, 1.00 },
    dark = { 0.05, 0.07, 0.10, 1.00 },
    buttonDefault = { 0.11, 0.15, 0.21, 0.92 },
    buttonPress = { 0.20, 0.45, 0.60, 0.95 },
    catActive = { 0.90, 0.75, 0.38, 1.00 },
    catInactive = { 0.10, 0.14, 0.19, 0.95 },
    toneAttack = { 0.34, 0.13, 0.14, 0.92 },
    toneHeal = { 0.12, 0.26, 0.17, 0.92 },
    toneMove = { 0.26, 0.20, 0.10, 0.92 },
    toneSupport = { 0.12, 0.18, 0.26, 0.92 },
}

local commandCatalog = {
    {
        title = "General",
        actions = {
            { label = "Attack", command = "@tank do attack", argsFn = function()
                return { "my", "target" }
            end, tip = "Tell tank bots to attack your current target." },
            { label = "Follow", command = "follow", args = { "player" }, tip = "Bots follow your character." },
            { label = "Stay", command = "stay", args = {}, tip = "Bots hold position." },
            { label = "Flee", command = "flee", args = {}, tip = "Bots run to you and ignore threats." },
            { label = "Summon", command = "summon", args = {}, tip = "Summon bots to your location." },
            { label = "Grind", command = "grind", args = {}, tip = "Attack anything visible." },
            { label = "Leave", command = "leave", args = {}, tip = "Bot leaves party." },
            { label = "Release", command = "release", args = {}, tip = "Release spirit when dead." },
            { label = "Revive", command = "revive", args = {}, tip = "Revive near spirit healer." },
            { label = "LFG", command = "lfg", args = {}, tip = "Bot fills open group role." },
            { label = "LFG 5", command = "lfg", args = { "5" }, tip = "Request 5-man fill behavior." },
            { label = "Give Leader", command = "give", args = { "leader" }, tip = "Party leader passes leader role to master." },
        },
    },
    {
        title = "Combat",
        actions = {
            { label = "Tank", command = "co", args = { "+tank" }, tip = "Enable tank strategy." },
            { label = "Assist", command = "co", args = { "+assist" }, tip = "Enable assist strategy." },
            { label = "DPS", command = "co", args = { "+dps" }, tip = "Enable dps strategy." },
            { label = "Heal", command = "co", args = { "+heal" }, tip = "Enable heal strategy." },
            { label = "CC", command = "co", args = { "+cc" }, tip = "Enable crowd control strategy." },
            { label = "AOE", command = "co", args = { "+aoe" }, tip = "Enable aoe strategy." },
            { label = "Threat", command = "co", args = { "+threat" }, tip = "Reduce aggro stealing behavior." },
            { label = "Boost", command = "co", args = { "+boost" }, tip = "Enable burst cooldown usage." },
            { label = "No Boost", command = "co", args = { "-boost" }, tip = "Disable burst cooldown usage." },
            { label = "Focus", command = "co", args = { "+focus" }, tip = "Single-target focus mode." },
            { label = "Pull", command = "co", args = { "+pull" }, tip = "Enable pull strategy." },
            { label = "co ?", command = "co", args = { "?" }, tip = "Show current combat strategies." },
            { label = "co !", command = "co", args = { "!" }, tip = "Reset combat strategies." },
        },
    },
    {
        title = "NonCombat",
        actions = {
            { label = "nc ?", command = "nc", args = { "?" }, tip = "Show non-combat strategies." },
            { label = "nc !", command = "nc", args = { "!" }, tip = "Reset non-combat strategies." },
            { label = "Avoid AOE", command = "co", args = { "+avoid", "aoe" }, tip = "Avoid harmful aoe effects." },
            { label = "Save Mana", command = "co", args = { "+save", "mana" }, tip = "Prioritize mana efficient spells." },
            { label = "Healer DPS", command = "co", args = { "+healer", "dps" }, tip = "Allow healer damage when safe." },
            { label = "Behind", command = "co", args = { "+behind" }, tip = "Move to rear flank." },
            { label = "Wait Attack", command = "co", args = { "+wait", "for", "attack" }, tip = "Delay opening combat actions." },
            { label = "Disp Off", command = "disperse", args = { "disable" }, tip = "Disable disperse spacing." },
            { label = "Disp 10", command = "disperse", args = { "set", "10" }, tip = "Set 10y disperse distance." },
        },
    },
    {
        title = "Targeting",
        actions = {
            { label = "RTI Skull", command = "rti", args = { "skull" }, tip = "Focus skull icon target." },
            { label = "RTI Cross", command = "rti", args = { "cross" }, tip = "Focus cross icon target." },
            { label = "RTI Moon", command = "rti", args = { "moon" }, tip = "Focus moon icon target." },
            { label = "RTI CC Moon", command = "rti", args = { "cc", "moon" }, tip = "Set moon as crowd-control icon." },
            { label = "Atk RTI", command = "attack", args = { "rti", "target" }, tip = "Attack assigned rti target." },
            { label = "RTSC On", command = "rtsc", args = {}, tip = "Enable rtsc mode." },
            { label = "RTSC Off", command = "rtsc", args = { "cancel" }, tip = "Disable rtsc mode." },
            { label = "RTSC Go 1", command = "rtsc", args = { "go", "1" }, tip = "Move bots to saved point 1." },
            { label = "RTSC Save 1", command = "rtsc", args = { "save", "1" }, tip = "Save point 1 using aedm." },
            { label = "RTSC Unsave", command = "rtsc", args = { "unsave", "1" }, tip = "Clear saved point 1." },
            { label = "RTSC Toggle", command = "rtsc", args = { "toggle" }, tip = "Toggle click-position mode." },
            { label = "RTSC Restore", command = "rtsc", args = { "go", "save" }, tip = "Return bots to saved rtsc position." },
        },
    },
    {
        title = "Spells",
        actions = {
            { label = "Spells", command = "spells", args = {}, tip = "Show bot spell list." },
            { label = "Cast Heal", command = "cast", args = { "heal" }, tip = "Request cast command." },
            { label = "Trainer", command = "trainer", args = {}, tip = "Show trainer learn options." },
            { label = "Learn", command = "trainer", args = { "learn" }, tip = "Learn available trainer skills." },
            { label = "SS Reset", command = "ss", args = { "reset" }, tip = "Reset excluded spell list." },
            { label = "Focus ?", command = "focus", args = { "heal", "?" }, tip = "Show focus heal list." },
            { label = "Focus Clear", command = "focus", args = { "heal", "clear" }, tip = "Clear focus heal list." },
            { label = "Focus None", command = "focus", args = { "heal", "none" }, tip = "Clear focus heal list." },
        },
    },
    {
        title = "Maintenance",
        actions = {
            { label = "Maintenance", command = "maintenance", args = {}, tip = "Run maintenance tasks for bots." },
            { label = "Autogear", command = "autogear", args = {}, tip = "Auto gear setup." },
            { label = "Talents", command = "talents", args = {}, tip = "Show current talent spec." },
            { label = "Spec List", command = "talents", args = { "spec", "list" }, tip = "List available talent specs." },
            { label = "Glyphs", command = "glyphs", args = {}, tip = "Show equipped glyphs." },
            { label = "Reset BotAI", command = "reset", args = { "botAI" }, tip = "Reset bot AI settings." },
            { label = "Reset", command = "reset", args = {}, tip = "Reset active bot actions." },
            { label = "Status", command = "status", args = {}, tip = "Print addon status summary." },
            { label = "Info", command = "info", args = {}, tip = "Print addon info." },
        },
    },
}

local function stylePanel(frame)
    frame:SetBackdrop({
        bgFile = SOLID,
        edgeFile = SOLID,
        edgeSize = 1,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    frame:SetBackdropColor(palette.panel[1], palette.panel[2], palette.panel[3], palette.panel[4])
    frame:SetBackdropBorderColor(palette.gold[1], palette.gold[2], palette.gold[3], 1.0)
end

local function styleSection(frame)
    frame:SetBackdrop({
        bgFile = SOLID,
        edgeFile = SOLID,
        edgeSize = 1,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    frame:SetBackdropColor(palette.section[1], palette.section[2], palette.section[3], palette.section[4])
    frame:SetBackdropBorderColor(palette.border[1], palette.border[2], palette.border[3], palette.border[4])
end

local function styleButton(button)
    button:SetBackdrop({
        bgFile = SOLID,
        edgeFile = SOLID,
        edgeSize = 1,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    button:SetBackdropColor(palette.buttonDefault[1], palette.buttonDefault[2], palette.buttonDefault[3], palette.buttonDefault[4])
    button:SetBackdropBorderColor(palette.border[1], palette.border[2], palette.border[3], palette.border[4])
end

local function makeButton(parent, text, width, height)
    local button = CreateFrame("Button", nil, parent)
    button:SetWidth(width)
    button:SetHeight(height)
    styleButton(button)

    -- Soft top sheen for a modern glass-like finish.
    local sheen = button:CreateTexture(nil, "ARTWORK")
    sheen:SetTexture(SOLID)
    sheen:SetPoint("TOPLEFT", button, "TOPLEFT", 1, -1)
    sheen:SetPoint("TOPRIGHT", button, "TOPRIGHT", -1, -1)
    sheen:SetHeight(math.max(2, math.floor(height / 2)))
    sheen:SetGradientAlpha("VERTICAL", 1, 1, 1, 0.0, 1, 1, 1, 0.08)
    button.sheen = sheen

    -- Frost-gold hover glow (HIGHLIGHT layer shows automatically on mouseover).
    local glow = button:CreateTexture(nil, "HIGHLIGHT")
    glow:SetTexture(SOLID)
    glow:SetPoint("TOPLEFT", button, "TOPLEFT", 1, -1)
    glow:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -1, 1)
    glow:SetBlendMode("ADD")
    glow:SetVertexColor(palette.gold[1], palette.gold[2], palette.gold[3], 0.14)

    button.text = button:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    button.text:SetPoint("CENTER", button, "CENTER", 0, 0)
    button.text:SetTextColor(palette.text[1], palette.text[2], palette.text[3], palette.text[4])
    button.text:SetShadowColor(0, 0, 0, 0.85)
    button.text:SetShadowOffset(1, -1)
    button.text:SetText(text)
    button.baseColor = { palette.buttonDefault[1], palette.buttonDefault[2], palette.buttonDefault[3], palette.buttonDefault[4] }
    button:SetScript("OnMouseDown", function(self)
        self:SetBackdropColor(palette.buttonPress[1], palette.buttonPress[2], palette.buttonPress[3], palette.buttonPress[4])
        self:SetBackdropBorderColor(palette.goldBright[1], palette.goldBright[2], palette.goldBright[3], 1.0)
        self.text:SetPoint("CENTER", self, "CENTER", 0, -1)
    end)
    button:SetScript("OnMouseUp", function(self)
        local c = self.baseColor or palette.buttonDefault
        self:SetBackdropColor(c[1], c[2], c[3], c[4])
        local b = self.borderColor or palette.border
        self:SetBackdropBorderColor(b[1], b[2], b[3], b[4] or 1.0)
        self.text:SetPoint("CENTER", self, "CENTER", 0, 0)
    end)
    return button
end

local function getActionTint(action)
    local key = string.lower((action.label or "") .. " " .. (action.command or ""))

    if string.find(key, "attack") or string.find(key, "tank") or string.find(key, "grind") or string.find(key, "pull") or string.find(key, "threat") then
        return palette.toneAttack
    end

    if string.find(key, "heal") or string.find(key, "revive") or string.find(key, "focus") then
        return palette.toneHeal
    end

    if string.find(key, "follow") or string.find(key, "stay") or string.find(key, "flee") or string.find(key, "summon") or string.find(key, "disperse") then
        return palette.toneMove
    end

    return palette.toneSupport
end

local function bindTooltip(button, title, description)
    button:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(title, palette.text[1], palette.text[2], palette.text[3])
        GameTooltip:AddLine(description, palette.muted[1], palette.muted[2], palette.muted[3], true)
        GameTooltip:Show()
    end)
    button:SetScript("OnLeave", function() GameTooltip:Hide() end)
end

local function runAction(action)
    if PLAYERBOT and PLAYERBOT.Execute then
        local args = action.args or {}
        if action.argsFn then
            args = action.argsFn() or args
        end

        PLAYERBOT:Execute(action.command, args)
        if UI and UI.RefreshHeader then UI:RefreshHeader() end
    end
end

function UI:GetCurrentCategory()
    local index = self.categoryIndex or 1
    return commandCatalog[index], index
end

function UI:GetItemsPerPage()
    local category = self:GetCurrentCategory()
    return #category.actions
end

function UI:GetPageCount()
    local category = self:GetCurrentCategory()
    local itemsPerPage = self:GetItemsPerPage()
    local total = #category.actions
    local pages = math.ceil(total / itemsPerPage)
    if pages < 1 then pages = 1 end
    return pages
end

function UI:RenderCategoryButtons()
    if not self.categoryButtons then return end
    for i, button in ipairs(self.categoryButtons) do
        if i == self.categoryIndex then
            button.baseColor = { palette.catActive[1], palette.catActive[2], palette.catActive[3], palette.catActive[4] }
            button.borderColor = { palette.goldBright[1], palette.goldBright[2], palette.goldBright[3], 1.0 }
            button:SetBackdropColor(palette.catActive[1], palette.catActive[2], palette.catActive[3], palette.catActive[4])
            button:SetBackdropBorderColor(palette.goldBright[1], palette.goldBright[2], palette.goldBright[3], 1.0)
            button.text:SetTextColor(palette.dark[1], palette.dark[2], palette.dark[3], 1.0)
            button.text:SetShadowColor(0, 0, 0, 0)
            button.text:SetShadowOffset(0, 0)
            if button.marker then button.marker:Show() end
        else
            button.baseColor = { palette.catInactive[1], palette.catInactive[2], palette.catInactive[3], palette.catInactive[4] }
            button.borderColor = { palette.border[1], palette.border[2], palette.border[3], palette.border[4] }
            button:SetBackdropColor(palette.catInactive[1], palette.catInactive[2], palette.catInactive[3], palette.catInactive[4])
            button:SetBackdropBorderColor(palette.border[1], palette.border[2], palette.border[3], palette.border[4])
            button.text:SetTextColor(palette.text[1], palette.text[2], palette.text[3], 1.0)
            button.text:SetShadowColor(0, 0, 0, 0.85)
            button.text:SetShadowOffset(1, -1)
            if button.marker then button.marker:Hide() end
        end
    end
end

function UI:RenderActions()
    if not self.actionButtons then return end
    local category = self:GetCurrentCategory()
    local itemsPerPage = self:GetItemsPerPage()
    local startIndex = 1
    local itemsOnPage = #category.actions - startIndex + 1
    if itemsOnPage < 0 then
        itemsOnPage = 0
    end
    if itemsOnPage > itemsPerPage then
        itemsOnPage = itemsPerPage
    end

    if self.UpdateDynamicLayout then
        self:UpdateDynamicLayout(itemsOnPage)
    end

    if self.categoryLabel then self.categoryLabel:SetText(category.title .. " (" .. #category.actions .. ")") end
    for i, button in ipairs(self.actionButtons) do
        local action = category.actions[startIndex + i - 1]
        if action then
            button:Show()
            button.text:SetText(action.label)
            local tone = getActionTint(action)
            button.baseColor = { tone[1], tone[2], tone[3], tone[4] }
            button.borderColor = { tone[1] + 0.14, tone[2] + 0.14, tone[3] + 0.16, 1.0 }
            button:SetBackdropColor(tone[1], tone[2], tone[3], tone[4])
            button:SetBackdropBorderColor(button.borderColor[1], button.borderColor[2], button.borderColor[3], 1.0)
            button:SetScript("OnClick", function() runAction(action) end)
            bindTooltip(button, action.label, action.tip)
        else
            button:Hide()
            button:SetScript("OnClick", nil)
            button:SetScript("OnEnter", nil)
            button:SetScript("OnLeave", nil)
        end
    end
end

function UI:SelectCategory(index)
    self.categoryIndex = index
    self:RenderCategoryButtons()
    self:RenderActions()
end

function UI:RefreshHeader()
    if not self.frame then return end
    if self.lastSentLabel then
        local last = PLAYERBOT.lastSentCommand or ""
        local dest = PLAYERBOT.lastChatType or ""
        if last ~= "" and dest ~= "" then
            self.lastSentLabel:SetText("Last: [" .. dest .. "] " .. last)
        else
            self.lastSentLabel:SetText("Last: no command sent yet")
        end
    end
end

function UI:RefreshSections()
    self:RenderActions()
end

function UI:UpdateDynamicLayout(itemsOnPage)
    if not self.frame or not self.sideFrame or not self.browserFrame then
        return
    end

    local rowsUsed = math.ceil((itemsOnPage or 0) / layout.actionCols)
    if rowsUsed < 1 then
        rowsUsed = 1
    end

    local sideMinHeight = 168
    local browserNeeded = 56 + (rowsUsed * layout.actionButtonHeight) + ((rowsUsed - 1) * layout.actionGapY)
    local contentHeight = math.max(sideMinHeight, browserNeeded)

    self.sideFrame:SetHeight(contentHeight)
    self.browserFrame:SetHeight(contentHeight)

    local panelHeight = 46 + contentHeight
    if panelHeight < 214 then
        panelHeight = 214
    end

    self.frame:SetHeight(panelHeight)
end

function UI:Create()
    if self.frame then return end
    self.categoryIndex = 1
    local frame = CreateFrame("Frame", "PlayerBotControlPanel", UIParent)
    frame:SetWidth(layout.panelWidth)
    frame:SetHeight(layout.panelHeight)
    frame:SetPoint("CENTER", UIParent, "CENTER", 0, 4)
    frame:SetFrameStrata("DIALOG")
    frame:EnableMouse(true)
    frame:SetMovable(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
    frame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
    stylePanel(frame)
    self.frame = frame

    -- Header bar with warm gold gradient and a frost accent divider.
    local headerBar = frame:CreateTexture(nil, "BORDER")
    headerBar:SetTexture(SOLID)
    headerBar:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -2)
    headerBar:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -2, -2)
    headerBar:SetHeight(26)
    headerBar:SetGradientAlpha("VERTICAL", palette.header[1], palette.header[2], palette.header[3], 0.95, palette.header[1] + 0.05, palette.header[2] + 0.05, palette.header[3] + 0.06, 1.0)

    local headerGloss = frame:CreateTexture(nil, "ARTWORK")
    headerGloss:SetTexture(SOLID)
    headerGloss:SetPoint("TOPLEFT", headerBar, "TOPLEFT", 0, 0)
    headerGloss:SetPoint("TOPRIGHT", headerBar, "TOPRIGHT", 0, 0)
    headerGloss:SetHeight(12)
    headerGloss:SetGradientAlpha("VERTICAL", 1, 1, 1, 0.0, 1, 1, 1, 0.07)

    local divider = frame:CreateTexture(nil, "OVERLAY")
    divider:SetTexture(SOLID)
    divider:SetPoint("TOPLEFT", headerBar, "BOTTOMLEFT", 0, 0)
    divider:SetPoint("TOPRIGHT", headerBar, "BOTTOMRIGHT", 0, 0)
    divider:SetHeight(1)
    divider:SetVertexColor(palette.gold[1], palette.gold[2], palette.gold[3], 0.95)

    local dividerGlow = frame:CreateTexture(nil, "OVERLAY")
    dividerGlow:SetTexture(SOLID)
    dividerGlow:SetPoint("TOPLEFT", divider, "BOTTOMLEFT", 0, 0)
    dividerGlow:SetPoint("TOPRIGHT", divider, "BOTTOMRIGHT", 0, 0)
    dividerGlow:SetHeight(2)
    dividerGlow:SetGradientAlpha("VERTICAL", palette.frost[1], palette.frost[2], palette.frost[3], 0.0, palette.frost[1], palette.frost[2], palette.frost[3], 0.35)

    local crest = frame:CreateTexture(nil, "ARTWORK")
    crest:SetTexture("Interface\\Icons\\INV_Misc_Head_Dragon_01")
    crest:SetWidth(18)
    crest:SetHeight(18)
    crest:SetPoint("LEFT", headerBar, "LEFT", 8, 0)
    crest:SetTexCoord(0.08, 0.92, 0.08, 0.92)

    local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("LEFT", crest, "RIGHT", 7, 0)
    title:SetTextColor(palette.goldBright[1], palette.goldBright[2], palette.goldBright[3], 1.0)
    title:SetShadowColor(0, 0, 0, 0.9)
    title:SetShadowOffset(1, -1)
    title:SetText("PlayerBot Control")
    local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -2, -1)
    local side = CreateFrame("Frame", nil, frame)
    side:SetWidth(layout.sideWidth)
    side:SetHeight(layout.browserHeight)
    side:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -36)
    styleSection(side)
    self.sideFrame = side

    local browser = CreateFrame("Frame", nil, frame)
    browser:SetWidth(layout.browserWidth)
    browser:SetHeight(layout.browserHeight)
    browser:SetPoint("TOPLEFT", side, "TOPRIGHT", 8, 0)
    styleSection(browser)
    self.browserFrame = browser
    self.categoryButtons = {}
    for i, category in ipairs(commandCatalog) do
        local button = makeButton(side, category.title, 84, 22)
        button:SetPoint("TOPLEFT", side, "TOPLEFT", 10, -8 - ((i - 1) * 26))
        local marker = button:CreateTexture(nil, "OVERLAY")
        marker:SetTexture(SOLID)
        marker:SetPoint("TOPLEFT", button, "TOPLEFT", 1, -1)
        marker:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", 1, 1)
        marker:SetWidth(3)
        marker:SetVertexColor(palette.dark[1], palette.dark[2], palette.dark[3], 0.85)
        marker:Hide()
        button.marker = marker
        button:SetScript("OnClick", function() UI:SelectCategory(i) end)
        bindTooltip(button, category.title, "Show commands in " .. category.title .. " category.")
        self.categoryButtons[i] = button
    end
    self.categoryLabel = browser:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.categoryLabel:SetPoint("TOPLEFT", browser, "TOPLEFT", 10, -10)
    self.categoryLabel:SetTextColor(palette.gold[1], palette.gold[2], palette.gold[3], 1.0)
    self.categoryLabel:SetShadowColor(0, 0, 0, 0.85)
    self.categoryLabel:SetShadowOffset(1, -1)
    self.categoryLabel:SetText("General")
    self.actionButtons = {}
    local maxActions = 0
    for _, category in ipairs(commandCatalog) do
        if #category.actions > maxActions then
            maxActions = #category.actions
        end
    end
    local rows = math.ceil(maxActions / layout.actionCols)

    for row = 1, rows do
        for col = 1, layout.actionCols do
            local idx = ((row - 1) * layout.actionCols) + col
            local btn = makeButton(browser, "", layout.actionButtonWidth, layout.actionButtonHeight)
            local x = 7 + ((col - 1) * (layout.actionButtonWidth + layout.actionGapX))
            local y = -31 - ((row - 1) * (layout.actionButtonHeight + layout.actionGapY))
            btn:SetPoint("TOPLEFT", browser, "TOPLEFT", x, y)
            self.actionButtons[idx] = btn
        end
    end
    self.lastSentLabel = nil
    self:RenderCategoryButtons()
    self:RenderActions()
    self:RefreshHeader()
    self.frame:Hide()
end

function PLAYERBOT:ToggleUI()
    UI:Create()
    if UI.frame:IsShown() then
        self.uiUserVisible = false
        UI.frame:Hide()
    else
        self.uiUserVisible = true
        UI.frame:Show()
    end
end
