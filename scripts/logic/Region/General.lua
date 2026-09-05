-- Runs when a new slugcat is selected to update data for their campaign.
function init_regions()
    -- Gates connect between regions. Should these be kept as Gate objects, or should I combine them into OneWay or TwoWay?
    local gates = {
        Gate:new("Chimney_Canopy", "Sky_Islands", "Gate-Chimney_Canopy-Sky_Islands", 2, 3),
        Gate:new("Chimney_Canopy", "The_Exterior", "Gate-Chimney_Canopy-The_Wall", 4, 1),
        Gate:new("Drainage_System", "Chimney_Canopy", "Gate-Drainage_System-Chimney_Canopy", 5, 3),
        Gate:new("Drainage_System", "Garbage_Wastes", "Gate-Drainage_System-Garbage_Wastes", 1, 3),
        Gate:new("Garbage_Wastes", "Shoreline", "Gate-Garbage_Wastes-Shoreline", 3, 2),
        Gate:new("Garbage_Wastes", "Shaded_Citadel", "Gate-Garbage_Wastes-Shaded_Citadel", 4, 2),
        Gate:new("Industrial_Complex", "Chimney_Canopy", "Gate-Industrial_Complex-Chimney_Canopy", 3, 3),
        Gate:new("Industrial_Complex", "Garbage_Wastes", "Gate-Industrial_Complex-Garbage_Wastes", 2, 2),
        Gate:new("Industrial_Complex", "Shaded_Citadel", "Gate-Industrial_Complex-Shaded_Citadel", 5, 1),
        Gate:new("Industrial_Complex", "Pipeyard", "Gate-Industrial_Complex-Pipeyard", 4, 2),
        Gate:new("Farm_Arrays", "Subterranean", "Gate-Farm_Arrays-Subterranean", 4, 5),
        Gate:new("Farm_Arrays", "Sky_Islands", "Gate-Farm_Arrays-Sky_Islands", 3, 3),
        Gate:new("Subterranean", "Drainage_System", "Gate-Subterranean-Drainage_System", 1, 4),
        Gate:new("Subterranean", "Shoreline", "Gate-Subterranean-Shoreline", 2, 5),
        Gate:new("Subterranean", "Outer_Expanse", "Gate-Subterranean-Outer_Expanse", 2, 5),
        Gate:new({"The_Exterior", "Access_Tunnel"}, {"Five_Pebbles", "The_Wall"}, "Gate-The_Wall-Five_Pebbles", 1, 1),
        Gate:new({"The_Exterior", "Memory_Conflux"}, {"Five_Pebbles", "Underhang"}, "Gate-Underhang-Five_Pebbles", 5, 1),
        Gate:new("The_Exterior", "Shoreline", "Gate-The_Leg-The_Precipice", 1, 1),
        Gate:new("Outskirts", "Industrial_Complex", "Gate-Outskirts-Industrial_Complex", 3, 2),
        Gate:new("Outskirts", "Drainage_System", "Gate-Outskirts-Drainage_System", 4, 2),
        Gate:new("Outskirts", "Farm_Arrays", "Gate-Outskirts-Farm_Arrays", 5, 2),
        Gate:new("Outskirts", "Outer_Expanse", "Gate-Outer_Expanse-Outskirts", 5, 1),
        Gate:new("Shaded_Citadel", "The_Exterior", "Gate-Shaded_Citadel-The_Leg", 1, 1),
        Gate:new("Shaded_Citadel", "Shoreline", "Gate-Shaded_Citadel-Shoreline", 3, 2),
        Gate:new("Shoreline", "Looks_to_the_Moon", "Gate-The_Precipice-Looks_to_the_Moon", 5, 1),
        Gate:new("Shoreline", "Submerged_Superstructure", "Gate-Shoreline-Submerged_Superstructure", 5, 1),
        Gate:new("Shoreline", "Silent_Construct", "Gate-Shoreline-Silent_Construct", 5, 1),
        Gate:new("Pipeyard", "Subterranean", "Gate-Pipeyard-Subterranean", 5, 3),
        Gate:new("Pipeyard", "Sky_Islands", "Gate-Pipeyard-Sky_Islands", 4, 3),
        Gate:new("Pipeyard", "Shoreline", "Gate-Pipeyard-Shoreline", 3, 3),
        Gate:new("The_Exterior", "Metropolis", "Gate-The_Wall-Metropolis", nil, 5)
    }

    -- Access outline the requirments to move about within a region
    local access = {
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
        
        -- Not implemented
        TwoWay:new("The_Wall", "Underhang", {}, {}),
        TwoWay:new("The_Leg", "Underhang", {}, {}),

        OneWay:new("Chasm", "Subway", {}, {}), -- The pit outside the Farm Array gate
        OneWay:new("Subway", "Chasm", {}, {}), -- TODO: Climbing back up the pit outside the Farm Array gate
        OneWay:new("Above_Spawn", "Spawn", {}, {}), -- The spawn hole that Surv/Monk exit
        OneWay:new("Spawn", "Above_Spawn", {{"MSC"}}, {{"arti"}}), -- TODO: Climbing back up the spawn hole that Surv/Monk exit
        OneWay:new("Roots", "Above_Spawn", {}, {}), -- The water pipe outside the gate from Outer Expanse

        --Passing through Five Pebbles
        OneWay:new("Access_Tunnel", "Puppet_Chamber", {}, {}),
        OneWay:new("Memory_Conflux", "Puppet_Chamber", {}, {}),
        OneWay:new("Puppet_Chamber", "Access_Tunnel", {}, {{"arti"}, {"riv"}}),
        OneWay:new("Puppet_Chamber", "Memory_Conflux", {}, {{"arti"}, {"riv"}})
    }
    
    local sub_regions = {
        -- Exterior
        ["The_Exterior"] = {
            SubRegion:new("The_Wall", access, {["Chimney_Canopy"] = true, ["Five_Pebbles"] = true, ["Metropolis"] = true}),
            SubRegion:new("Underhang", access, {["Five_Pebbles"] = true}),
            SubRegion:new("The_Leg", access, {["Shoreline"] = true, ["Shaded_Citadel"] = true})
        },
        -- Subterranean
        ["Subterranean"] = {
            SubRegion:new("Depth", access),
            SubRegion:new("Filtration_System", access, {["Pipeyard"] = true, ["Drainage_System"] = true}),
            SubRegion:new("Subway", access, {["Outer_Expanse"] = true, ["Shoreline"] = true}),
            SubRegion:new("Chasm", access, {["Farm_Arrays"] = true})
        },
        -- Shaded_Citadel
        ["Shaded_Citadel"] = {
            SubRegion:new("Shaded_Citadel_GW", access, {["Garbage_Wastes"] = true}),
            SubRegion:new("Shaded_Citadel_UW", access, {["The_Exterior"] = true}),
            SubRegion:new("Shaded_Citadel_SL", access, {["Shoreline"] = true}),
            SubRegion:new("Shaded_Citadel_HI", access, {["Industrial_Complex"] = true}),
            SubRegion:new("Shaded_Citadel_Center", access)
        },
        -- Outskirts
        ["Outskirts"] = {
            SubRegion:new("Roots", access, {["Outer_Expanse"] = true}),
            SubRegion:new("Spawn", access, {["Industrial_Complex"] = true, ["Farm_Arrays"] = true, ["Drainage_System"] = true}),
            SubRegion:new("Above_Spawn", access)
        },
        -- Garbage Wastes
        ["Garbage_Wastes"] = {
            SubRegion:new("Sump_Tunnel", access, {["Pipeyard"] = true}),
            SubRegion:new("The_Precipice", access, {["The_Exterior"] = true}),
            SubRegion:new("Shore", access, {["Garbage_Wastes"] = true, ["Shaded_Citadel"] = true, ["Subterranean"] = true}),
            SubRegion:new("Submerged", access, {["Submerged_Superstructure"] = true})
        },
        -- Five Pebbles
        ["Five_Pebbles"] = {
            SubRegion:new("Access_Tunnel", access, {["The_Exterior"] = true}),
            SubRegion:new("Memory_Conflux", access, {["The_Exterior"] = true}),
            SubRegion:new("Puppet_Chamber", access)
        }
    }

    local food = {
        ["Mushroom"]        = {{},                  {             "Subterranean"     , "The_Wall"    , "Outskirts", "Industrial_Complex", "Shaded_Citadel_Center", "Chimney_Canopy", "Drainage_System", "Garbage_Wastes", "Sky_Islands", "Farm_Arrays",               "Outer_Expanse",                             "Pipeyard"                     }},
        ["Neuron_Fly"]      = {{},                  {                                                                                                                                                                                                                                                                                             }},
        ["Popcorn_Plant"]   = {{},                  {                                                                                                                                                                                                                                                                                             }},
        ["Blue_Fruit"]      = {{"notspearmaster"},  {"Shoreline", "Subterranean"     , "The_Exterior", "Outskirts", "Industrial_Complex", "Shaded_Citadel"       , "Chimney_Canopy", "Drainage_System", "Garbage_Wastes", "Sky_Islands", "Farm_Arrays", "Metropolis", "Outer_Expanse", "Submerged_Superstructure", "Pipeyard"                     }},
        ["Slime_Mold"]      = {{"notspearmaster"},  {"Shoreline",                      "The_Exterior",                                    "Shaded_Citadel"       ,                                                        "Sky_Islands"                                                                                                           }},
        ["Bubble_Fruit"]    = {{"notspearmaster"},  {                                                                                                                                                                                                                                                                                             }},
        ["Glow_Weed"]       = {{"notspearmaster"},  {                                                                                                                                                                                                                                                                                             }},
        ["Lilypuck"]        = {{"notspearmaster"},  {                                                                                                                                                                                                                                                                                             }},
        ["Dandelion_Peach"] = {{"notspearmaster"},  {                                                                                                                                                                                                                                                                                             }},
        ["Gooieduck"]       = {{"notspearmaster"},  {                                                                                                                                                                                                                                                                                             }},
        ["Batfly"]          = {{"notsaint"},        {"Shoreline", "Subterranean"     , "The_Exterior", "Outskirts", "Industrial_Complex", "Shaded_Citadel"       , "Chimney_Canopy", "Drainage_System", "Garbage_Wastes", "Sky_Islands", "Farm_Arrays", "Metropolis", "Outer_Expanse", "Submerged_Superstructure", "Pipeyard", "Looks_to_the_Moon"}},
        ["Jellyfish"]       = {{"notsaint"},        {                                                                                                                                                                                                                                                                                             }},
        ["Hazer"]           = {{"notsaint"},        {                                                                                                                                                                                                                                                                                             }},
        ["Centiwing"]       = {{"notsaint"},        {                                                                                                                                                                                                                                                                                             }},
        ["Centipede"]       = {{"notsaint"},        {                                                                                                                                                                                                                                                                                             }},
        ["Vulture_Grub"]    = {{"notsaint"},        {                                                                                                                                                                                                                                                                                             }},
        ["Noodlefly"]       = {{"notsaint"},        {                                                                                                                                                                                                                                                                                             }},
        ["Eel"]             = {{"crunch"},          {                                                                                                                                                                                                                                                                                             }},
        ["Snail"]           = {{"crunch"},          {                                                                                                                                                                                                                                                                                             }},
        ["Black_Lizard"]    = {{"crunch"},          {             "Filtration_System",                                                    "Shaded_Citadel_Center",                                                                                                                                                 "Pipeyard"                     }},
        ["Jetfish"]         = {{"crunch"},          {                                                                                                                                                                                                                                                                                             }},
        ["Eggbug"]          = {{"crunch"},          {                                                                                                                                                                                                                                                                                             }},
        ["Yellow_Lizard"]   = {{"crunch"},          {                                                                                                                                                                                                                                                                                             }},
        ["Grapple_Worm"]    = {{"crunch"},          {                                                                                                                                                                                                                                                                                             }},
        ["Cyan_Lizard"]     = {{"crunch"},          {                                                                                                                                                                                                                                                                                             }},
        ["Aquapede"]        = {{"crunch"},          {                                                                                                                                                                                                                                                                                             }},
        ["Green_Lizard"]    = {{"crunch"},          {                                                                                                                                                                                                                                                                                             }},
        ["Blue_Lizard"]     = {{"crunch"},          {                                                                                                                                                                                                                                                                                             }},
        ["Pink_Lizard"]     = {{"crunch"},          {                                                                                                                                                                                                                                                                                             }},
        ["White_Lizard"]    = {{"crunch"},          {                                                                                                                                                                                                                                                                                             }},
        ["Red_Lizard"]      = {{"crunch"},          {                                                                                                                                                                                                                                                                                             }},
        ["Caramel_Lizard"]  = {{"crunch"},          {                                                                                                                                                                                                                                                                                             }},
        ["Spider"]          = {{"crunch"},          {                                                                                                                                                                                                                                                                                             }},
        ["Spitter_Spider"]  = {{"crunch"},          {                                                                                                                                                                                                                                                                                             }},
        ["Splitter_Spider"] = {{"crunch"},          {                                                                                                                                                                                                                                                                                             }},
        ["Vulture"]         = {{"crunch"},          {                                                                                                                                                                                                                                                                                             }},
        ["King_Vulture"]    = {{"crunch"},          {                                                                                                                                                                                                                                                                                             }},
        ["Miros_Vulture"]   = {{"crunch"},          {                                                                                                                                                                                                                                                                                             }},
        ["Lantern_Mouse"]   = {{"crunch"},          {                                                                                                                                                                                                                                                                                             }},
        ["Squidcada"]       = {{"crunch"},          {                                                                                                                                                                                                                                                                                             }},
        ["Dropwig"]         = {{"crunch"},          {                                                                                                                                                                                                                                                                                             }},
        ["Miros_Bird"]      = {{"crunch"},          {                                                                                                                                                                                                                                                                                             }},
        ["Scavenger"]       = {{"crunch"},          {                                                                                                                                                                                                                                                                                             }},
        ["Rot"]             = {{"crunch"},          {                                                                                                                                                                                                                                                                                             }}
    }

    REGIONS = {
        ["Chimney_Canopy"] = Region:new("Chimney_Canopy", gates),
        ["Drainage_System"] = Region:new("Drainage_System", gates),
        ["Garbage_Wastes"] = Region:new("Garbage_Wastes", gates),
        ["Industrial_Complex"] = Region:new("Industrial_Complex", gates),
        ["Farm_Arrays"] = Region:new("Farm_Arrays", gates),
        ["Subterranean"] = Region:new("Subterranean", gates, sub_regions["Subterranean"]),
        ["Sky_Islands"] = Region:new("Sky_Islands", gates),
        ["Five_Pebbles"] = Region:new("Five_Pebbles", gates, sub_regions["Five_Pebbles"]),
        ["The_Exterior"] = Region:new("The_Exterior", gates, sub_regions["The_Exterior"]),
        ["Outskirts"] = Region:new("Outskirts", gates, sub_regions["Outskirts"]),
        ["Shaded_Citadel"] = Region:new("Shaded_Citadel", gates, sub_regions["Shaded_Citadel"]),
        ["Silent_Construct"] = Region:new("Silent_Construct", gates),
        ["Looks_to_the_Moon"] = Region:new("Looks_to_the_Moon", gates),
        ["Metropolis"] = Region:new("Metropolis", gates),
        ["Shoreline"] = Region:new("Shoreline", gates, sub_regions["Shoreline"]),
        ["Outer_Expanse"] = Region:new("Outer_Expanse", gates),
        ["Pipeyard"] = Region:new("Pipeyard", gates),
        ["Submerged_Superstructure"] = Region:new("Submerged_Superstructure", gates)
    }
end

init_regions()