-- Gates connect between regions. Should these be kept as Gate objects, or should I combine them into OneWay or TwoWay?
GATES = {
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
    Gate:new("The_Exterior", {"Five_Pebbles", "The_Wall"}, "Gate-The_Wall-Five_Pebbles", 1, 1),
    Gate:new("The_Exterior", {"Five_Pebbles", "Underhang"}, "Gate-Underhang-Five_Pebbles", 5, 1),
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
ACCESS = {
    -- Glowing checks
    TwoWay:new("Subway", "Filtration_System", {}, {{"glow-item"}, {"glow-option"}, {"gourmand"}}),
    TwoWay:new("Depth", "Filtration_System", {}, {{"glow-item"}, {"glow-option"}, {"gourmand"}}),
    TwoWay:new("Shaded_Citadel_Center", "Shaded_Citadel_GW", {}, {{"glow-item"}, {"glow-option"}, {"gourmand"}}),
    TwoWay:new("Shaded_Citadel_Center", "Shaded_Citadel_UW", {}, {{"glow-item"}, {"glow-option"}, {"gourmand"}}),
    TwoWay:new("Shaded_Citadel_Center", "Shaded_Citadel_SL", {}, {{"glow-item"}, {"glow-option"}, {"gourmand"}}),
    TwoWay:new("Shaded_Citadel_Center", "Shaded_Citadel_HI", {}, {{"glow-item"}, {"glow-option"}, {"gourmand"}}),

    -- Swimming checks
    TwoWay:new("Sump_Tunnel", "Shore", {{"arti", "aquatic-perk"}, {"notarti"}}), -- Arti can't swim
    TwoWay:new("Shore", "Submerged", {{"subsanity"}}, {{"sub_aquatic", "riv"}, {"sub_aquatic", "aquatic-perk"}, {"sub_all"}}), -- Swim to Submerged
    
    -- Not implemented
    TwoWay:new("The_Wall", "Underhang", {}, {}),
    TwoWay:new("The_Leg", "Underhang", {}, {}),

    OneWay:new("Chasm", "Subway", {}, {}), -- The pit outside the Farm Array gate
    OneWay:new("Subway", "Chasm", {}, {}), -- TODO: Climbing back up the pit outside the Farm Array gate
    OneWay:new("Above_Spawn", "Spawn", {}, {}), -- The spawn hole that Surv/Monk exit
    OneWay:new("Spawn", "Above_Spawn", {{"MSC"}}, {{"arti"}}), -- TODO: Climbing back up the spawn hole that Surv/Monk exit
    OneWay:new("Roots", "Above_Spawn", {}, {}), -- The water pipe outside the gate from Outer Expanse
}

SUB_REGIONS = {
    -- Exterior
    ["The_Wall"] = SubRegion:new("The_Wall", ACCESS, {["Chimney_Canopy"] = true, ["Five_Pebbles"] = true, ["Metropolis"] = true}),
    ["Underhang"] = SubRegion:new("Underhang", ACCESS, {["Five_Pebbles"] = true}),
    ["The_Leg"] = SubRegion:new("The_Leg", ACCESS, {["Shoreline"] = true, ["Shaded_Citadel"] = true}),
    -- Subterranean
    ["Depth"] = SubRegion:new("Depth", ACCESS),
    ["Filtration_System"] = SubRegion:new("Filtration_System", ACCESS, {["Pipeyard"] = true, ["Drainage_System"] = true}),
    ["Subway"] = SubRegion:new("Subway", ACCESS, {["Outer_Expanse"] = true, ["Shoreline"] = true}),
    ["Chasm"] = SubRegion:new("Chasm", ACCESS, {["Farm_Arrays"] = true}),
    -- Shaded_Citadel
    ["Shaded_Citadel_GW"] = SubRegion:new("Shaded_Citadel_GW", ACCESS, {["Garbage_Wastes"] = true}),
    ["Shaded_Citadel_UW"] = SubRegion:new("Shaded_Citadel_UW", ACCESS, {["The_Exterior"] = true}),
    ["Shaded_Citadel_SL"] = SubRegion:new("Shaded_Citadel_SL", ACCESS, {["Shoreline"] = true}),
    ["Shaded_Citadel_HI"] = SubRegion:new("Shaded_Citadel_HI", ACCESS, {["Industrial_Complex"] = true}),
    ["Shaded_Citadel_Center"] = SubRegion:new("Shaded_Citadel_Center", ACCESS),
    -- Outskirts
    ["Roots"] = SubRegion:new("Roots", ACCESS, {["Outer_Expanse"] = true}),
    ["Spawn"] = SubRegion:new("Spawn", ACCESS, {["Industrial_Complex"] = true, ["Farm_Arrays"] = true, ["Drainage_System"] = true}),
    ["Above_Spawn"] = SubRegion:new("Above_Spawn", ACCESS),
    -- Garbage Wastes
    ["Sump_Tunnel"] = SubRegion:new("Sump_Tunnel", ACCESS, {["Pipeyard"] = true}),
    ["The_Precipice"] = SubRegion:new("The_Precipice", ACCESS, {["The_Exterior"] = true}),
    ["Shore"] = SubRegion:new("Shore", ACCESS, {["Garbage_Wastes"] = true, ["Shaded_Citadel"] = true, ["Subterranean"] = true}),
    ["Submerged"] = SubRegion:new("Shore", ACCESS, {["Submerged_Superstructure"] = true})
}

REGIONS = {
    ["Chimney_Canopy"] = Region:new("Chimney_Canopy", GATES),
    ["Drainage_System"] = Region:new("Drainage_System", GATES),
    ["Garbage_Wastes"] = Region:new("Garbage_Wastes", GATES),
    ["Industrial_Complex"] = Region:new("Industrial_Complex", GATES),
    ["Farm_Arrays"] = Region:new("Farm_Arrays", GATES),
    ["Subterranean"] = Region:new("Subterranean", GATES, {SUB_REGIONS["Depth"], SUB_REGIONS["Filtration_System"], SUB_REGIONS["Subway"], SUB_REGIONS["Chasm"]}),
    ["Sky_Islands"] = Region:new("Sky_Islands", GATES),
    ["Five_Pebbles"] = Region:new("Five_Pebbles", GATES),
    ["The_Exterior"] = Region:new("The_Exterior", GATES, {SUB_REGIONS["The_Wall"], SUB_REGIONS["Underhang"], SUB_REGIONS["The_Leg"]}),
    ["Outskirts"] = Region:new("Outskirts", GATES, {SUB_REGIONS["Roots"], SUB_REGIONS["Spawn"], SUB_REGIONS["Above_Spawn"]}),
    ["Shaded_Citadel"] = Region:new("Shaded_Citadel", GATES, {SUB_REGIONS["Shaded_Citadel_Center"], SUB_REGIONS["Shaded_Citadel_HI"], SUB_REGIONS["Shaded_Citadel_GW"], SUB_REGIONS["Shaded_Citadel_UW"], SUB_REGIONS["Shaded_Citadel_SL"]}),
    ["Silent_Construct"] = Region:new("Silent_Construct", GATES),
    ["Looks_to_the_Moon"] = Region:new("Looks_to_the_Moon", GATES),
    ["Metropolis"] = Region:new("Metropolis", GATES),
    ["Shoreline"] = Region:new("Shoreline", GATES, {SUB_REGIONS["Sump_Tunnel"], SUB_REGIONS["The_Precipice"], SUB_REGIONS["Shore"], SUB_REGIONS["Submerged"]}),
    ["Outer_Expanse"] = Region:new("Outer_Expanse", GATES),
    ["Pipeyard"] = Region:new("Pipeyard", GATES),
    ["Submerged_Superstructure"] = Region:new("Submerged_Superstructure", GATES)
}

-- print(dump_table(GATES))
-- print(dump_table(GATES[#GATES]))
-- print(GATES[2]:check_access("Chimney_Canopy"))