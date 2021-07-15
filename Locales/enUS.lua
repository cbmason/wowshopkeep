local addonName, addonData = ...

local L = {}

-- L.CUSTOMER_HELP = "Whisper 'shop <slot> <type>'  - <slot> can be \"head,\" \"helm,\" \"pants,\" anything like that.  <type> is the desired stat i.e. \"healing,\" \"strength,\" etc."
-- L.HEAD_STRINGS = {"helm", "head"}
-- L.SHOULDER_STRINGS = {"shoulder", "shoulders", "pauldron", "pauldrons"}
L["NO_MATCHES_FOUND"] = "Sorry, no items match that search"
L["MATCHES_FOUND"] = "The following items are available:"
L["MORE_ITEMS"] = "...and more.  Narrow search for more results."

L["Checkbox_Enable"] = "Enable Shopkeep"
L["Checkbox_Enable_Desc"] = "Enables auto-response functionality of the addon"
L["Checkbox_onSay"] = "Enable for /say"
L["Checkbox_onSay_Desc"] = "ShopKeep will respond to /say"
L["Checkbox_onGchat"] = "Enable for /guild"
L["Checkbox_onGchat_Desc"] = "ShopKeep will respond to /guild"
L["Checkbox_onParty"] = "Enable for /party"
L["Checkbox_onParty_Desc"] = "ShopKeep will respond to /party"
L["Checkbox_onRaid"] = "Enable for /raid"
L["Checkbox_onRaid_Desc"] = "ShopKeep will respond to /raid"

L["Checkbox_Debugmode"] = "Debug mode (Development only)"
L["Checkbox_Debugmode_Desc"] = "Enables the debug console, !REMOVE FOR RELEASE!"
L["Textbox_Keywords"] = "Keywords"
L["Textbox_Keywords_Desc"] = "Comma-separated list of keywords to trigger a ShopKeep response"
L["Addon_Loaded"] = "AddOn loaded..."
L["Player_Loaded"] = "HERP"


addonData.L = L
