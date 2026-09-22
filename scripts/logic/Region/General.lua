-- Runs when a new slugcat is selected to update data for their campaign.
function get_regions()
    -- Access outline the requirments to move about between regions
    local access = {
        Gate:new("Chimney_Canopy", "Sky_Islands", "Gate-Chimney_Canopy-Sky_Islands", 2, 3),
        Gate:new("Chimney_Canopy", "The_Wall", "Gate-Chimney_Canopy-The_Wall", 4, 1),
        Gate:new("Drainage_System", "Chimney_Canopy", "Gate-Drainage_System-Chimney_Canopy", 5, 3),
        Gate:new("Drainage_System", "Garbage_Wastes", "Gate-Drainage_System-Garbage_Wastes", 1, 3),
        Gate:new("Garbage_Wastes", "Shore", "Gate-Garbage_Wastes-Shoreline", 3, 2),
        Gate:new("Garbage_Wastes", "Shaded_Citadel_GW", "Gate-Garbage_Wastes-Shaded_Citadel", 4, 2),
        Gate:new("Industrial_Complex", "Chimney_Canopy", "Gate-Industrial_Complex-Chimney_Canopy", 3, 3),
        Gate:new("Industrial_Complex", "Garbage_Wastes", "Gate-Industrial_Complex-Garbage_Wastes", 2, 2),
        Gate:new("Industrial_Complex", "Shaded_Citadel_HI", "Gate-Industrial_Complex-Shaded_Citadel", 5, 1),
        Gate:new("Industrial_Complex", "Pipeyard", "Gate-Industrial_Complex-Pipeyard", 4, 2),
        Gate:new("Farm_Arrays", "Chasm", "Gate-Farm_Arrays-Subterranean", 4, 5),
        Gate:new("Farm_Arrays", "Sky_Islands", "Gate-Farm_Arrays-Sky_Islands", 3, 3),
        Gate:new("Filtration_System", "Drainage_System", "Gate-Subterranean-Drainage_System", 1, 4),
        Gate:new("Subway", "Shore", "Gate-Subterranean-Shoreline", 2, 5),
        Gate:new("Subway", "Outer_Expanse", "Gate-Subterranean-Outer_Expanse", 2, 5),
        Gate:new("Access_Tunnel", "The_Wall", "Gate-The_Wall-Five_Pebbles", 1, 1),
        Gate:new("Memory_Conflux", "Underhang", "Gate-Underhang-Five_Pebbles", 5, 1),
        Gate:new("The_Leg", "The_Precipice", "Gate-The_Leg-The_Precipice", 1, 1),
        Gate:new("Outskirts_Center", "Industrial_Complex", "Gate-Outskirts-Industrial_Complex", 3, 2),
        Gate:new("Outskirts_Center", "Drainage_System", "Gate-Outskirts-Drainage_System", 4, 2),
        Gate:new("Outskirts_Center", "Farm_Arrays", "Gate-Outskirts-Farm_Arrays", 5, 2),
        Gate:new("Roots", "Outer_Expanse", "Gate-Outer_Expanse-Outskirts", 1, 1), -- Always available
        Gate:new("Shaded_Citadel_UW", "The_Leg", "Gate-Shaded_Citadel-The_Leg", 1, 1),
        Gate:new("Shaded_Citadel_SL", "Shore", "Gate-Shaded_Citadel-Shoreline", 3, 2),
        Gate:new("Shore", "Looks_to_the_Moon", "Gate-The_Precipice-Looks_to_the_Moon", 5, 1),
        Gate:new("Submerged", "Submerged_Superstructure_Center", "Gate-Shoreline-Submerged_Superstructure", 5, 1),
        Gate:new("Above_Moon", "Bitter_Aerie", "Gate-Shoreline-Bitter_Aerie", nil, 1), -- Always available
        Gate:new("Shore", "Silent_Construct", "Gate-Shoreline-Silent_Construct", 5, 1),
        Gate:new("Pipeyard", "Filtration_System", "Gate-Pipeyard-Subterranean", 5, 3),
        Gate:new("Pipeyard", "Sky_Islands", "Gate-Pipeyard-Sky_Islands", 4, 3),
        Gate:new("Pipeyard", "Shore", "Gate-Pipeyard-Shoreline", 3, 3),
        Gate:new("Metro_Entry", "Metropolis", "Gate-The_Wall-Metropolis", 1, 5),

        -- Glowing checks
        TwoWay:new("Subway", "Filtration_System", {}, {{"glow-item"}, {"glow-option"}, {"gourmand"}}),
        TwoWay:new("Depth", "Filtration_System", {}, {{"glow-item"}, {"glow-option"}, {"gourmand"}}),
        TwoWay:new("Shaded_Citadel_Center", "Shaded_Citadel_GW", {}, {{"glow-item"}, {"glow-option"}, {"gourmand"}}),
        TwoWay:new("Shaded_Citadel_Center", "Shaded_Citadel_UW", {}, {{"glow-item"}, {"glow-option"}, {"gourmand"}}),
        TwoWay:new("Shaded_Citadel_Center", "Shaded_Citadel_SL", {}, {{"glow-item"}, {"glow-option"}, {"gourmand"}}),
        TwoWay:new("Shaded_Citadel_Center", "Shaded_Citadel_HI", {}, {{"glow-item"}, {"glow-option"}, {"gourmand"}}),

        -- Swimming checks
        TwoWay:new("Sump_Tunnel", "Shore", {{"arti"}}, {{"aquatic-perk"}}), -- Arti can't swim
        TwoWay:new("Sump_Tunnel", "Shore", {{"notarti"}}, {}), -- All others can swim
        TwoWay:new("Shore", "Submerged", {}, {{"sub_aquatic", "riv"}, {"sub_aquatic", "aquatic-perk"}, {{"sub_all", 2}}}), -- Swim to Submerged
        OneWay:new("Submerged_Superstructure_Main", "Bitter_Aerie", {{"riv", "gravity"}}, {}),

        -- Looks to the Moon
        OneWay:new("Above_Moon", "Shore", {}, {}),
        OneWay:new("Shore", "Above_Moon", {}, {{"jump-perk"}, {"saint"}}),

        -- Not implemented
        OneWay:new("The_Wall", "Underhang", {}, {{"arti", "spearmaster"}}),
        OneWay:new("Underhang", "The_Wall", {}, {{"notriv"}}),
        TwoWay:new("The_Leg", "Underhang", {}, {}),
        OneWay:new("Metro_Entry", "The_Wall", {}, {}),
        OneWay:new("The_Wall", "Metro_Entry", {{"drone", "arti"}}, {}),

        OneWay:new("Chasm", "Subway", {}, {}), -- Falling down the pit outside the Farm Array gate
        OneWay:new("Subway", "Chasm", {}, {{"arti"}, {"saint"}}), -- TODO: Climbing back up the pit outside the Farm Array gate
        OneWay:new("Above_Spawn", "Outskirts_Center", {}, {}), -- Falling down the spawn hole that Surv/Monk exit
        OneWay:new("Outskirts_Center", "Above_Spawn", {{"MSC"}}, {{"arti"}, {"saint"}}), -- TODO: Climbing back up the spawn hole that Surv/Monk exit
        OneWay:new("Roots", "Above_Spawn", {}, {}), -- The water pipe outside the gate from Outer Expanse

        --Passing through Five Pebbles
        OneWay:new("Access_Tunnel", "Puppet_Chamber", {}, {}),
        OneWay:new("Memory_Conflux", "Puppet_Chamber", {}, {}),
        OneWay:new("Puppet_Chamber", "Access_Tunnel", {}, {{"arti"}, {"riv"}}),
        OneWay:new("Puppet_Chamber", "Memory_Conflux", {}, {{"arti"}, {"riv"}})
    }
    print("regions created")
    return {
        -- Exterior
        ["Metro_Entry"] = SubRegion:new("Metro_Entry", access, "The_Exterior"),
        ["The_Wall"] = SubRegion:new("The_Wall", access, "The_Exterior"),
        ["Underhang"] = SubRegion:new("Underhang", access, "The_Exterior"),
        ["The_Leg"] = SubRegion:new("The_Leg", access, "The_Exterior"),

        -- Subterranean
        ["Depth"] = SubRegion:new("Depth", access, "Subterranean"),
        ["Filtration_System"] = SubRegion:new("Filtration_System", access, "Subterranean"),
        ["Subway"] = SubRegion:new("Subway", access, "Subterranean"),
        ["Chasm"] = SubRegion:new("Chasm", access, "Subterranean"),

        -- Shaded_Citadel
        ["Shaded_Citadel_GW"] = SubRegion:new("Shaded_Citadel_GW", access, "Shaded_Citadel"),
        ["Shaded_Citadel_UW"] = SubRegion:new("Shaded_Citadel_UW", access, "Shaded_Citadel"),
        ["Shaded_Citadel_SL"] = SubRegion:new("Shaded_Citadel_SL", access, "Shaded_Citadel"),
        ["Shaded_Citadel_HI"] = SubRegion:new("Shaded_Citadel_HI", access, "Shaded_Citadel"),
        ["Shaded_Citadel_Center"] = SubRegion:new("Shaded_Citadel_Center", access, "Shaded_Citadel"),
       
        -- Outskirts
        ["Roots"] = SubRegion:new("Roots", access, "Outskirts"),
        ["Outskirts_Center"] = SubRegion:new("Outskirts_Center", access, "Outskirts"),
        ["Above_Spawn"] = SubRegion:new("Above_Spawn", access, "Outskirts"),
       
        -- Shoreline
        ["Sump_Tunnel"] = SubRegion:new("Sump_Tunnel", access, "Shoreline"),
        ["The_Precipice"] = SubRegion:new("The_Precipice", access, "Shoreline"),
        ["Shore"] = SubRegion:new("Shore", access, "Shoreline"),
        ["Submerged"] = SubRegion:new("Submerged", access, "Shoreline"),
        ["Above_Moon"] = SubRegion:new("Above_Moon", access, "Shoreline"),
        
        -- Five Pebbles
        ["Access_Tunnel"] = SubRegion:new("Access_Tunnel", access, "Five_Pebbles"),
        ["Memory_Conflux"] = SubRegion:new("Memory_Conflux", access, "Five_Pebbles"),
        ["Puppet_Chamber"] = SubRegion:new("Puppet_Chamber", access, "Five_Pebbles"),
        
        ["Chimney_Canopy"] = SubRegion:new("Chimney_Canopy", access, "Chimney_Canopy"),
        ["Drainage_System"] = SubRegion:new("Drainage_System", access, "Drainage_System"),
        ["Garbage_Wastes"] = SubRegion:new("Garbage_Wastes", access, "Garbage_Wastes"),
        ["Industrial_Complex"] = SubRegion:new("Industrial_Complex", access, "Industrial_Complex"),
        ["Farm_Arrays"] = SubRegion:new("Farm_Arrays", access, "Farm_Arrays"),
        ["Subterranean"] = SubRegion:new("Subterranean", access, "Subterranean"),
        ["Sky_Islands"] = SubRegion:new("Sky_Islands", access, "Sky_Islands"),
        ["Silent_Construct"] = SubRegion:new("Silent_Construct", access, "Silent_Construct"),
        ["Looks_to_the_Moon"] = SubRegion:new("Looks_to_the_Moon", access, "Looks_to_the_Moon"),
        ["Metropolis"] = SubRegion:new("Metropolis", access, "Metropolis"),
        ["Outer_Expanse"] = SubRegion:new("Outer_Expanse", access, "Outer_Expanse"),
        ["Pipeyard"] = SubRegion:new("Pipeyard", access, "Pipeyard"),
        ["Submerged_Superstructure_Center"] = SubRegion:new("Submerged_Superstructure_Center", access, "Submerged_Superstructure"),
        ["Bitter_Aerie"] = SubRegion:new("Bitter_Aerie", access, "Submerged_Superstructure")
    }
end
