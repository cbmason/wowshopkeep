-- ShopKeep.lua

-- Main app functionality

-- Copyright © 2021 Zensmash  <archerrez4@gmail.com>

local _G = getfenv(0)
local addonName, addonData = ...
local L = addonData.L
local max_message_chars = 255
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
    all_characters = false,
    max_items = 5,
}

local function myprint(msg)
    print(_G.SHOP_DB.Color1..addonName..": ".._G.SHOP_DB.Color1..msg)
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

-- Whisper: is this a whisper or a broadcast response (i.e., party / say / guild)
local function doResponse(msg, sender, whisper, debug)
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
            -- no matches, print error string if this is a whisper, otherwise ignore so the requester
            -- doesn't get 9001 messages if others are using this addon
            if whisper then
                send_response(L["NO_MATCHES_FOUND"], sender, debug)
            end
        else
            --send the matches
            send_response(L["MATCHES_FOUND"], sender, debug)
            matchstring = ""
            for i, v in ipairs(matches) do
                if i > _G.SHOP_DBPC["max_items"] then
                    not_finished = true
                    break
                else
                    -- Send Chat API limits the number of chars in a message, so flush the send buffer
                    -- if we exceed that
                    if( ( string.len(matchstring) + string.len( v ) + 1 ) > max_message_chars ) then
                        send_response(matchstring, sender, debug)
                        matchstring = ""
                    end
                    matchstring = matchstring .. v .. " "
                end
            end
            send_response(matchstring, sender, debug)
            if not_finished then
                send_response(L["MORE_ITEMS"], sender, debug)
            end
        end
    end
end

-- https://wow.gamepedia.com/CHAT_MSG_WHISPER
local function onWhisper(self, event, msg, sender, _, _, _, _, _, _, _, _, lineID, guid, bnetIDAccount, isMobile)
    doResponse(msg, sender, true, false)
end

local function onBroadcast(self, event, msg, sender, _, _, _, _, _, _, _, _, lineID, guid, bnetIDAccount, isMobile)
    doResponse(msg, sender, false, false)
end

addonData.methods.doResponse = doResponse
addonData.methods.onWhisper = onWhisper
addonData.methods.onBroadcast = onBroadcast

local function OnLoad()
    -- Check config options
    if _G.SHOP_DBPC.enabled == nil then _G.SHOP_DBPC.enabled = true end
    if _G.SHOP_DBPC.onSay == nil then _G.SHOP_DBPC.onSay = true end
    if _G.SHOP_DBPC.onGchat == nil then _G.SHOP_DBPC.onGchat = true end
    if _G.SHOP_DBPC.onParty == nil then _G.SHOP_DBPC.onParty = true end
    if _G.SHOP_DBPC.onRaid == nil then _G.SHOP_DBPC.onRaid = true end
    if _G.SHOP_DBPC.all_characters == nil then _G.SHOP_DBPC.all_characters = false end
    if _G.SHOP_DBPC.debugmode == nil then _G.SHOP_DBPC.debugmode = false end
    if _G.SHOP_DBPC.max_items == nil then _G.SHOP_DBPC.max_items = 5 end
    if _G.SHOP_DBPC.show_firsttime_help == nil then _G.SHOP_DBPC.show_firsttime_help = true end

    -- Turn on responses based on initial settings
    if _G.SHOP_DBPC.enabled == true then
        ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", onWhisper)
        if _G.SHOP_DBPC.onSay then
            ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", onBroadcast)
        end
        if _G.SHOP_DBPC.onGchat then
            ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", onBroadcast)
        end
        if _G.SHOP_DBPC.onParty then
            ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", onBroadcast)
        end
        if _G.SHOP_DBPC.Checkbox_onRaid then
            ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", onBroadcast)
        end
    end
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

-- Event order: --
-- ADDON_LOADED
-- SPELLS_CHANGED
-- PLAYER_LOGIN
-- PLAYER_ENTERING_WORLD
-- PLAYER_ALIVE

-- RegisterEvents
local ShopKeep_Eventframe = CreateFrame("FRAME")
ShopKeep_Eventframe:RegisterEvent("ADDON_LOADED")
ShopKeep_Eventframe:RegisterEvent("PLAYER_LOGIN")
ShopKeep_Eventframe:RegisterEvent("TRADE_SKILL_UPDATE")
ShopKeep_Eventframe:RegisterEvent("CRAFT_UPDATE")

local function ShopKeep_OnEvent(self, event, arg1, ...)
    if event == "PLAYER_LOGIN" then
        if _G.SHOP_DBPC.show_firsttime_help then
            myprint(L["show_firsttime_help"])
            _G.SHOP_DBPC.show_firsttime_help = false
        end
        OnLoad()
        ShopKeep_Eventframe:UnregisterEvent("PLAYER_LOGIN")
    end
    if event == "CRAFT_UPDATE" then
        ShopKeepGetCrafts()
    end
    if event == "TRADE_SKILL_UPDATE" then
        ShopKeepGetTradeSkills()
    end
end

ShopKeep_Eventframe:SetScript("OnEvent", ShopKeep_OnEvent)
