-- Copyright © 2021 Zensmash  <archerrez4@gmail.com>
-- All Rights Reserved.
-- This code is not to be modified or distributed without written permission by the author.

local addonData = ...

local _G = getfenv(0)

-- local shopData = {}
local shopData = _G.SHOP_DBPC.database


function ShopKeepGetCrafts()
    local name, type
    print("getting crafts")
    -- numSkills = GetNumTradeSkills()
    -- for i=1, GetNumTradeSkills() do
    for i=1, GetNumCrafts() do
        name, type, _, _, _, _ = GetCraftInfo(i);
        if (name and type ~= "header") then
            if shopData[name] == nil then
                itemRecipe = GetCraftItemLink(i);
                print("added ", itemRecipe)
                shopData[name] = itemRecipe
            end
        end
    end
end

function ShopKeepGetTradeSkills()
    local name, type
    print("getting tradeskills")
    -- numSkills = GetNumTradeSkills()
    -- for i=1, GetNumTradeSkills() do
    for i=1, GetNumTradeSkills() do
        name, type, _, _, _, _ = GetTradeSkillInfo(i);
        if (name and type ~= "header") then
            if shopData[name] == nil then
                itemRecipe = GetTradeSkillRecipeLink(i);
                print("Added ", itemRecipe)
                shopData[name] = itemRecipe
            end
        end
    end
end

--function BuildShopTable()
    -- Get character's profession data
    -- local name, type
    -- print("building shop table")
    -- numSkills = GetNumTradeSkills()
    -- for i=1, GetNumTradeSkills() do
    -- for i=1, GetNumCrafts() do
    --     name, type, _, _, _, _ = GetCraftInfo(i);
    --     if (name and type ~= "header") then
    --         if shopData[name] == nil then
    --             itemRecipe = GetCraftItemLink(i);
    --             print("added ", itemRecipe)
    --             shopData[name] = itemRecipe
    --         end
    --     end
    -- end
    -- for i=1, GetNumTradeSkills() do
    --     name, type, _, _, _, _ = GetTradeSkillInfo(i);
    --     if (name and type ~= "header") then
    --         if shopData[name] == nil then
    --             itemRecipe = GetTradeSkillRecipeLink(i);
    --             print("Added ", itemRecipe)
    --             shopData[name] = itemRecipe
    --         end
    --     end
    -- end

--end

-- function GetMatchingItems(...)
function GetMatchingItems(argtable)
    local retval = {}
    local entry_matches
    for i, entry in pairs(shopData) do
        entry_matches = false
        -- Check each argument, if any do not match, don't add it.
        for j,v in ipairs(argtable) do
            local realString = entry:match("%b[]")
            -- if string.find(entry:lower(), v:lower()) then
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
        shopData = _G.SHOP_DBPC.database
        ShopKeepData_Eventframe:UnregisterEvent("ADDON_LOADED")
    end
end

ShopKeepData_Eventframe:SetScript("OnEvent", ShopKeepData_OnEvent)
