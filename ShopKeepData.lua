-- Copyright © 2021 Zensmash  <archerrez4@gmail.com>
-- All Rights Reserved.
-- This code is not to be modified or distributed without written permission by the author.

local shopData = {}

function BuildShopTable()
    -- Get character's profession data
    local name, type
    print("building shop table")
    -- numSkills = GetNumTradeSkills()
    for i=1, GetNumTradeSkills() do
        name, type, _, _, _, _ = GetTradeSkillInfo(i);
        if (name and type ~= "header") then
            if shopData[i] == nil then
                print("added ", name)
                shopData[i] = name
            end
        end
    end
end

-- function GetMatchingItems(...)
function GetMatchingItems(argtable)
    local retval = {}
    local entry_matches
    for i, entry in pairs(shopData) do
        entry_matches = false
        -- Check each argument, if any do not match, don't add it.
        for j,v in ipairs(argtable) do
            if string.find(entry:lower(), v:lower()) then
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

