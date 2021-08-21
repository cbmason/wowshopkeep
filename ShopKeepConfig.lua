-- ShopKeepConfig.lua

-- Implements the interface options screen

-- Copyright © 2021 Zensmash  <archerrez4@gmail.com>

-- Note, the commented out blocks of code are for debug mode.  Uncommenting this code will open up
-- extra options on the config screen that enable debug mode, which allows test queries and such


local _G = getfenv(0)
local addonName, addonData = ...
local L = addonData.L
local wipe  = wipe

local Options = CreateFrame("Frame", "ShopKeepOptions", InterfaceOptionsFramePanelContainer, _G.BackdropTemplateMixin and "BackdropTemplate" or nil)
Options.name = addonName

InterfaceOptions_AddCategory(Options)

Options:Hide();
Options:SetScript("OnShow", function(self)

    ---------------------------------------------------------------------------
    -- Helper Functions
    ---------------------------------------------------------------------------

    -- element factories
    local function makeCheckbox(label, description, onClick)
        local check = CreateFrame("CheckButton", "ShopKeep_Checkbox_"..label, self, "InterfaceOptionsCheckButtonTemplate")
        check:SetScript("OnClick", function(self)
            local click = self:GetChecked() and 856 or 857
            PlaySound(click) onClick(self, self:GetChecked() and true or false)
            end)
        check.label = _G[check:GetName().."Text"]
        check.label:SetText(label)
        check.tooltipText = label
        check.tooltipRequirement = description
        return check
    end

    local function makeEditBox(fname, height, width)
        local editbox = CreateFrame("EditBox", fname, self, _G.BackdropTemplateMixin and "BackdropTemplate" or nil)
        editbox:SetSize(width, height)
        editbox:ClearFocus(self)
        editbox:SetAutoFocus(false)
        editbox:EnableMouse(true)
        editbox:SetTextInsets(10,0,0,0)
        editbox:SetFontObject(ChatFontNormal)
        editbox:SetText("")
        editbox:SetBackdrop({
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
            edgeSize = 16,
            insets = { left = 4, right = 3, top = 4, bottom = 3 }
            })
        editbox:SetScript("OnEscapePressed", editbox.ClearFocus)
        editbox:SetScript("OnTabPressed", editbox.ClearFocus)
        return editbox
    end

    local function makeButton(fname, height, width)
        local testbutton = CreateFrame("Button", fname, self, "OptionsButtonTemplate")
        testbutton:SetSize(width, height)
        return testbutton
    end

    local function makeLabel(text)
        local label = Options:CreateFontString(Options, "ARTWORK", "GameFontNormal")
        label:SetText(text)
        return label
    end

    local function makeDropDown(fname, width)
        local testDropdown = CreateFrame("Frame", fname, self, "UIDropDownMenuTemplate")
        local info = {}

        function testDropdown:dropDown_OnClick(arg1)
            UIDropDownMenu_SetText(testDropdown, arg1)
            _G.SHOP_DBPC["max_items"] = arg1
            CloseDropDownMenus()
        end

        testDropdown.initialize = function()
            wipe(info)
            for i=3, 10, 1 do
                info.text = i
                info.value = i
                info.arg1 = i
                info.func = testDropdown.dropDown_OnClick
                info.checked = _G.SHOP_DBPC["max_items"] == i
                UIDropDownMenu_AddButton(info)
            end
        end
        UIDropDownMenu_SetText(testDropdown, _G.SHOP_DBPC["max_items"])
        UIDropDownMenu_SetWidth(testDropdown, width)
        return testDropdown
    end

    -- other helper functions
    local function enableUI()
        shopkeep_onSayCheckbox:Enable()
        shopkeep_onSayCheckbox.label:SetTextColor(1, 1, 1)
        shopkeep_onGchatCheckbox:Enable()
        shopkeep_onGchatCheckbox.label:SetTextColor(1, 1, 1)
        shopkeep_onPartyCheckbox:Enable()
        shopkeep_onPartyCheckbox.label:SetTextColor(1, 1, 1)
        shopkeep_onRaidCheckbox:Enable()
        shopkeep_onRaidCheckbox.label:SetTextColor(1, 1, 1)
        -- shopkeep_DebugmodeCheckbox:Enable()
        -- shopkeep_DebugmodeCheckbox.label:SetTextColor(1, 1, 1)
    end

    local function disableUI()
        shopkeep_onSayCheckbox:Disable()
        shopkeep_onSayCheckbox.label:SetTextColor(0.5, 0.5, 0.5)
        shopkeep_onGchatCheckbox:Disable()
        shopkeep_onGchatCheckbox.label:SetTextColor(0.5, 0.5, 0.5)
        shopkeep_onPartyCheckbox:Disable()
        shopkeep_onPartyCheckbox.label:SetTextColor(0.5, 0.5, 0.5)
        shopkeep_onRaidCheckbox:Disable()
        shopkeep_onRaidCheckbox.label:SetTextColor(0.5, 0.5, 0.5)
        -- shopkeep_DebugmodeCheckbox:Disable()
        -- shopkeep_DebugmodeCheckbox.label:SetTextColor(0.5, 0.5, 0.5)
    end

    ---------------------------------------------------------------------------
    -- ITEM CREATION
    ---------------------------------------------------------------------------

    -- Config Title
    local TitleOptions = self:CreateFontString("$parentTitleOptions", "ARTWORK", "GameFontNormalLarge")
    TitleOptions:SetPoint("TOPLEFT", 16, -16)
    TitleOptions:SetText(_G.SHOP_DB.Color1..addonName)

    -- version
    local VersionOptions = self:CreateFontString("$parentTitleOptions", "ARTWORK", "GameFontNormal");
    VersionOptions:SetPoint("TOPRIGHT", -16, -17)
    VersionOptions:SetJustifyH("RIGHT")
    VersionOptions:SetText(_G.SHOP_DB["Color2"].._G.SHOP_DB["Version"])

    -- Enabled
    shopkeep_EnabledCheckbox = makeCheckbox(
        L["Checkbox_Enable"] ,
        L["Checkbox_Enable_Desc"] ,
        function(self, value)
            _G.SHOP_DBPC["enabled"] = value
            if _G.SHOP_DBPC["enabled"] then
                -- ShopKeep_Enable()
                ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", addonData.methods.onWhisper)
                enableUI()
                if _G.SHOP_DBPC["onSay"] then
                    ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", addonData.methods.onWhisper)
                end
                if _G.SHOP_DBPC["onGchat"] then
                    ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", addonData.methods.onWhisper)
                end
                if _G.SHOP_DBPC["onParty"] then
                    ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", addonData.methods.onWhisper)
                end
                if _G.SHOP_DBPC["Checkbox_onRaid"] then
                    ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", addonData.methods.onWhisper)
                end
            else
                -- ShopKeep_Disable()
                ChatFrame_RemoveMessageEventFilter("CHAT_MSG_WHISPER", addonData.methods.onWhisper)
                disableUI()
                if _G.SHOP_DBPC["onSay"] then
                    ChatFrame_RemoveMessageEventFilter("CHAT_MSG_SAY", addonData.methods.onWhisper)
                end
                if _G.SHOP_DBPC["onGchat"] then
                    ChatFrame_RemoveMessageEventFilter("CHAT_MSG_GUILD", addonData.methods.onWhisper)
                end
                if _G.SHOP_DBPC["onParty"] then
                    ChatFrame_RemoveMessageEventFilter("CHAT_MSG_PARTY", addonData.methods.onWhisper)
                end
                if _G.SHOP_DBPC["Checkbox_onRaid"] then
                    ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID", addonData.methods.onWhisper)
                end
            end
        end
    )

    -- onSay
    shopkeep_onSayCheckbox = makeCheckbox(
        L["Checkbox_onSay"] ,
        L["Checkbox_onSay_Desc"] ,
        function(self, value)
            _G.SHOP_DBPC["onSay"] = value
            if _G.SHOP_DBPC["onSay"] and _G.SHOP_DBPC["enabled"] then
                ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", addonData.methods.onWhisper)
            else
                ChatFrame_RemoveMessageEventFilter("CHAT_MSG_SAY", addonData.methods.onWhisper)
            end
        end
    )

    -- onGchat
    shopkeep_onGchatCheckbox = makeCheckbox(
        L["Checkbox_onGchat"] ,
        L["Checkbox_onGchat_Desc"] ,
        function(self, value)
            _G.SHOP_DBPC["onGchat"] = value
            if _G.SHOP_DBPC["onGchat"] and _G.SHOP_DBPC["enabled"] then
                ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", addonData.methods.onWhisper)
            else
                ChatFrame_RemoveMessageEventFilter("CHAT_MSG_GUILD", addonData.methods.onWhisper)
            end
        end
    )

    -- onParty
    shopkeep_onPartyCheckbox = makeCheckbox(
        L["Checkbox_onParty"] ,
        L["Checkbox_onParty_Desc"] ,
        function(self, value)
            _G.SHOP_DBPC["onParty"] = value
            if _G.SHOP_DBPC["onParty"] and _G.SHOP_DBPC["enabled"] then
                ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", addonData.methods.onWhisper)
            else
                ChatFrame_RemoveMessageEventFilter("CHAT_MSG_PARTY", addonData.methods.onWhisper)
            end
        end
    )

    -- onRaid
    shopkeep_onRaidCheckbox = makeCheckbox(
        L["Checkbox_onRaid"] ,
        L["Checkbox_onRaid_Desc"] ,
        function(self, value)
            _G.SHOP_DBPC["onRaid"] = value
            if _G.SHOP_DBPC["onRaid"] and _G.SHOP_DBPC["enabled"] then
                ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", addonData.methods.onWhisper)
            else
                ChatFrame_RemoveMessageEventFilter("CHAT_MSG_RAID", addonData.methods.onWhisper)
            end
        end
    )

    -- max items box
    maxItemsLabel = makeLabel(L["Max Recipes"])
    maxItemsDropdown = makeDropDown("maxItemsDropdown", 50)

    -- Debug Mode
    -- shopkeep_DebugmodeCheckbox = makeCheckbox(
    --     L["Checkbox_Debugmode"],
    --     L["Checkbox_Debugmode_Desc"],
    --     function(self, value)
    --         _G.SHOP_DBPC["debugmode"] = value
    --     end
    -- )
    -- debugBox = makeEditBox("debugBox", 50, 400)
    -- debugButton = makeButton("debugButton", 25, 100)
    -- debugButton:SetText("Test!")
    -- printAllButton = makeButton("printAllButton", 25, 100)
    -- printAllButton:SetText("Dump Data!")

    -- local function debugButton_OnClick()
    --     if _G.SHOP_DBPC["debugmode"] and _G.SHOP_DBPC["enabled"] then
    --         addonData.methods.doResponse(debugBox:GetText(), nil, true)
    --     end
    -- end

    -- local function printAllButton_OnClick()
    --     PrintAllShopData()
    -- end

    -- debugButton:SetScript("OnClick", debugButton_OnClick )
    -- printAllButton:SetScript("OnClick", printAllButton_OnClick )

    ---------------------------------------------------------------------------
    -- LAYOUT
    ---------------------------------------------------------------------------

    -- Set up main checkboxes
    local offset = -20
    shopkeep_EnabledCheckbox:SetChecked(_G.SHOP_DBPC["enabled"]);
    shopkeep_EnabledCheckbox:SetPoint("TOPLEFT", TitleOptions, "BOTTOMLEFT", 0, offset);

    local enables_x_offset = 20
    offset = offset -25
    shopkeep_onSayCheckbox:SetChecked(_G.SHOP_DBPC["onSay"]);
    shopkeep_onSayCheckbox:SetPoint("TOPLEFT", TitleOptions, "BOTTOMLEFT", enables_x_offset, offset);

    offset = offset -25
    shopkeep_onGchatCheckbox:SetChecked(_G.SHOP_DBPC["onGchat"]);
    shopkeep_onGchatCheckbox:SetPoint("TOPLEFT", TitleOptions, "BOTTOMLEFT", enables_x_offset, offset);

    offset = offset -25
    shopkeep_onPartyCheckbox:SetChecked(_G.SHOP_DBPC["onParty"]);
    shopkeep_onPartyCheckbox:SetPoint("TOPLEFT", TitleOptions, "BOTTOMLEFT", enables_x_offset, offset);

    offset = offset -25
    shopkeep_onRaidCheckbox:SetChecked(_G.SHOP_DBPC["onRaid"]);
    shopkeep_onRaidCheckbox:SetPoint("TOPLEFT", TitleOptions, "BOTTOMLEFT", enables_x_offset, offset);

    -- max items
    offset = offset -45
    maxItemsLabel:SetPoint("TOPLEFT", TitleOptions, "BOTTOMLEFT", 0, offset);
    maxItemsDropdown:SetPoint("TOPLEFT", TitleOptions, "BOTTOMLEFT", 75, offset);

    -- Debug buttons / box / checkmark
    -- offset = offset -150
    -- if _G.SHOP_DBPC["enabled"] then shopkeep_DebugmodeCheckbox:Enable(); end
    -- shopkeep_DebugmodeCheckbox:SetChecked(_G.SHOP_DBPC["debugmode"]);
    -- shopkeep_DebugmodeCheckbox:SetPoint("TOPLEFT", TitleOptions, "BOTTOMLEFT", 0, offset);

    -- offset = offset -45
    -- debugBox:SetPoint("TOPLEFT", TitleOptions, "BOTTOMLEFT", 0, offset);
    -- debugButton:SetPoint("TOPLEFT", TitleOptions, "BOTTOMLEFT", 410, offset);
    -- offset = offset -25
    -- printAllButton:SetPoint("TOPLEFT", TitleOptions, "BOTTOMLEFT", 410, offset);

    ---------------------------------------------------------------------------
    -- Initialization behavior
    ---------------------------------------------------------------------------

    if _G.SHOP_DBPC["enabled"] then
        enableUI()
    else
        disableUI()
    end

  self:SetScript("OnShow", nil);
end
)
