-- Runs when a new slugcat is selected to update data for their campaign.
function get_regions(scug)
    -- Access outline the requirments to move about between regions
    local access = {
        Gate:new("Chimney_Canopy", "Sky_Islands", "Gate-Chimney_Canopy-Sky_Islands", 2, 3),
        Gate:new("Chimney_Canopy", "The_Wall", "Gate-Chimney_Canopy-The_Wall", 4, 1),
        Gate:new("Drainage_System", "Chimney_Canopy", "Gate-Drainage_System-Chimney_Canopy", 5, 3),
        Gate:new("Drainage_System", "Garbage_Wastes", "Gate-Drainage_System-Garbage_Wastes", 1, 3),
        Gate:new("Garbage_Wastes", "Shore", "Gate-Garbage_Wastes-Shoreline", 3, 2),
        Gate:new("Industrial_Complex", "Chimney_Canopy", "Gate-Industrial_Complex-Chimney_Canopy", 3, 3),
        Gate:new("Industrial_Complex", "Garbage_Wastes", "Gate-Industrial_Complex-Garbage_Wastes", 2, 2),
        
        
        Gate:new("Farm_Arrays", "Chasm", "Gate-Farm_Arrays-Subterranean", 4, 5),
        Gate:new("Farm_Arrays", "Sky_Islands", "Gate-Farm_Arrays-Sky_Islands", 3, 3),
        Gate:new("Filtration_System", "Drainage_System", "Gate-Subterranean-Drainage_System", 1, 4),
        Gate:new("Subway", "Shore", "Gate-Subterranean-Shoreline", 2, 5),
        Gate:new("Access_Tunnel", "The_Wall", "Gate-The_Wall-Five_Pebbles", 1, 1),
        Gate:new("Memory_Conflux", "Underhang", "Gate-Underhang-Five_Pebbles", 5, 1),
        Gate:new("The_Leg", "The_Precipice", "Gate-The_Leg-The_Precipice", 1, 1),
        Gate:new("Outskirts_Center", "Industrial_Complex", "Gate-Outskirts-Industrial_Complex", 3, 2),
        Gate:new("Outskirts_Center", "Drainage_System", "Gate-Outskirts-Drainage_System", 4, 2),
        Gate:new("Outskirts_Center", "Farm_Arrays", "Gate-Outskirts-Farm_Arrays", 5, 2),
        Gate:new("Shore", "Looks_to_the_Moon", "Gate-The_Precipice-Looks_to_the_Moon", 5, 1),
        
        Gate:new("Shaded_Citadel_GW", "Garbage_Wastes", "Gate-Garbage_Wastes-Shaded_Citadel", 2, 4),
        Gate:new("Shaded_Citadel_HI", "Industrial_Complex", "Gate-Industrial_Complex-Shaded_Citadel", 1, 5),
        Gate:new("Shaded_Citadel_UW", "The_Leg", "Gate-Shaded_Citadel-The_Leg", 1, 1),
        
        Gate:new("Shaded_Citadel_SL", "Shore", "Gate-Shaded_Citadel-Shoreline", 3, 2),
        TwoWay:new("Shaded_Citadel_SL", "Shore", {{{"notsaint", true}}}, {}),
        Gate:new("Silent_Construct", "Shore", "Gate-Shaded_Citadel-Shoreline", 1, 5),
        TwoWay:new("Silent_Construct", "Shaded_Citadel_SL", {{{"saint", true}}}, {}),
        
        Gate:new("Subway", "Outer_Expanse", "Gate-Subterranean-Outer_Expanse", 2, 5),
        TwoWay:new("Subway", "Outer_Expanse", {{{"MSC", true}}}, {}),
        TwoWay:new("Subway", "Outer_Expanse", {{{"survivor", true}}, {{"monk", true}}, {{"gourmand", true}}}, {}),
        
        
        Gate:new("Roots", "Outer_Expanse", "Gate-Outer_Expanse-Outskirts", 1, 1), 
        TwoWay:new("Subway", "Outer_Expanse", {{{"MSC", true}}}, {}),
        TwoWay:new("Subway", "Outer_Expanse", {{{"survivor", true}}, {{"monk", true}}, {{"gourmand", true}}}, {}),
        
        Gate:new("Submerged", "Submerged_Superstructure_Center", "Gate-Shoreline-Submerged_Superstructure", 5, 1),
        TwoWay:new("Submerged", "Submerged_Superstructure_Center", {{{"MSC", true}}}, {}),
        
        Gate:new("Above_Moon", "Bitter_Aerie", "Gate-Shoreline-Bitter_Aerie", nil, 1), -- Always available
        TwoWay:new("Submerged", "Submerged_Superstructure_Center", {{{"MSC", true}}}, {}),
        

        Gate:new("Industrial_Complex", "Pipeyard", "Gate-Industrial_Complex-Pipeyard", 4, 2),
        TwoWay:new("Industrial_Complex", "Pipeyard", {{{"MSC", true}}}, {}),
        
        Gate:new("Pipeyard", "Filtration_System", "Gate-Pipeyard-Subterranean", 5, 3),
        TwoWay:new("Pipeyard", "Filtration_System", {{{"MSC", true}}}, {}),

        Gate:new("Pipeyard", "Sky_Islands", "Gate-Pipeyard-Sky_Islands", 4, 3),
        TwoWay:new("Pipeyard", "Sky_Islands", {{{"MSC", true}}}, {}),
        
        Gate:new("Pipeyard", "Shore", "Gate-Pipeyard-Shoreline", 3, 3),
        TwoWay:new("Pipeyard", "Shore", {{{"MSC", true}}}, {}),
        
        Gate:new("The_Wall", "Metropolis", "Gate-The_Wall-Metropolis", 1, 5), -- Needs drone under certain conditions
        OneWay:new("Metropolis", "The_Wall", {}, {}),
        OneWay:new("The_Wall", "Metropolis", {
            {{"gatelogic", 0}, {"arti", true}},
            {{"gatelogic", 1}, {"drone", true}, {"arti", true}},
            {{"gatelogic", 2}, {"Gate-The_Wall-Metropolis", true}},
            {{"gatelogic", 2}, {"drone", true}, {"arti", true}},
            {{"gatelogic", 3}, {"drone", true}, {"arti", true}},
        }, {}),

        -- Glowing checks
        TwoWay:new("Subway", "Filtration_System", {}, {{{"glow-item", true}}, {{"glow-option", true}}, {{"gourmand", true}}}),
        TwoWay:new("Depth", "Filtration_System", {}, {{{"glow-item", true}}, {{"glow-option", true}}, {{"gourmand", true}}}),
        TwoWay:new("Shaded_Citadel_Center", "Shaded_Citadel_GW", {}, {{{"glow-item", true}}, {{"glow-option", true}}, {{"gourmand", true}}, {{"saint", true}}}),
        TwoWay:new("Shaded_Citadel_Center", "Shaded_Citadel_UW", {}, {{{"glow-item", true}}, {{"glow-option", true}}, {{"gourmand", true}}, {{"saint", true}}}),
        TwoWay:new("Shaded_Citadel_Center", "Shaded_Citadel_SL", {}, {{{"glow-item", true}}, {{"glow-option", true}}, {{"gourmand", true}}, {{"saint", true}}}),
        TwoWay:new("Shaded_Citadel_Center", "Shaded_Citadel_HI", {}, {{{"glow-item", true}}, {{"glow-option", true}}, {{"gourmand", true}}, {{"saint", true}}}),

        -- Swimming checks
        TwoWay:new("Sump_Tunnel", "Shore", {{{"arti", true}}}, {{{"aquatic-perk", true}}}), -- Arti can't swim
        TwoWay:new("Sump_Tunnel", "Shore", {{{"notarti", true}}}, {}), -- All others can swim
        TwoWay:new("Shore", "Submerged", {}, {{{"subsanity", 1}, {"riv", true}}, {{"subsanity", 1}, {"aquatic-perk", true}}, {{"subsanity", 2}}}), -- Swim to Submerged
        TwoWay:new("Shore", "Submerged", {}, {
                                                {{"submerged_difficulty", 2}, {"time", true}, {"riv", true}}, 
                                                {{"submerged_difficulty", 2}, {"notriv", true}}, -- TODO: Check what Longer Cycles does with other scugs
                                                {{"submerged_difficulty", 1}, {"aquatic-perk", true}}, 
                                                {{"submerged_difficulty", 1}, {"riv", true}}, 
                                                {{"submerged_difficulty", 0}}
                                            }), -- TODO: Test how cycles option works with other scugs
        OneWay:new("Submerged_Superstructure_Main", "Bitter_Aerie", {{{"riv", true}, {"gravity", true}}}, {}),

        -- Looks to the Moon
        OneWay:new("Above_Moon", "Shore", {}, {}),
        OneWay:new("Shore", "Above_Moon", {}, {{{"jump-perk", true}}, {{"saint", true}}}),

        -- Exterior logic
        OneWay:new("The_Wall", "Underhang", {}, {{{"arti", true}}, {{"spearmaster", true}}, {{"jump-perk", true}}}),
        OneWay:new("Underhang", "The_Wall", {}, {{{"notriv", true}}}),
        TwoWay:new("The_Leg", "Underhang", {}, {}),

        OneWay:new("Chasm", "Subway", {}, {}), -- Falling down the pit outside the Farm Array gate
        OneWay:new("Subway", "Chasm", {}, {{{"arti", true}}, {{"saint", true}}}), -- TODO: Climbing back up the pit outside the Farm Array gate
        OneWay:new("Above_Spawn", "Outskirts_Center", {}, {}), -- Falling down the spawn hole that Surv/Monk exit
        OneWay:new("Outskirts_Center", "Above_Spawn", {{{"MSC", true}}}, {{{"arti", true}}, {{"saint", true}}}), -- TODO: Climbing back up the spawn hole that Surv/Monk exit
        OneWay:new("Roots", "Above_Spawn", {}, {}), -- The water pipe outside the gate from Outer Expanse

        --Passing through Five Pebbles
        OneWay:new("Access_Tunnel", "Puppet_Chamber", {}, {}),
        OneWay:new("Memory_Conflux", "Puppet_Chamber", {}, {}),
        OneWay:new("Puppet_Chamber", "Access_Tunnel", {}, {{{"arti", true}}, {{"riv", true}}}),
        OneWay:new("Puppet_Chamber", "Memory_Conflux", {}, {{{"arti", true}}, {{"riv", true}}})
    }



    local regions = {
        -- Exterior
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

    print("regions created")
    return regions
end
