--TODO: add option for max messages
--TODO:

-- Copyright © 2021 Zensmash  <archerrez4@gmail.com>
-- All Rights Reserved.
-- This code is not to be modified or distributed without written permission by the author.

-- Options dialog

local _G = getfenv(0)
local addonName, addonData = ...
local L = addonData.L

local Options = CreateFrame("Frame", "ShopKeepOptions", InterfaceOptionsFramePanelContainer, _G.BackdropTemplateMixin and "BackdropTemplate" or nil)
Options.name = addonName

InterfaceOptions_AddCategory(Options)

-- if not isClassic then
--     if Options then
--         Mixin(Options, BackdropTemplateMixin)
--     end
-- end

local function myprint(msg)
    print(_G.SHOP_DB.Color1..addonName..": ".._G.SHOP_DB.Color1..msg)
end

Options:Hide();
Options:SetScript("OnShow", function(self)
    local offset = 0
    local function makeCheckbox(label, description, onClick)
        local check = CreateFrame("CheckButton", "ShopKeep_Checkbox_"..label, self, "InterfaceOptionsCheckButtonTemplate")
        check:SetScript("OnClick", function(self)
            -- 856 = igMainMenuOptionCheckBoxOn
            -- 857 = igMainMenuOptionCheckBoxOff
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

    local function enableUI()
        shopkeep_onSayCheckbox:Enable()
        shopkeep_onSayCheckbox.label:SetTextColor(1, 1, 1)
        shopkeep_onGchatCheckbox:Enable()
        shopkeep_onGchatCheckbox.label:SetTextColor(1, 1, 1)
        shopkeep_onPartyCheckbox:Enable()
        shopkeep_onPartyCheckbox.label:SetTextColor(1, 1, 1)
        shopkeep_onRaidCheckbox:Enable()
        shopkeep_onRaidCheckbox.label:SetTextColor(1, 1, 1)
        shopkeep_DebugmodeCheckbox:Enable()
        shopkeep_DebugmodeCheckbox.label:SetTextColor(1, 1, 1)
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
        shopkeep_DebugmodeCheckbox:Disable()
        shopkeep_DebugmodeCheckbox.label:SetTextColor(0.5, 0.5, 0.5)

    end

    -- Config Title
    local TitleOptions = self:CreateFontString("$parentTitleOptions", "ARTWORK", "GameFontNormalLarge")
    TitleOptions:SetPoint("TOPLEFT", 16, -16)
    TitleOptions:SetText(_G.SHOP_DB.Color1..addonName)

    -- version
    local VersionOptions = self:CreateFontString("$parentTitleOptions", "ARTWORK", "GameFontNormal");
    VersionOptions:SetPoint("TOPRIGHT", -16, -17)
    VersionOptions:SetJustifyH("RIGHT")
    -- VersionOptions:SetText(_G.SHOP_DB["Color2"]..L["Version"].._G.SHOP_DB.Version)
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
                -- ChatFrame_RemoveMessageEventFilter("CHAT_MSG_WHISPER_INFORM", onResponse)
            end
        end
    )

    -- onSay
    shopkeep_onSayCheckbox = makeCheckbox(
        L["Checkbox_onSay"] ,
        L["Checkbox_onSay_Desc"] ,
        function(self, value)
            -- master_enable = _G.SHOP_DBPC["onSay"]
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

    -- Debug Mode
    shopkeep_DebugmodeCheckbox = makeCheckbox(
        L["Checkbox_Debugmode"],
        L["Checkbox_Debugmode_Desc"],
        function(self, value)
            _G.SHOP_DBPC["debugmode"] = value
            if _G.SHOP_DBPC["debugmode"] then
                -- enable the debug box
            else
                -- disable the debug box
            end
        end
    )

    --debugBox = CreateFrame("CheckButton", "ShopKeep_Checkbox_"..label, self, "InterfaceOptionsCheckButtonTemplate")

    debugBox = makeEditBox("debugBox", 50, 400)

    debugButton = makeButton("debugButton", 25, 100)
    debugButton:SetText("Test!")
    printAllButton = makeButton("printAllButton", 25, 100)
    printAllButton:SetText("Dump Data!")
    --debugButton.func

    local function debugButton_OnClick()
        -- print(string.format("debug: called handler %i, %i", _G.SHOP_DBPC["debugmode"], _G.SHOP_DBPC["enabled"]))
        if _G.SHOP_DBPC["debugmode"] and _G.SHOP_DBPC["enabled"] then
            addonData.methods.doResponse(debugBox:GetText(), nil, true)
        end
    end

    local function printAllButton_OnClick()
        PrintAllShopData()
    end

    debugButton:SetScript("OnClick", debugButton_OnClick )
    printAllButton:SetScript("OnClick", printAllButton_OnClick )

    -- Set up layout
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

    offset = offset -45
    if _G.SHOP_DBPC["enabled"] then shopkeep_DebugmodeCheckbox:Enable(); end
    shopkeep_DebugmodeCheckbox:SetChecked(_G.SHOP_DBPC["debugmode"]);
    shopkeep_DebugmodeCheckbox:SetPoint("TOPLEFT", TitleOptions, "BOTTOMLEFT", 0, offset);

    -- Debug button / box
    offset = offset -45
    debugBox:SetPoint("TOPLEFT", TitleOptions, "BOTTOMLEFT", 0, offset);
    debugButton:SetPoint("TOPLEFT", TitleOptions, "BOTTOMLEFT", 410, offset);
    offset = offset -25
    printAllButton:SetPoint("TOPLEFT", TitleOptions, "BOTTOMLEFT", 410, offset);

    if _G.SHOP_DBPC["enabled"] then
        enableUI()
    else
        disableUI()
    end

  self:SetScript("OnShow", nil);
end
)
