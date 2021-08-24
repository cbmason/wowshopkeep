-- ShopKeepData.lua

-- Data and methods to store and retrieve profession data for use by the addon

-- Copyright © 2021 Zensmash  <archerrez4@gmail.com>

local addonData = ...

local _G = getfenv(0)

local shopData = _G.SHOP_DBPC.database
local shopDataAll = _G.SHOP_DB.database

function ShopKeepGetCrafts()
    local name, type
    for i=1, GetNumCrafts() do
        name, type, _, _, _, _ = GetCraftInfo(i);
        if (name and type ~= "header") then
            if shopData[name] == nil then
                itemRecipe = GetCraftItemLink(i);
                --print("added ", itemRecipe) -- debug only
                shopData[name] = itemRecipe
            end
            if shopDataAll[name] == nil then
                itemRecipe = GetCraftItemLink(i);
                --print("Added ", itemRecipe, " to all") -- debug only
                shopDataAll[name] = itemRecipe
            end
        end
    end
end

function ShopKeepGetTradeSkills()
    local name, type
    for i=1, GetNumTradeSkills() do
        name, type, _, _, _, _ = GetTradeSkillInfo(i);
        if (name and type ~= "header") then
            if shopData[name] == nil then
                itemRecipe = GetTradeSkillRecipeLink(i);
                --print("Added ", itemRecipe) -- debug only
                shopData[name] = itemRecipe
            end
            if shopDataAll[name] == nil then
                itemRecipe = GetTradeSkillRecipeLink(i);
                --print("Added ", itemRecipe, " to all") -- debug only
                shopDataAll[name] = itemRecipe
            end
        end
    end
end

function GetMatchingItems(argtable)
    local retval = {}
    local entry_matches
    local data

    if _G.SHOP_DBPC["all_characters"] then
        data = shopDataAll
    else
        data = shopData
    end

    for i, entry in pairs(data) do
        entry_matches = false
        -- Check each argument, if any do not match, don't add it.
        for j,v in ipairs(argtable) do
            local realString = entry:match("%b[]")
            if string.find(realString:lower(), v:lower()) then
                entry_matches = true
            else
                entry_matches = false
                break;
            end
        end
        if entry_matches then table.insert(retval, entry) end
    end
    return retval
end

function PrintAllShopData()
    print("Dumping shop data...")
    for index, value in pairs(shopData) do
        print(index, ", ", value)
    end
end

-- RegisterEvents
local ShopKeepData_Eventframe = CreateFrame("FRAME")
ShopKeepData_Eventframe:RegisterEvent("ADDON_LOADED")

local function ShopKeepData_OnEvent(self, event, arg1, arg2, ...)
    if event == "ADDON_LOADED" then
        if _G.SHOP_DBPC.database == nil then
            _G.SHOP_DBPC.database = {}
        end
        if _G.SHOP_DB.database == nil then
            _G.SHOP_DB.database = {}
        end
        shopData = _G.SHOP_DBPC.database
        shopDataAll = _G.SHOP_DB.database
        ShopKeepGetTradeSkills()
        ShopKeepGetCrafts()
        ShopKeepData_Eventframe:UnregisterEvent("ADDON_LOADED")
    end
end

ShopKeepData_Eventframe:SetScript("OnEvent", ShopKeepData_OnEvent)
