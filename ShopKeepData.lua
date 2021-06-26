-- Copyright © 2021 Zensmash  <archerrez4@gmail.com>
-- All Rights Reserved.
-- This code is not to be modified or distributed without written permission by the author.

local shopData = {}

function BuildShopTable()
    -- Get character's profession data
    local name, type
    for i=i, GetNumTradeSkills() do
        name, type, _, _, _, _ = GetTradeSkillInfo(i);
        if (name and type ~= "header") then
            shopData[i] = name
        end
    end
end

function GetMatchingItems(...)
    local retval = {}
    local entry_matches
    for entry in pairs(shopData) do
        entry_matches = false
        for i,v in ipairs(arg) do
            if string.find(entry, v) then
                -- need at least one match to add to the return
                entry_matches = true
            else
                entry_matches = false
                break
            end
        end
        if entry_matches then retval.insert(entry) end
    end
    return retval
end

