-- entry point for all lua code of the pack
-- more info on the lua API: https://github.com/black-sliver/PopTracker/blob/master/doc/PACKS.md#lua-interface
ENABLE_DEBUG_LOG = true
-- get current variant
local variant = Tracker.ActiveVariantUID
-- check variant info
IS_ITEMS_ONLY = variant:find("itemsonly")

print("-- Rain World Tracker --")
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
Tracker:AddItems("items/items_watcher.jsonc")
Tracker:AddItems("items/regions.jsonc")

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

    Tracker:AddLocations("locations/watcher/Shattered Terrace.jsonc")
    Tracker:AddLocations("locations/watcher/Salination.jsonc")
    Tracker:AddLocations("locations/watcher/Fetid Glen.jsonc")
    Tracker:AddLocations("locations/watcher/Cold Storage.jsonc")
    Tracker:AddLocations("locations/watcher/Heat Ducts.jsonc")
    Tracker:AddLocations("locations/watcher/Aether Ridge.jsonc")
    Tracker:AddLocations("locations/watcher/The Surface.jsonc")
    Tracker:AddLocations("locations/watcher/Ancient Urban.jsonc")
    Tracker:AddLocations("locations/watcher/Badlands.jsonc")
    Tracker:AddLocations("locations/watcher/Migration Path.jsonc")
    Tracker:AddLocations("locations/watcher/Outer Rim.jsonc")
    Tracker:AddLocations("locations/watcher/Pillar Grove.jsonc")
    Tracker:AddLocations("locations/watcher/Signal Spires.jsonc")
    Tracker:AddLocations("locations/watcher/Coral Caves.jsonc")
    Tracker:AddLocations("locations/watcher/Turbulent Pump.jsonc")
    Tracker:AddLocations("locations/watcher/Rusted Wrecks.jsonc")
    Tracker:AddLocations("locations/watcher/Torrential Railways.jsonc")
    Tracker:AddLocations("locations/watcher/Sunbaked Alley.jsonc")
    Tracker:AddLocations("locations/watcher/Stormy Coast.jsonc")
    Tracker:AddLocations("locations/watcher/Shrouded Stacks.jsonc")
    Tracker:AddLocations("locations/watcher/Torrid Desert.jsonc")
    Tracker:AddLocations("locations/watcher/Desolate Tract.jsonc")
    Tracker:AddLocations("locations/watcher/Verdant Waterways.jsonc")
    Tracker:AddLocations("locations/watcher/Fractured Gateways.jsonc")
    Tracker:AddLocations("locations/watcher/Decaying Tunnels.jsonc")
    Tracker:AddLocations("locations/watcher/Infested Wastes.jsonc")
    Tracker:AddLocations("locations/watcher/Corrupted Factories.jsonc")
    Tracker:AddLocations("locations/watcher/Unfortunate Evolution.jsonc")
    Tracker:AddLocations("locations/watcher/Crumbling Fringes.jsonc")
    Tracker:AddLocations("locations/watcher/Daemon.jsonc")
end

--Static mappings used in logic defaults
ScriptHost:LoadScript("scripts/autotracking/map_switching.lua")

--Objects
ScriptHost:LoadScript("scripts/logic/classes/Gate.lua")
ScriptHost:LoadScript("scripts/logic/classes/OneWay.lua")
ScriptHost:LoadScript("scripts/logic/classes/TwoWay.lua")
ScriptHost:LoadScript("scripts/logic/classes/SubRegion.lua")

ScriptHost:LoadScript("scripts/logic/Region/General.lua")

ScriptHost:LoadScript("scripts/logic/classes/SpinningTopWarp.lua")
ScriptHost:LoadScript("scripts/logic/classes/FixedWarp.lua")
ScriptHost:LoadScript("scripts/logic/Region/Watcher.lua")

-- Logic
ScriptHost:LoadScript("scripts/logic/logic.lua")

-- Layout
Tracker:AddLayouts("layouts/items.jsonc")
Tracker:AddLayouts("layouts/tracker.jsonc")
Tracker:AddLayouts("layouts/broadcast.jsonc")

ScriptHost:LoadScript("scripts/layout_manager/layout_manager.lua")

-- AutoTracking for Poptracker
if PopVersion and PopVersion >= "0.18.0" then
    ScriptHost:LoadScript("scripts/autotracking.lua")
end

