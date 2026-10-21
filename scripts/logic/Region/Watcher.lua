-- Runs when a new slugcat is selected to update data for their campaign.
function get_watcher_regions()
    -- Access outline the requirments to move about between regions
    local access = {
        SpinningTopWarp:new("Shattered_Terrace_East", "Ancient_Urban"),
        SpinningTopWarp:new("Salination", "Shattered_Terrace_West"),
        SpinningTopWarp:new("Fetid_Glen", "Shattered_Terrace_West"),
        SpinningTopWarp:new("Heat_Ducts", "Stormy_Coast"),
        SpinningTopWarp:new("Aether_Ridge", "Torrid_Desert"),
        SpinningTopWarp:new("Ancient_Urban", "Daemon"),
        SpinningTopWarp:new("Badlands", "Fractured_Gateways"),
        SpinningTopWarp:new("Signal_Spires", "Shattered_Terrace_West"),
        SpinningTopWarp:new("Turbulent_Pump", "Heat_Ducts"),
        SpinningTopWarp:new("Stormy_Coast", "Signal_Spires"),
        SpinningTopWarp:new("Torrid_Desert", "Badlands"),
        SpinningTopWarp:new("Desolate_Tract", "Turbulent_Pump"),
        SpinningTopWarp:new("Verdant_Waterways", "Fetid_Glen"),
        SpinningTopWarp:new("Fractured_Gateways", "Cold_Storage"),

        FixedWarp("Salination", "Daemon", "Warp-Salination-Daemon", true, true, true),
        FixedWarp("Fetid_Glen", "Daemon", "Warp-Fetid_Glen-Daemon", "Warp-Fetid_Glen-Daemon", true, true, true),
        FixedWarp("Cold_Storage", "Daemon", "Warp-Cold_Storage-Daemon", true, true, true),
        FixedWarp("Heat_Ducts", "Daemon", "Warp-Heat_Ducts-Daemon", true, true, true),
        FixedWarp("Aether_Ridge", "Daemon", "Warp-Aether_Ridge-Daemon", true, true, true),
        FixedWarp("The_Surface", "Daemon", "Warp-The_Surface-Daemon", true, true, true),
        FixedWarp("Badlands", "Daemon", "Warp-Badlands-Daemon", true, true, true),
        FixedWarp("Migration_Path_East", "Daemon", "Warp-Migration_Path-Daemon", true, true, true),
        FixedWarp("Outer_Rim_City", "Daemon", "Warp-Outer_Rim-Daemon", true, true, true),
        FixedWarp("Pillar_Grove", "Daemon", "Warp-Pillar_Grove-Daemon", true, true, true),
        FixedWarp("Signal_Spires", "Daemon", "Warp-Signal_Spires-Daemon", true, true, true),
        FixedWarp("Coral_Caves", "Daemon", "Warp-Coral_Caves-Daemon", true, true, true),
        FixedWarp("Turbulent_Pump", "Daemon", "Warp-Turbulent_Pump-Daemon", true, true, true),
        FixedWarp("Rusted_Wrecks", "Daemon", "Warp-Rusted_Wrecks-Daemon", true, true, true),
        FixedWarp("Outer_Rim_Egg", "Daemon", "Warp-Outer_Rim-Daemon", true, true, true),
        
        FixedWarp("Daemon", "Torrential_Railways", "Warp-Daemon-Torrential_Railways", true, true, true),
        FixedWarp("Daemon", "Sunbaked_Alley", "Warp-Daemon-Sunbaked_Alley", true, true, true),
        FixedWarp("Daemon", "Stormy_Coast", "Warp-Daemon-Stormy_Coast", true, true, true),
        FixedWarp("Daemon", "Shrouded_Stacks", "Warp-Daemon-Shrouded_Stacks", true, true, true),
        FixedWarp("Daemon", "Torrid_Desert", "Warp-Daemon-Torrid_Desert", true, true, true),
        FixedWarp("Daemon", "Desolate_Tract", "Warp-Daemon-Desolate_Tract", true, true, true),
        FixedWarp("Daemon", "Verdant_Waterways", "Warp-Daemon-Verdant_Waterways", true, true, true),
        FixedWarp("Daemon", "Fractured_Gateways", "Warp-Daemon-Fractured_Gateways", true, true, true),
        
        FixedWarp("Salination", "Heat_Ducts", "Warp-Salination-Heat_Ducts", true, false, true),
        FixedWarp("Salination", "Fetid_Glen", "Warp-Salination-Fetid_Glen", true, false, true),
        FixedWarp("Fetid_Glen", "Fractured_Gateways", "Warp-Fetid_Glen-Fractured_Gateways", true, false, true),
        FixedWarp("Cold_Storage", "Shrouded_Stacks", "Warp-Cold_Storage-Shrouded_Stacks", true, false, true),
        FixedWarp("Cold_Storage", "The_Surface", "Warp-Cold_Storage-The_Surface", true, false, true),
        FixedWarp("Cold_Storage", "Migration_Path_East", "Warp-Cold_Storage-Migration_Path", true, false, true),
        FixedWarp("Cold_Storage", "Stormy_Coast", "Warp-Cold_Storage-Stormy_Coast", true, false, true),
        FixedWarp("Cold_Storage", "Unfortunate_Evolution", "Warp-Cold_Storage-Unfortunate_Evolution", true, false, true),
        FixedWarp("Heat_Ducts", "Torrid_Desert", "Warp-Heat_Ducts-Torrid_Desert", true, false, true),
        FixedWarp("Aether_Ridge", "Torrential_Railways", "Warp-Aether_Ridge-Torrential_Railways", true, false, true),
        FixedWarp("Aether_Ridge", "Coral_Caves", "Warp-Aether_Ridge-Coral_Caves", true, false, true),
        FixedWarp("Aether_Ridge", "Sunbaked_Alley", "Warp-Aether_Ridge-Sunbaked_Alley", true, false, true),
        FixedWarp("Aether_Ridge", "Shrouded_Stacks", "Warp-Aether_Ridge-Shrouded_Stacks", true, false, true),
        FixedWarp("The_Surface", "Desolate_Tract", "Warp-The_Surface-Desolate_Tract", true, false, true),
        FixedWarp("The_Surface", "Torrid_Desert", "Warp-The_Surface-Torrid_Desert", true, false, true),
        FixedWarp("The_Surface", "Shrouded_Stacks", "Warp-The_Surface-Shrouded_Stacks", true, false, true),
        FixedWarp("Aether_Ridge", "Migration_Path_West", "Warp-Aether_Ridge-Migration_Path", true, false, true),
        FixedWarp("Badlands", "Migration_Path_East", "Warp-Badlands-Migration_Path", true, false, true),
        FixedWarp("Pillar_Grove", "Coral_Caves", "Warp-Pillar_Grove-Coral_Caves", true, false, true),
        FixedWarp("Pillar_Grove", "Torrential_Railways", "Warp-Pillar_Grove-Torrential_Railways", true, false, true),
        FixedWarp("Pillar_Grove", "Shrouded_Stacks", "Warp-Pillar_Grove-Shrouded_Stacks", true, false, true),
        FixedWarp("Signal_Spires", "Verdant_Waterways", "Warp-Signal_Spires-Verdant_Waterways", true, false, true),
        FixedWarp("Coral_Caves", "Rusted_Wrecks", "Warp-Coral_Caves-Rusted_Wrecks", true, false, true),
        FixedWarp("Turbulent_Pump", "Verdant_Waterways", "Warp-Turbulent_Pump-Verdant_Waterways", true, false, true),
        FixedWarp("Rusted_Wrecks", "Sunbaked_Alley", "Warp-Rusted_Wrecks-Sunbaked_Alley", true, false, true),
        FixedWarp("Rusted_Wrecks", "Desolate_Tract", "Warp-Rusted_Wrecks-Desolate_Tract", true, false, true),

        FixedWarp("Corrupted_Factories", "Outer_Rim_Throne", "Warp-Corrupted_Factories-Outer_Rim", false, true, false),
        FixedWarp("Crumbling_Fringes", "Outer_Rim_Throne", "Warp-Crumbling_Fringes-Outer_Rim", false, true, false),
        FixedWarp("Decaying_Tunnels", "Outer_Rim_Throne", "Warp-Decaying_Tunnels-Outer_Rim", false, true, false),
        FixedWarp("Infested_Wastes", "Outer_Rim_Throne", "Warp-Infested_Wastes-Outer_Rim", false, true, false),


        OneWay("Ripplespace", "Corrupted_Factories", {{{"warp_ability", true}}, {{"ripple3", true}}}, {{{"some_rotted", true}}}),
        OneWay("Ripplespace", "Crumbling_Fringes", {{{"warp_ability", true}}, {{"ripple3", true}}}, {{{"some_rotted", true}}}),
        OneWay("Ripplespace", "Decaying_Tunnels", {{{"warp_ability", true}}, {{"ripple3", true}}}, {{{"some_rotted", true}}}),
        OneWay("Ripplespace", "Infested_Wastes", {{{"warp_ability", true}}, {{"ripple3", true}}}, {{{"some_rotted", true}}}),

        OneWay("Shattered_Terrace_West", "Shattered_Terrace_East", {}, {{{"ripple5", true}}}),
        OneWay("Shattered_Terrace_East", "Shattered_Terrace_West", {}, {}),

        OneWay("Migration_Path_West", "Migration_Path_East", {}, {}),
        OneWay("Migration_Path_East", "Migration_Path_West", {}, {{{"ripple9", true}}}),

        TwoWay("Outer_Rim_Throne", "Outer_Rim_Ripple3", {{{"ripple3", true}}}, {}),
        TwoWay("Outer_Rim_Throne", "Outer_Rim_Ripple5", {{{"ripple5", true}}}, {}),
        TwoWay("Outer_Rim_Throne", "Outer_Rim_Ripple7", {{{"ripple7", true}}}, {}),
        TwoWay("Outer_Rim_Throne", "Outer_Rim_Ripple9", {{{"ripple9", true}}}, {}),

        TwoWay("Outer_Rim_City", "Outer_Rim_Egg", {}, {{{"ripple5", true}}}),

        OneWay("Outer_Rim_City", "Outer_Rim_Throne", {}, {}),
        OneWay("Outer_Rim_Throne", "Outer_Rim_City", {{{"ripple5", true}}}, {})
    }

    local regions = {
        -- Campaign Regions
        ["Aether_Ridge"] = SubRegion:new("Aether_Ridge", access),
        ["Badlands"] = SubRegion:new("Badlands", access),
        ["Cold_Storage"] = SubRegion:new("Cold_Storage", access),
        ["Coral_Caves"] = SubRegion:new("Coral_Caves", access),
        ["Desolate_Tract"] = SubRegion:new("Desolate_Tract", access),
        ["Fetid_Glen"] = SubRegion:new("Fetid_Glen", access),
        ["Fractured_Gateways"] = SubRegion:new("Fractured_Gateways", access),
        ["Heat_Ducts"] = SubRegion:new("Heat_Ducts", access),
        ["Pillar_Grove"] = SubRegion:new("Pillar_Grove", access),
        ["Rusted_Wrecks"] = SubRegion:new("Rusted_Wrecks", access),
        ["Salination"] = SubRegion:new("Salination", access),
        ["Shrouded_Stacks"] = SubRegion:new("Shrouded_Stacks", access),
        ["Signal_Spires"] = SubRegion:new("Signal_Spires", access),
        ["Stormy_Coast"] = SubRegion:new("Stormy_Coast", access),
        ["Sunbaked_Alley"] = SubRegion:new("Sunbaked_Alley", access),
        ["The_Surface"] = SubRegion:new("The_Surface", access),
        ["Torrential_Railways"] = SubRegion:new("Torrential_Railways", access),
        ["Torrid_Desert"] = SubRegion:new("Torrid_Desert", access),
        ["Turbulent_Pump"] = SubRegion:new("Turbulent_Pump", access),
        ["Verdant_Waterways"] = SubRegion:new("Verdant_Waterways", access),
        ["Corrupted_Factories"] = SubRegion:new("Corrupted_Factories", access),
        ["Crumbling_Fringes"] = SubRegion:new("Crumbling_Fringes", access),
        ["Decaying_Tunnels"] = SubRegion:new("Decaying_Tunnels", access),
        ["Infested_Wastes"] = SubRegion:new("Infested_Wastes", access),
        ["Unfortunate_Evolution"] = SubRegion:new("Unfortunate_Evolution", access),
        ["Ancient_Urban"] = SubRegion:new("Ancient_Urban", access),
        
        -- Split regions
        ["Shattered_Terrace_East"] = SubRegion:new("Shattered_Terrace_East", access, {"Shattered_Terrace"}),
        ["Shattered_Terrace_West"] = SubRegion:new("Shattered_Terrace_West", access, {"Shattered_Terrace"}),
        
        ["Migration_Path_East"] = SubRegion:new("Migration_Path_East", access, {"Migration_Path"}),
        ["Migration_Path_West"] = SubRegion:new("Migration_Path_West", access, {"Migration_Path"}),
        
        ["Outer_Rim_City"] = SubRegion:new("Outer_Rim_City", access, {"Outer_Rim"}),
        ["Outer_Rim_Throne"] = SubRegion:new("Outer_Rim_Throne", access, {"Outer_Rim"}),
        ["Outer_Rim_Egg"] = SubRegion:new("Outer_Rim_Egg", access, {"Outer_Rim"}),
        ["Outer_Rim_Ripple3"] = SubRegion:new("Outer_Rim_Ripple3", access, {"Outer_Rim"}),
        ["Outer_Rim_Ripple5"] = SubRegion:new("Outer_Rim_Ripple5", access, {"Outer_Rim"}),
        ["Outer_Rim_Ripple7"] = SubRegion:new("Outer_Rim_Ripple7", access, {"Outer_Rim"}),
        ["Outer_Rim_Ripple9"] = SubRegion:new("Outer_Rim_Ripple9", access, {"Outer_Rim"}),

        ["Daemon"] = SubRegion:new("Daemon", access),

        -- Permanent Regions
        ["Ripplespace"] = SubRegion:new("Ripplespace", access, {}, false, true)
    }

    print("Regions created for The Watcher")
    return regions
end


-- Using the values in game_data\data.py for the Rain World Archipelago repo use the following to format the "WarpPoints" and then run it through the generation file: 
--"([a-zA-Z]*)_.*": \{"to": "([a-zA-Z]*)_.*", "flags": \d\}   -->   Warp:new("$1", "$2")
--"([a-zA-Z]*)_.*": \{"to": "NULL", "flags": \d\}   -->   Warp:new("$1", "Daemon")

-- Spinning top warps:
--"([a-zA-Z]*)_.*": \{"to": "([a-zA-Z]*).*", "id": \d+, "ripple": (.*)\}   -->   Warp:new("$1", "$2", \L$3)
