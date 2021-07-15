
-- Copyright © 2021 Zensmash  <archerrez4@gmail.com>
-- All Rights Reserved.
-- This code is not to be modified or distributed without written permission by the author.

-- Options dialog

-- TODO: commit, then redo this using AceConfig, add the test run


local _G = getfenv(0)
local addonName, addonData = ...
local L = addonData.L

local Options = CreateFrame("Frame", "ShopKeepOptions", InterfaceOptionsFramePanelContainer, _G.BackdropTemplateMixin and "BackdropTemplate" or nil)
Options.name = addonName

InterfaceOptions_AddCategory(Options)

if not isClassic then
    if Options then
        Mixin(Options, BackdropTemplateMixin)
    end
end

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

    -- Config Title
    local TitleOptions = self:CreateFontString("$parentTitleOptions", "ARTWORK", "GameFontNormalLarge")
    TitleOptions:SetPoint("TOPLEFT", 16, -16)
    TitleOptions:SetText(_G.AWI_DB.Color1..addonName)

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
                -- ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", onResponse)

            else
                -- ShopKeep_Disable()
                ChatFrame_RemoveMessageEventFilter("CHAT_MSG_WHISPER", addonData.methods.onWhisper)
                -- ChatFrame_RemoveMessageEventFilter("CHAT_MSG_WHISPER_INFORM", onResponse)
            end
        end
    )
    local offset = -20
    shopkeep_EnabledCheckbox:SetChecked(_G.SHOP_DBPC["enabled"]);
    shopkeep_EnabledCheckbox:SetPoint("TOPLEFT", TitleOptions, "BOTTOMLEFT", 0, offset);

-- onSay
    shopkeep_onSayCheckbox = makeCheckbox(
        L["Checkbox_onSay"] ,
        L["Checkbox_onSay_Desc"] ,
        function(self, value)
            -- master_enable = _G.SHOP_DBPC["onSay"]
            _G.SHOP_DBPC["onSay"] = value
            -- if _G.SHOP_DBPC["onSay"] and master_enable then
            --     ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", onWhisper)
            -- else
            --     ChatFrame_RemoveMessageEventFilter("CHAT_MSG_SAY", onWhisper)
            -- end
        end
    )
    local enables_x_offset = 20
    offset = offset -25
    shopkeep_onSayCheckbox:SetChecked(_G.SHOP_DBPC["onSay"]);
    shopkeep_onSayCheckbox:SetPoint("TOPLEFT", TitleOptions, "BOTTOMLEFT", enables_x_offset, offset);

-- onGchat
    shopkee_onGchatCheckbox = makeCheckbox(
        L["Checkbox_onGchat"] ,
        L["Checkbox_onGchat_Desc"] ,
        function(self, value)
            _G.SHOP_DBPC["onGchat"] = value
            -- if _G.SHOP_DBPC["onGchat"] then
            --     ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", onWhisper)
            -- else
            --     ChatFrame_RemoveMessageEventFilter("CHAT_MSG_GUILD", onWhisper)
            -- end
        end
    )
    offset = offset -25
    shopkee_onGchatCheckbox:SetChecked(_G.SHOP_DBPC["onGchat"]);
    shopkee_onGchatCheckbox:SetPoint("TOPLEFT", TitleOptions, "BOTTOMLEFT", enables_x_offset, offset);

-- onParty
    shopkeep_onPartyCheckbox = makeCheckbox(
        L["Checkbox_onParty"] ,
        L["Checkbox_onParty_Desc"] ,
        function(self, value)
            _G.SHOP_DBPC["onParty"] = value
            -- if _G.SHOP_DBPC["onParty"] then
            --     ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", onWhisper)
            -- else
            --     ChatFrame_RemoveMessageEventFilter("CHAT_MSG_PARTY", onWhisper)
            -- end
        end
    )
    offset = offset -25
    shopkeep_onPartyCheckbox:SetChecked(_G.SHOP_DBPC["onParty"]);
    shopkeep_onPartyCheckbox:SetPoint("TOPLEFT", TitleOptions, "BOTTOMLEFT", enables_x_offset, offset);

-- onRaid
    shopkeep_onRaidCheckbox = makeCheckbox(
        L["Checkbox_onRaid"] ,
        L["Checkbox_onRaid_Desc"] ,
        function(self, value)
            _G.SHOP_DBPC["onRaid"] = value
            -- if _G.SHOP_DBPC["onRaid"] then
            --     ChatFrame_AddMessageEventFilter("CHAT MSG RAID", onWhisper)
            -- else
            --     ChatFrame_RemoveMessageEventFilter("CHAT MSG RAID", onWhisper)
            -- end
        end
    )
    offset = offset -25
    shopkeep_onRaidCheckbox:SetChecked(_G.SHOP_DBPC["onRaid"]);
    shopkeep_onRaidCheckbox:SetPoint("TOPLEFT", TitleOptions, "BOTTOMLEFT", enables_x_offset, offset);


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
    offset = offset -45
    shopkeep_DebugmodeCheckbox:SetChecked(_G.SHOP_DBPC["debugmode"]);
    shopkeep_DebugmodeCheckbox:SetPoint("TOPLEFT", TitleOptions, "BOTTOMLEFT", 0, offset);


  self:SetScript("OnShow", nil);
end
)

-- -- RegisterEvents
-- local ShopKeep_Eventframe = CreateFrame("FRAME")
-- ShopKeep_Eventframe:RegisterEvent("ADDON_LOADED")
-- ShopKeep_Eventframe:RegisterEvent("PLAYER_LOGIN")

-- local function ShopKeep_OnEvent(self, event, arg1, arg2, ...)
--     if event == "ADDON_LOADED" and arg1 == addonName then
--         --myprint(L["Addon_Loaded"])
--         ShopKeepConfig_Loaded = true
--         ShopKeep_Eventframe:UnregisterEvent("ADDON_LOADED")
--     end
--     if event == "PLAYER_LOGIN" and ShopKeepConfig_Loaded then
--         --myprint(L["Player_Loaded"])
--         _G.SHOP_DB.Color1 = color1
--         _G.SHOP_DB.Color2 = color2
--         _G.SHOP_DB["Version"] = GetAddOnMetadata(addonName, "X-Version")

--         -- Initialize if new variable added

--         -- if _G.SHOP_DBPC["AllInvite"] == nil then
--         --     _G.SHOP_DBPC.AllInvite = false
--         -- end
--         ShopKeep_Eventframe:UnregisterEvent("PLAYER_LOGIN")
--     end
-- end

-- THIS IS THE MAIN ENTRY POINT main()

-- ShopKeep_Eventframe:SetScript("OnEvent", ShopKeep_OnEvent)
