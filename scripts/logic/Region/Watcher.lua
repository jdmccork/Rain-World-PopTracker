-- Runs when a new slugcat is selected to update data for their campaign.
function get_watcher_regions()
    -- Access outline the requirments to move about between regions
    local access = {
        -- SpinningTopWarp:new("Shattered_Terrace", "Daemon", true),
        -- SpinningTopWarp:new("Salination", "Shattered_Terrace", false),
        -- SpinningTopWarp:new("Fetid_Glen", "Shattered_Terrace", false),
        -- SpinningTopWarp:new("Heat_Ducts", "Stormy_Coast", false),
        -- SpinningTopWarp:new("Aether_Ridge", "Torrid_Desert", false),
        -- SpinningTopWarp:new("Ancient_Urban", "Daemon", false),
        -- SpinningTopWarp:new("Badlands", "Fractured_Gateways", false),
        -- SpinningTopWarp:new("Signal_Spires", "Shattered_Terrace", false),
        -- SpinningTopWarp:new("Turbulent_Pump", "Heat_Ducts", false),
        -- SpinningTopWarp:new("Stormy_Coast", "Signal_Spires", false),
        -- SpinningTopWarp:new("Torrid_Desert", "Badlands", false),
        -- SpinningTopWarp:new("Desolate_Tract", "Turbulent_Pump", false),
        -- SpinningTopWarp:new("Verdant_Waterways", "Fetid_Glen", false),
        -- SpinningTopWarp:new("Fractured_Gateways", "Cold_Storage", false),

        FixedWarp("Salination", "Heat_Ducts"),
        FixedWarp("Salination", "Fetid_Glen"),
        FixedWarp("Salination", "Daemon"),
        FixedWarp("Fetid_Glen", "Daemon"),
        FixedWarp("Salination", "Fetid_Glen"),
        FixedWarp("Fetid_Glen", "Fractured_Gateways"),
        FixedWarp("Cold_Storage", "Shrouded_Stacks"),
        FixedWarp("Cold_Storage", "The_Surface"),
        FixedWarp("Cold_Storage", "Daemon"),
        FixedWarp("Cold_Storage", "Migration_Path"),
        FixedWarp("Cold_Storage", "Stormy_Coast"),
        FixedWarp("Cold_Storage", "Unfortunate_Evolution"),
        FixedWarp("Heat_Ducts", "Daemon"),
        FixedWarp("Heat_Ducts", "Torrid_Desert"),
        FixedWarp("Salination", "Heat_Ducts"),
        FixedWarp("Aether_Ridge", "Torrential_Railways"),
        FixedWarp("Aether_Ridge", "Coral_Caves"),
        FixedWarp("Aether_Ridge", "Sunbaked_Alley"),
        FixedWarp("Aether_Ridge", "Shrouded_Stacks"),
        FixedWarp("Aether_Ridge", "Daemon"),
        FixedWarp("Aether_Ridge", "Migration_Path"),
        FixedWarp("The_Surface", "Desolate_Tract"),
        FixedWarp("The_Surface", "Torrid_Desert"),
        FixedWarp("Cold_Storage", "The_Surface"),
        FixedWarp("The_Surface", "Daemon"),
        FixedWarp("The_Surface", "Shrouded_Stacks"),
        FixedWarp("Badlands", "Migration_Path"),
        FixedWarp("Badlands", "Daemon"),
        FixedWarp("Aether_Ridge", "Migration_Path"),
        FixedWarp("Migration_Path", "Daemon"),
        FixedWarp("Cold_Storage", "Migration_Path"),
        FixedWarp("Badlands", "Migration_Path"),
        FixedWarp("Outer_Rim", "Daemon"),
        FixedWarp("Pillar_Grove", "Daemon"),
        FixedWarp("Pillar_Grove", "Coral_Caves"),
        FixedWarp("Pillar_Grove", "Torrential_Railways"),
        FixedWarp("Pillar_Grove", "Shrouded_Stacks"),
        FixedWarp("Signal_Spires", "Daemon"),
        FixedWarp("Signal_Spires", "Verdant_Waterways"),
        FixedWarp("Coral_Caves", "Daemon"),
        FixedWarp("Coral_Caves", "Rusted_Wrecks"),
        FixedWarp("Aether_Ridge", "Coral_Caves"),
        FixedWarp("Turbulent_Pump", "Verdant_Waterways"),
        FixedWarp("Turbulent_Pump", "Daemon"),
        FixedWarp("Rusted_Wrecks", "Sunbaked_Alley"),
        FixedWarp("Rusted_Wrecks", "Desolate_Tract"),
        FixedWarp("Coral_Caves", "Rusted_Wrecks"),
        FixedWarp("Rusted_Wrecks", "Daemon"),
        FixedWarp("Outer_Rim", "Daemon"),
        FixedWarp("Daemon", "Torrential_Railways"),
        FixedWarp("Aether_Ridge", "Torrential_Railways"),
        FixedWarp("Pillar_Grove", "Torrential_Railways"),
        FixedWarp("Rusted_Wrecks", "Sunbaked_Alley"),
        FixedWarp("Aether_Ridge", "Sunbaked_Alley"),
        FixedWarp("Daemon", "Sunbaked_Alley"),
        FixedWarp("Cold_Storage", "Stormy_Coast"),
        FixedWarp("Daemon", "Stormy_Coast"),
        FixedWarp("Pillar_Grove", "Shrouded_Stacks"),
        FixedWarp("The_Surface", "Shrouded_Stacks"),
        FixedWarp("Daemon", "Shrouded_Stacks"),
        FixedWarp("Aether_Ridge", "Shrouded_Stacks"),
        FixedWarp("Cold_Storage", "Shrouded_Stacks"),
        FixedWarp("The_Surface", "Torrid_Desert"),
        FixedWarp("Heat_Ducts", "Torrid_Desert"),
        FixedWarp("Daemon", "Torrid_Desert"),
        FixedWarp("Daemon", "Desolate_Tract"),
        FixedWarp("The_Surface", "Desolate_Tract"),
        FixedWarp("Rusted_Wrecks", "Desolate_Tract"),
        FixedWarp("Daemon", "Verdant_Waterways"),
        FixedWarp("Turbulent_Pump", "Verdant_Waterways"),
        FixedWarp("Signal_Spires", "Verdant_Waterways"),
        FixedWarp("Daemon", "Fractured_Gateways"),
        FixedWarp("Fetid_Glen", "Fractured_Gateways")
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
        ["Migration_Path"] = SubRegion:new("Migration_Path", access),
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
        
        -- Rot Immune Regions
        ["Shattered_Terrace"] = SubRegion:new("Shattered_Terrace", access),
        ["Ancient_Urban"] = SubRegion:new("Ancient_Urban", access),
        ["Daemon"] = SubRegion:new("Daemon", access),

        -- Rotified Regions
        ["Corrupted_Factories"] = SubRegion:new("Corrupted_Factories", access),
        ["Crumbling_Fringes"] = SubRegion:new("Crumbling_Fringes", access),
        ["Decaying_Tunnels"] = SubRegion:new("Decaying_Tunnels", access),
        ["Infested_Wastes"] = SubRegion:new("Infested_Wastes", access),
        ["Unfortunate_Evolution"] = SubRegion:new("Unfortunate_Evolution", access),
        ["Outer_Rim"] = SubRegion:new("Outer_Rim", access)
    }

    print("Regions created for The Watcher")
    return regions
end


-- Using the values in game_data\data.py for the Rain World Archipelago repo use the following to format the "WarpPoints" and then run it through the generation file: 
--"([a-zA-Z]*)_.*": \{"to": "([a-zA-Z]*)_.*", "flags": \d\}   -->   Warp:new("$1", "$2")
--"([a-zA-Z]*)_.*": \{"to": "NULL", "flags": \d\}   -->   Warp:new("$1", "Daemon")

-- Spinning top warps:
--"([a-zA-Z]*)_.*": \{"to": "([a-zA-Z]*).*", "id": \d+, "ripple": (.*)\}   -->   Warp:new("$1", "$2", \L$3)
