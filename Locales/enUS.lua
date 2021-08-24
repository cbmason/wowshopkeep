local addonName, addonData = ...

local L = {}

L["NO_MATCHES_FOUND"] = "Sorry, none of my recipes match that search"
L["MATCHES_FOUND"] = "I can craft the following items:"
L["MORE_ITEMS"] = "...and more.  Narrow your search for more recipes."

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
L["Checkbox_allChars"] = "Use ALL characters"
L["Checkbox_allChars_Desc"] = "ShopKeep will respond with recipes from ALL your characters (must scan on each character first)"

L["Checkbox_Debugmode"] = "Debug mode (Development only)"
L["Checkbox_Debugmode_Desc"] = "Enables the debug console, !REMOVE FOR RELEASE!"
L["Textbox_Keywords"] = "Keywords"
L["Textbox_Keywords_Desc"] = "Comma-separated list of keywords to trigger a ShopKeep response"
L["Addon_Loaded"] = "AddOn loaded..."
L["Max Recipes"] = "Max Recipes"
L["show_firsttime_help"] = "SHOPKEEP: This appears to be the first time you've played this character after having installed Shopkeep, please open each tradeskill window, it lets the addon scan your available recipes"

addonData.L = L
