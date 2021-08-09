-- Copyright © 2021 Zensmash  <archerrez4@gmail.com>
-- All Rights Reserved.
-- This code is not to be modified or distributed without written permission by the author.

local _G = getfenv(0)
local addonName, addonData = ...
local L = addonData.L
addonData.methods = {}

local color1 = "|cff3399ff"
local color2 = "|cff1eff00"

-- todo: debugmode -> testmode
_G.SHOP_DB = {
    --debugmode = false,
    Color1 = "|cff3399ff",
    Color2 = "|cff1eff00",
    Version = GetAddOnMetadata(addonName, "X-Version"),
    keywords = "!shop",
    max_items = 5,
}

-- todo: implement everything other than whisper
_G.SHOP_DBPC = {
    enabled = true,
    onSay = false,
    onGchat = false,
    onParty = false,
    onRaid = false,
    debugmode = false
}

local isRetail = (_G.WOW_PROJECT_ID == _G.WOW_PROJECT_MAINLINE)
local isClassic = (_G.WOW_PROJECT_ID == _G.WOW_PROJECT_CLASSIC)
local isTBC = (_G.WOW_PROJECT_ID == _G.WOW_PROJECT_BURNING_CRUSADE_CLASSIC)


local function OnLoad()
    -- if ShopKeep.ABORTLOAD then
    --     -- Don't try to run if there were errors
    --     return
    -- end
    -- Check config options
    if _G.SHOP_DBPC.enabled == nil then _G.SHOP_DBPC.enabled = true end
    if _G.SHOP_DBPC.onSay == nil then _G.SHOP_DBPC.onSay = false end
    if _G.SHOP_DBPC.onGchat == nil then _G.SHOP_DBPC.onGchat = false end
    if _G.SHOP_DBPC.onParty == nil then _G.SHOP_DBPC.onParty = false end
    if _G.SHOP_DBPC.onRaid == nil then _G.SHOP_DBPC.onRaid = false end

    -- Make profession tabl*
    BuildShopTable()
end


local function send_response(msg, sender, debug)
    if debug then
        -- if debug mode, redirect to debug
        print(msg)
    else
        --otherwise, whisper the sender
        SendChatMessage(msg, "WHISPER", nil, sender)
    end

end

local function doResponse(msg, sender, debug)
    local not_finished = false
    local request_found = false
    -- filter for keywords
    tokens = mysplit(msg)
    -- if keywords found, handle
    -- TODO: need to see if the ipairs parse right
    keywords = mysplit(_G.SHOP_DB["keywords"])
    for index, word in ipairs(keywords) do
        --print(d)
        modded_word = string.gsub(word, "%s+", "")
        keywords[index] = modded_word
    end
    --keywords = string.gsub(keywords, "%s+", "")
    --print("keywords2")
    --print(string.format("keywords: %s", keywords))
    --print("keywords", keywords)
    for i, v in ipairs(keywords) do
        --print("token: ", tokens[0])
        if tokens[1] == v then
            request_found = true
            break
        end
    end

    -- if tokens[0] == _G.SHOP_DB["keywords"] then
    if request_found then
        -- get list of matching recipes
        -- tokens:remove(1)
        table.remove(tokens, 1)
        matches = GetMatchingItems(tokens)
        if next(matches) == nil then
            --no matches, print error string
            send_response(L["NO_MATCHES_FOUND"], sender, debug)
        else
            --send the matches
            send_response(L["MATCHES_FOUND"], sender, debug)
            for i, v in ipairs(matches) do
                if i >= _G.SHOP_DB["max_items"] then
                    not_finished = true
                    break
                else
                    send_response(v, sender, debug)
                end
            end
            if not_finished then
                send_response(L["MORE_ITEMS"], sender, debug)
            end
        end
    end
end


-- https://wow.gamepedia.com/CHAT_MSG_WHISPER
local function onWhisper(self, event, msg, sender, _, _, _, _, _, _, _, _, lineID, guid, bnetIDAccount, isMobile)
    doResponse(msg, sender, false)
    -- local not_finished = false
    -- local request_found = false
    -- -- filter for keywords
    -- tokens = mysplit(msg)
    -- -- if keywords found, handle
    -- -- TODO: need to see if the ipairs parse right
    -- keywords = mysplit(_G.SHOP_DB["keywords"])
    -- keywords = string.gsub(keywords, "%s+", "")
    -- for i, v in ipairs(keywords) do
    --     if tokens[0] == v then
    --         request_found = true
    --         break
    --     end
    -- end

    -- -- if tokens[0] == _G.SHOP_DB["keywords"] then
    -- if request_found then
    --     -- get list of matching recipes
    --     tokens.remove(0)
    --     matches = GetMatchingItems(tokens)
    --     if next(matches) == nil then
    --         --no matches, print error string
    --         send_response(L["NO_MATCHES_FOUND"], sender)
    --     else
    --         --send the matches
    --         send_response(L["MATCHES_FOUND"], sender)
    --         for i, v in ipairs(matches) do
    --             if i >= _G.SHOP_DB["max_items"] then
    --                 not_finished = true
    --                 break
    --             else
    --                 send_response(v, sender)
    --             end
    --         end
    --         if not_finished then
    --             send_response(L["MORE_ITEMS"], sender)
    --         end
    --     end
    -- end
end

addonData.methods.doResponse = doResponse
addonData.methods.onWhisper = onWhisper

-- local function ShopKeep_Enable()
--     ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", onWhisper)
-- end


-- local function ShopKeep_Disable()
--     ChatFrame_RemoveMessageEventFilter("CHAT_MSG_WHISPER", onWhisper)
-- end



-- local function onResponse()
--     if _G.SHOP_DB.debugmode then
--         PRINT TO DEBUG BOX
--     else
--     end
-- end


local function myprint(msg)
    print(_G.SHOP_DB.Color1..addonName..": ".._G.SHOP_DB.Color1..msg)
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

-- RegisterEvents
local ShopKeep_Eventframe = CreateFrame("FRAME")
ShopKeep_Eventframe:RegisterEvent("ADDON_LOADED")
ShopKeep_Eventframe:RegisterEvent("PLAYER_LOGIN")
ShopKeep_Eventframe:RegisterEvent("TRADE_SKILL_UPDATE")

local function ShopKeep_OnEvent(self, event, arg1, arg2, ...)
    if event == "ADDON_LOADED" and arg1 == addonName then
        myprint(L["Addon_Loaded"])
        -- ShopKeepConfig_Loaded = true
        OnLoad()
        ShopKeep_Eventframe:UnregisterEvent("ADDON_LOADED")
    end
    if event == "PLAYER_LOGIN" and ShopKeepConfig_Loaded then
        myprint(L["Player_Loaded"])
        _G.SHOP_DB.Color1 = color1
        _G.SHOP_DB.Color2 = color2
        _G.SHOP_DB["Version"] = GetAddOnMetadata(addonName, "X-Version")

        -- Initialize if new variable added

        -- if _G.SHOP_DBPC["AllInvite"] == nil then
        --     _G.SHOP_DBPC.AllInvite = false
        -- end
        ShopKeep_Eventframe:UnregisterEvent("PLAYER_LOGIN")
    end
    if event == "TRADE_SKILL_UPDATE" then
        BuildShopTable()
    end
end

ShopKeep_Eventframe:SetScript("OnEvent", ShopKeep_OnEvent)
