-- Copyright © 2021 Zensmash  <archerrez4@gmail.com>
-- All Rights Reserved.
-- This code is not to be modified or distributed without written permission by the author.

local _G = getfenv(0)

_G.SHOP_DB = {
    debugmode = False,
    color1 = "|cff3399ff",
    color2 = "|cff1eff00",
    Version = GetAddOnMetadata(addon, "X-Version"),
    keyword = "shop",
    max_items = 5
}

_G.SHOP_DBPC = {
    enabled = True
}

local isRetail = (_G.WOW_PROJECT_ID == _G.WOW_PROJECT_MAINLINE)
local isClassic = (_G.WOW_PROJECT_ID == _G.WOW_PROJECT_CLASSIC)
local isTBC = (_G.WOW_PROJECT_ID == _G.WOW_PROJECT_BURNING_CRUSADE_CLASSIC)





-- Options dialog
-- TODO: put this in its own file

local Options = CreateFrame("Frame", "ShopKeepOptions", InterfaceOptionsFramePanelContainer, _G.BackdropTemplateMixin and "BackdropTemplate" or nil)
Options.name = addon

InterfaceOptions_AddCategory(Options)

if not isClassic then
    if Options then
        Mixin(Options, BackdropTemplateMixin)
    end
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
        PlaySound(click) onClick(self, self:GetChecked() and true or false)    end)
        check.label = _G[check:GetName().."Text"]
        check.label:SetText(label)
        check.tooltipText = label
        check.tooltipRequirement = description
        return check
    end

    -- Config Title
    local TitleOptions = self:CreateFontString("$parentTitleOptions", "ARTWORK", "GameFontNormalLarge")
    TitleOptions:SetPoint("TOPLEFT", 16, -16)
    TitleOptions:SetText(_G.SHOP_DB.Color1..addon)

    -- version
    local VersionOptions = self:CreateFontString("$parentTitleOptions", "ARTWORK", "GameFontNormal");
    VersionOptions:SetPoint("TOPRIGHT", -16, -17)
    VersionOptions:SetJustifyH("RIGHT")
    VersionOptions:SetText(_G.SHOP_DB.Color2..L["Version"].._G.SHOP_DB.Version)

    -- Enabled
    shopkeepEnabledCheckbox = makeCheckbox(
        L["BTN1"] ,
        L["BTND1"] ,    -- description
        function(self, value)
        _G.SHOP_DBPC.enabled = value
        if _G.SHOP_DBPC.enabled then
            ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", onWhisper)
            ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", onResponse)
            -- ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", AWIBN_filter)
        else
            ChatFrame_RemoveMessageEventFilter("CHAT_MSG_WHISPER", onWhisper)
            ChatFrame_RemoveMessageEventFilter("CHAT_MSG_WHISPER_INFORM", onResponse)
            -- ChatFrame_RemoveMessageEventFilter("CHAT_MSG_BN_WHISPER", AWIBN_filter)
        end
        end);    -- onClick functions or commands
    local offset = -20
    shopkeepEnabledCheckbox:SetChecked(_G.SHOP_DBPC.enabled);
    shopkeepEnabledCheckbox:SetPoint("TOPLEFT", TitleOptions, "BOTTOMLEFT", 0, offset);





local function OnLoad()
    if ShopKeep.ABORTLOAD then
        -- Don't try to run if therre were errors
        return
    end
    -- Check config options
    -- Make profession table
    BuildShopTable()
end


-- https://wow.gamepedia.com/CHAT_MSG_WHISPER
local function onWhisper(self, event, msg, sender, _, _, _, _, _, _, _, _, lineID, guid, bnetIDAccount, isMobile)
    local not_finished = false
    -- filter for keywords
    tokens = mysplit(msg)
    -- if keywords found, handle
    if tokens[0] == _G.AWI_DB.keyword then
        -- get list of matching recipes
        tokens.remove(0)
        matches = GetMatchingItems(tokens)
        if next(matches) == nil then
            --no matches, print error string
            send_response(L["NO_MATCHES_FOUND"], sender)
        else
            --send the matches
            send_response(L["MATCHES_FOUND"], sender)
            for i, v in ipairs(matches) do
                if i >= _G.SHOP_DB.max_items then
                    not_finished = true
                    break
                else
                    send_response(v, sender)
                end
            end
            if not_finished then
                send_response(L["MORE_ITEMS"], sender)
            end
        end
    end
end


local function send_response(msg, sender)
    if _G.SHOP_DB.debugmode then
        -- if debug mode, redirect to debug
        print(msg)
    else
        --otherwise, whisper the sender
        SendChatMessage(msg, "WHISPER", nil, sender)
    end

end


-- local function onResponse()
--     if _G.SHOP_DB.debugmode then
--         PRINT TO DEBUG BOX
--     else
--     end
-- end


local function myprint(msg)
    print(_G.AWI_DB.Color1..addon..": ".._G.AWI_DB.Color2..msg)
end

-- ripped from https://stackoverflow.com/questions/1426954/split-string-in-lua
function mysplit (inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={}
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                table.insert(t, str)
        end
        return t
end


