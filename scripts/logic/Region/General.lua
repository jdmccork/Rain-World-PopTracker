-- Runs when a new slugcat is selected to update data for their campaign.
function get_regions(scug)
    -- Access outline the requirments to move about between regions
    local access = {
        Gate:new("Chimney_Canopy", "Sky_Islands", "Gate-Chimney_Canopy-Sky_Islands", 2, 3),
        Gate:new("Drainage_System", "Chimney_Canopy", "Gate-Drainage_System-Chimney_Canopy", 5, 3),
        Gate:new("Drainage_System", "Garbage_Wastes", "Gate-Drainage_System-Garbage_Wastes", 1, 3),
        Gate:new("Garbage_Wastes", "Shore", "Gate-Garbage_Wastes-Shoreline", 3, 2),
        Gate:new("Industrial_Complex", "Chimney_Canopy", "Gate-Industrial_Complex-Chimney_Canopy", 3, 3),
        Gate:new("Industrial_Complex", "Garbage_Wastes", "Gate-Industrial_Complex-Garbage_Wastes", 2, 2),
        Gate:new("Farm_Arrays", "Chasm", "Gate-Farm_Arrays-Subterranean", 4, 5),
        Gate:new("Farm_Arrays", "Sky_Islands", "Gate-Farm_Arrays-Sky_Islands", 3, 3),
        Gate:new("Subway", "Shore", "Gate-Subterranean-Shoreline", 2, 5),
        Gate:new("Access_Tunnel", "The_Wall", "Gate-The_Wall-Five_Pebbles", 1, 1),
        Gate:new("Memory_Conflux", "Underhang", "Gate-Underhang-Five_Pebbles", 5, 1),
        Gate:new("Outskirts_Center", "Industrial_Complex", "Gate-Outskirts-Industrial_Complex", 3, 2),
        Gate:new("Outskirts_Center", "Drainage_System", "Gate-Outskirts-Drainage_System", 4, 2),
        Gate:new("Outskirts_Center", "Farm_Arrays", "Gate-Outskirts-Farm_Arrays", 5, 2),
        Gate:new("The_Leg", "The_Precipice", "Gate-The_Leg-The_Precipice", 1, 1),
        TwoWay:new("The_Leg", "The_Precipice", {{{"saint", false}}}, {}),

        Gate:new("Filtration_System_DS", "Drainage_System", "Gate-Subterranean-Drainage_System", 1, 4),
        TwoWay:new("Filtration_System_DS", "Filtration_System", {}, {}),
        
        Gate:new("The_Precipice", "Looks_to_the_Moon", "Gate-The_Precipice-Looks_to_the_Moon", 5, 1),
        TwoWay:new("The_Precipice", "Looks_to_the_Moon", {{{"spearmaster", true}}}, {}),
        Gate:new("Shore", "Looks_to_the_Moon", "Gate-Waterfront_Facility-Looks_to_the_Moon", 1, 1),
        TwoWay:new("Shore", "Looks_to_the_Moon", {{{"spearmaster", true}}}, {}),
        
        Gate:new("Shaded_Citadel_GW", "Garbage_Wastes", "Gate-Garbage_Wastes-Shaded_Citadel", 2, 4),
        TwoWay:new("Shaded_Citadel_Center", "Shaded_Citadel_GW", {}, {}),

        Gate:new("Shaded_Citadel_HI", "Industrial_Complex", "Gate-Industrial_Complex-Shaded_Citadel", 1, 5),
        TwoWay:new("Shaded_Citadel_Center", "Shaded_Citadel_HI", {}, {}),

        Gate:new("Shaded_Citadel_UW", "The_Leg", "Gate-Shaded_Citadel-The_Leg", 1, 1),
        TwoWay:new("Shaded_Citadel_UW", "The_Leg", {{{"saint", false}}}, {}),
        TwoWay:new("Shaded_Citadel_Center", "Shaded_Citadel_UW", {}, {}),
        
        Gate:new("Chimney_Canopy", "The_Wall", "Gate-Chimney_Canopy-The_Wall", 4, 1),
        TwoWay:new("Chimney_Canopy", "The_Wall", {{{"saint", false}}}, {}),
        
        Gate:new("Shaded_Citadel_SL", "Shore", "Gate-Shaded_Citadel-Shoreline", 3, 2),
        TwoWay:new("Shaded_Citadel_SL", "Shore", {{{"notsaint", true}}}, {}),
        Gate:new("Silent_Construct", "Shore", "Gate-Shaded_Citadel-Shoreline", 1, 5),
        TwoWay:new("Silent_Construct", "Shaded_Citadel_SL", {{{"saint", true}}}, {}), -- Redirect Silent Construct to Shaded Citadel so logic isn't doubled
        TwoWay:new("Shaded_Citadel_Center", "Shaded_Citadel_SL", {}, {}),
        
        Gate:new("Subway", "Outer_Expanse", "Gate-Subterranean-Outer_Expanse", 2, 5),
        TwoWay:new("Subway", "Outer_Expanse", {{{"MSC", true}}}, {}),
        TwoWay:new("Subway", "Outer_Expanse", {{{"survivor", true}}, {{"monk", true}}, {{"gourmand", true}}}, {}),
        
        
        Gate:new("Roots", "Outer_Expanse", "Gate-Outer_Expanse-Outskirts", 1, 1), 
        TwoWay:new("Subway", "Outer_Expanse", {{{"MSC", true}}}, {}),
        TwoWay:new("Subway", "Outer_Expanse", {{{"survivor", true}}, {{"monk", true}}, {{"gourmand", true}}}, {}),
        
        Gate:new("Submerged", "Submerged_Superstructure_Center", "Gate-Shoreline-Submerged_Superstructure", 5, 1),
        TwoWay:new("Submerged", "Submerged_Superstructure_Center", {{{"MSC", true}, {"arti", false}, {"spearmaster", false}}}, {}),
        
        Gate:new("Above_Moon", "Bitter_Aerie", "Gate-Shoreline-Bitter_Aerie", nil, 1), -- Always available
        OneWay:new("Submerged_Superstructure_Center", "Bitter_Aerie", {{{"riv", true}, {"gravity", true}}, {{"saint", true}}}, {}),
        

        Gate:new("Industrial_Complex", "Pipeyard_Center", "Gate-Industrial_Complex-Pipeyard", 4, 2),
        TwoWay:new("Industrial_Complex", "Pipeyard_Center", {{{"MSC", true}}}, {}),
        
        Gate:new("Pipe_Filter", "Filtration_System", "Gate-Pipeyard-Subterranean", 5, 3),
        TwoWay:new("Pipe_Filter", "Filtration_System", {{{"MSC", true}}}, {}),
        TwoWay:new("Subway", "Filtration_System", {}, {}),
        TwoWay:new("Depth", "Filtration_System", {}, {}),

        Gate:new("Pipeyard_Center", "Sky_Islands", "Gate-Pipeyard-Sky_Islands", 4, 3),
        TwoWay:new("Pipeyard_Center", "Sky_Islands", {{{"MSC", true}}}, {}),

        
        
        
        Gate:new("The_Wall", "Metropolis", "Gate-The_Wall-Metropolis", 1, 5), -- Needs drone under certain conditions
        OneWay:new("Metropolis", "The_Wall", {}, {}),
        OneWay:new("The_Wall", "Metropolis", {
            {{"gatelogic", 0}, {"arti", true}},
            {{"gatelogic", 1}, {"drone", true}, {"arti", true}},
            {{"gatelogic", 2}, {"Gate-The_Wall-Metropolis", true}},
            {{"gatelogic", 2}, {"drone", true}, {"arti", true}},
            {{"gatelogic", 3}, {"drone", true}, {"arti", true}},
        }, {}),
        
        TwoWay:new("Pipeyard_Center", "Sump_Tunnel", {}, {}),
        TwoWay:new("Pipeyard_Center", "Pipe_Filter", {}, {}),

        
        Gate:new("Sump_Tunnel", "Shore", "Gate-Pipeyard-Shoreline", 3, 3),
        TwoWay:new("Sump_Tunnel", "Shore", {{{"MSC", true}}}, {}),
        TwoWay:new("Sump_Tunnel", "Shore", {}, {{{"aquatic-perk", true}, {"arti", true}}, {{"notarti", true}}}), -- Arti can't swim


        TwoWay:new("Shore", "Submerged", {}, {{{"subsanity", 1}, {"riv", true}}, {{"subsanity", 1}, {"aquatic-perk", true}}, {{"subsanity", 2}}}), -- Swim to Submerged
        TwoWay:new("Shore", "Submerged", {}, {
                                                {{"difficulty_submerged", 2}, {"time", true}, {"riv", true}}, 
                                                {{"difficulty_submerged", 2}, {"notriv", true}},
                                                {{"difficulty_submerged", 1}, {"aquatic-perk", true}}, 
                                                {{"difficulty_submerged", 1}, {"riv", true}}, 
                                                {{"difficulty_submerged", 0}}
                                            }),

        -- Looks to the Moon
        OneWay:new("Above_Moon", "Shore", {}, {}),
        OneWay:new("Shore", "Above_Moon", {}, {{{"jump-perk", true}}, {{"saint", true}}}),

        -- Exterior logic
        OneWay:new("The_Wall", "Underhang", {}, {{{"arti", true}}, {{"spearmaster", true}}, {{"jump-perk", true}}}),
        OneWay:new("Underhang", "The_Wall", {}, {{{"notriv", true}}}),
        TwoWay:new("The_Leg", "Underhang", {}, {}),

        OneWay:new("Chasm", "Subway", {}, {}), -- Falling down the pit outside the Farm Array gate
        OneWay:new("Subway", "Chasm", {}, {{{"arti", true}}, {{"saint", true}}, {{"jump-perk", true}}}),
        OneWay:new("Above_Spawn", "Outskirts_Center", {}, {}), -- Falling down the spawn hole that Surv/Monk exit
        OneWay:new("Outskirts_Center", "Above_Spawn", {{{"MSC", true}}}, {{{"arti", true}}, {{"saint", true}}, {{"jump-perk", true}} }),
        OneWay:new("Roots", "Above_Spawn", {}, {}), -- The water pipe outside the gate from Outer Expanse

        --Passing through Five Pebbles
        TwoWay:new("Access_Tunnel", "Puppet_Chamber", {}, {}),
        OneWay:new("Memory_Conflux", "Puppet_Chamber", {}, {}),
        OneWay:new("Puppet_Chamber", "Memory_Conflux", {}, {{{"riv", true}}}),

        -- Waterfront Facility logic
        TwoWay:new("The_Precipice", "Shore", {{{"spearmaster", true}}, {{"arti", true}}}, {}),

        OneWay:new("Depth", "Rubicon", {{{"saint", true}, {"Karma", 8}}}, {})
    }



    local regions = {
        -- Exterior
        ["The_Wall"] = SubRegion:new("The_Wall", access, {"The_Exterior"}),
        ["Underhang"] = SubRegion:new("Underhang", access, {"The_Exterior"}),
        ["The_Leg"] = SubRegion:new("The_Leg", access, {"The_Exterior"}),

        -- Subterranean
        ["Depth"] = SubRegion:new("Depth", access, {"Subterranean", "Primordial_Underground"}),
        ["Filtration_System"] = SubRegion:new("Filtration_System", access, {"Subterranean", "Primordial_Underground"}, true),
        ["Filtration_System_DS"] = SubRegion:new("Filtration_System_DS", access, {"Subterranean", "Primordial_Underground"}),
        ["Subway"] = SubRegion:new("Subway", access, {"Subterranean", "Primordial_Underground"}),
        ["Chasm"] = SubRegion:new("Chasm", access, {"Subterranean", "Primordial_Underground"}),

        -- Shaded_Citadel
        ["Shaded_Citadel_GW"] = SubRegion:new("Shaded_Citadel_GW", access, {"Shaded_Citadel", "Silent_Construct"}),
        ["Shaded_Citadel_UW"] = SubRegion:new("Shaded_Citadel_UW", access, {"Shaded_Citadel", "Silent_Construct"}),
        ["Shaded_Citadel_SL"] = SubRegion:new("Shaded_Citadel_SL", access, {"Shaded_Citadel", "Silent_Construct"}),
        ["Shaded_Citadel_HI"] = SubRegion:new("Shaded_Citadel_HI", access, {"Shaded_Citadel", "Silent_Construct"}),
        ["Shaded_Citadel_Center"] = SubRegion:new("Shaded_Citadel_Center", access, {"Shaded_Citadel", "Silent_Construct"}, true),
       
        -- Outskirts
        ["Roots"] = SubRegion:new("Roots", access, {"Outskirts", "Suburban_Drifts"}),
        ["Outskirts_Center"] = SubRegion:new("Outskirts_Center", access, {"Outskirts", "Suburban_Drifts"}),
        ["Above_Spawn"] = SubRegion:new("Above_Spawn", access, {"Outskirts", "Suburban_Drifts"}),
       
        -- Shoreline
        ["The_Precipice"] = SubRegion:new("The_Precipice", access, {"Shoreline", "Frigid_Coast", "Waterfront_Facility"}),
        ["Shore"] = SubRegion:new("Shore", access, {"Shoreline", "Frigid_Coast", "Waterfront_Facility"}),
        ["Submerged"] = SubRegion:new("Submerged", access, {"Shoreline", "Frigid_Coast", "Waterfront_Facility"}),
        ["Above_Moon"] = SubRegion:new("Above_Moon", access, {"Shoreline", "Frigid_Coast", "Waterfront_Facility"}),
        
        -- Five Pebbles
        ["Access_Tunnel"] = SubRegion:new("Access_Tunnel", access, {"Five_Pebbles", "The_Rot"}),
        ["Memory_Conflux"] = SubRegion:new("Memory_Conflux", access, {"Five_Pebbles", "The_Rot"}),
        ["Puppet_Chamber"] = SubRegion:new("Puppet_Chamber", access, {"Five_Pebbles", "The_Rot"}),
        
        ["Pipeyard_Center"] = SubRegion:new("Pipeyard_Center", access, {"Pipeyard", "Barren_Conduits"}),
        ["Sump_Tunnel"] = SubRegion:new("Sump_Tunnel", access, {"Pipeyard", "Barren_Conduits"}, true),
        ["Pipe_Filter"] = SubRegion:new("Pipe_Filter", access, {"Pipeyard", "Barren_Conduits"}, true),

        ["Chimney_Canopy"] = SubRegion:new("Chimney_Canopy", access, {"Chimney_Canopy", "Solitary_Towers"}),
        ["Drainage_System"] = SubRegion:new("Drainage_System", access, {"Drainage_System", "Undergrowth"}),
        ["Garbage_Wastes"] = SubRegion:new("Garbage_Wastes", access, {"Garbage_Wastes", "Glacial_Wasteland"}),
        ["Industrial_Complex"] = SubRegion:new("Industrial_Complex", access, {"Industrial_Complex", "Icy_Monument"}),
        ["Farm_Arrays"] = SubRegion:new("Farm_Arrays", access, {"Farm_Arrays", "Desolate_Fields"}),
        ["Sky_Islands"] = SubRegion:new("Sky_Islands", access, {"Sky_Islands", "Windswept_Spires"}),
        ["Silent_Construct"] = SubRegion:new("Silent_Construct", access, {"Silent_Construct"}),
        ["Looks_to_the_Moon"] = SubRegion:new("Looks_to_the_Moon", access, {"Looks_to_the_Moon"}),
        ["Metropolis"] = SubRegion:new("Metropolis", access, {"Metropolis"}),
        ["Outer_Expanse"] = SubRegion:new("Outer_Expanse", access, {"Outer_Expanse"}),
        ["Submerged_Superstructure_Center"] = SubRegion:new("Submerged_Superstructure_Center", access, {"Submerged_Superstructure"}),
        ["Bitter_Aerie"] = SubRegion:new("Bitter_Aerie", access, {"Submerged_Superstructure"}),
        ["Rubicon"] = SubRegion:new("Rubicon", access, {"Rubicon"})
    }

    print("regions created")
    return regions
end
