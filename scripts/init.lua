-- entry point for all lua code of the pack
-- more info on the lua API: https://github.com/black-sliver/PopTracker/blob/master/doc/PACKS.md#lua-interface
ENABLE_DEBUG_LOG = true
-- get current variant
local variant = Tracker.ActiveVariantUID
-- check variant info
IS_ITEMS_ONLY = variant:find("itemsonly")

print("-- Example Tracker --")
print("Loaded variant: ", variant)
if ENABLE_DEBUG_LOG then
    print("Debug logging is enabled!")
end

-- Utility Script for helper functions etc.
ScriptHost:LoadScript("scripts/utils.lua")

-- Custom Items
ScriptHost:LoadScript("scripts/custom_items/class.lua")
ScriptHost:LoadScript("scripts/custom_items/progressiveTogglePlus.lua")
ScriptHost:LoadScript("scripts/custom_items/progressiveTogglePlusWrapper.lua")

-- Items
Tracker:AddItems("items/items.jsonc")

if not IS_ITEMS_ONLY then -- <--- use variant info to optimize loading
    -- Maps
    Tracker:AddMaps("maps/maps.jsonc")
    -- Locations
    Tracker:AddLocations("locations/Achievements.jsonc")
    Tracker:AddLocations("locations/Chimney Canopy.jsonc")
    Tracker:AddLocations("locations/Drainage System.jsonc")
    Tracker:AddLocations("locations/Exterior.jsonc")
    Tracker:AddLocations("locations/Farm Arrays.jsonc")
    Tracker:AddLocations("locations/Five Pebbles.jsonc")
    Tracker:AddLocations("locations/Garbage Wastes.jsonc")
    Tracker:AddLocations("locations/Industrial Complex.jsonc")
    Tracker:AddLocations("locations/Looks to the Moon.jsonc")
    Tracker:AddLocations("locations/Metropolis.jsonc")
    Tracker:AddLocations("locations/Outer Expanse.jsonc")
    Tracker:AddLocations("locations/Outskirts.jsonc")
    Tracker:AddLocations("locations/Pipeyard.jsonc")
    Tracker:AddLocations("locations/Rubicon.jsonc")
    Tracker:AddLocations("locations/Shaded Citadel.jsonc")
    Tracker:AddLocations("locations/Shoreline.jsonc")
    Tracker:AddLocations("locations/Silent Construct.jsonc")
    Tracker:AddLocations("locations/Sky Islands.jsonc")
    Tracker:AddLocations("locations/Submerged Superstructure.jsonc")
    Tracker:AddLocations("locations/Subterranean.jsonc")
    Tracker:AddLocations("locations/The Rot.jsonc")
    Tracker:AddLocations("locations/Undergrowth.jsonc")
    Tracker:AddLocations("locations/Waterfront Facility.jsonc")
end

-- Logic
ScriptHost:LoadScript("scripts/logic/logic.lua")

-- Layout
Tracker:AddLayouts("layouts/items.jsonc")
Tracker:AddLayouts("layouts/tracker.jsonc")
Tracker:AddLayouts("layouts/broadcast.jsonc")

-- AutoTracking for Poptracker
if PopVersion and PopVersion >= "0.18.0" then
    ScriptHost:LoadScript("scripts/autotracking.lua")
end

