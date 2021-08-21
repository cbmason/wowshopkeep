-- ShopKeep.lua

-- Main app functionality

-- Copyright © 2021 Zensmash  <archerrez4@gmail.com>

local _G = getfenv(0)
local addonName, addonData = ...
local L = addonData.L
addonData.methods = {}

_G.SHOP_DB = {
    Color1 = "|cff7799ee",
    Version = GetAddOnMetadata(addonName, "X-Version"),
    keywords = "!shop",
}

_G.SHOP_DBPC = {
    enabled = true,
    onSay = true,
    onGchat = true,
    onParty = true,
    onRaid = true,
    debugmode = false,
    show_firsttime_help = true,
    max_items = 5,
}

local function myprint(msg)
    print(_G.SHOP_DB.Color1..addonName..": ".._G.SHOP_DB.Color1..msg)
end

local function OnLoad()
    -- Check config options
    if _G.SHOP_DBPC.enabled == nil then _G.SHOP_DBPC.enabled = true end
    if _G.SHOP_DBPC.onSay == nil then _G.SHOP_DBPC.onSay = false end
    if _G.SHOP_DBPC.onGchat == nil then _G.SHOP_DBPC.onGchat = true end
    if _G.SHOP_DBPC.onParty == nil then _G.SHOP_DBPC.onParty = true end
    if _G.SHOP_DBPC.onRaid == nil then _G.SHOP_DBPC.onRaid = true end
    if _G.SHOP_DBPC.debugmode == nil then _G.SHOP_DBPC.debugmode = false end
    if _G.SHOP_DBPC.max_items == nil then _G.SHOP_DBPC.max_items = 5 end
    if _G.SHOP_DBPC.show_firsttime_help == nil then _G.SHOP_DBPC.show_firsttime_help = true end

    -- Turn on responses based on initial settings
    if _G.SHOP_DBPC.enabled == true then
        ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", onWhisper)
        if _G.SHOP_DBPC.onSay then
            ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", onWhisper)
        end
        if _G.SHOP_DBPC.onGchat then
            ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", onWhisper)
        end
        if _G.SHOP_DBPC.onParty then
            ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", onWhisper)
        end
        if _G.SHOP_DBPC.Checkbox_onRaid then
            ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", onWhisper)
        end
    end
end

local function send_response(msg, sender, debug)
    if debug then
        -- if debug mode, redirect to debug
        myprint(msg)
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
    keywords = mysplit(_G.SHOP_DB["keywords"])
    for index, word in ipairs(keywords) do
        modded_word = string.gsub(word, "%s+", "")
        keywords[index] = modded_word
    end
    for i, v in ipairs(keywords) do
        if tokens[1] == v then
            request_found = true
            break
        end
    end
    if request_found then
        -- get list of matching recipes
        table.remove(tokens, 1)
        matches = GetMatchingItems(tokens)
        if next(matches) == nil then
            --no matches, print error string
            send_response(L["NO_MATCHES_FOUND"], sender, debug)
        else
            --send the matches
            send_response(L["MATCHES_FOUND"], sender, debug)
            for i, v in ipairs(matches) do
                if i > _G.SHOP_DBPC["max_items"] then
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
end

addonData.methods.doResponse = doResponse
addonData.methods.onWhisper = onWhisper

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
ShopKeep_Eventframe:RegisterEvent("PLAYER_LOGIN")
ShopKeep_Eventframe:RegisterEvent("ADDON_LOADED")
ShopKeep_Eventframe:RegisterEvent("TRADE_SKILL_UPDATE")
ShopKeep_Eventframe:RegisterEvent("CRAFT_UPDATE")

local function ShopKeep_OnEvent(self, event, arg1, ...)
    if event == "PLAYER_LOGIN" and arg1 == addonName then
        OnLoad()
        ShopKeep_Eventframe:UnregisterEvent("PLAYER_LOGIN")
    end
    if event == "ADDON_LOADED" then
        if _G.SHOP_DBPC.show_firsttime_help then
            myprint(L["show_firsttime_help"])
            _G.SHOP_DBPC.show_firsttime_help = false
        end
        ShopKeep_Eventframe:UnregisterEvent("ADDON_LOADED")
    end
    if event == "CRAFT_UPDATE" then
        ShopKeepGetCrafts()
    end
    if event == "TRADE_SKILL_UPDATE" then
        ShopKeepGetTradeSkills()
    end
end

ShopKeep_Eventframe:SetScript("OnEvent", ShopKeep_OnEvent)
