CURRENT_REGION = nil
CURRENT_CAMPAIGN = nil

SPAWN_NAMING =
{
    ["Chimney"] = "Chimney Canopy",
    ["Drainage"] = "Drainage System",
    ["Garbage"] = "Garbage Wastes",
    ["Industrial"] = "Industrial Complex",
    ["Farm"] = "Farm Arrays",
    ["Subterranean"] = "Subterranean",
    ["Shaded"] = "Shaded Citadel",
    ["Sky"] = "Sky Islands",
    ["Shoreline"] = "Shoreline",
    ["5P"] = "Five Pebbles",
    ["Outskirts"] = "Outskirts",
    ["Exterior"] = "The Exterior",
    ["Silent"] = "Silent Construct",
    ["Moon"] = "Looks to the Moon",
    ["Metro"] = "Metropolis",
    ["Waterfront"] = "Waterfront Facility",
    ["Outer"] = "Outer Expanse",
    ["Rot"] = "The Rot",
    ["Pipeyard"] = "Pipeyard"
}


CAMPAIGN_NAMING =
{
    [0] = "Monk",
    [1] = "Survivor",
    [2] = "Hunter",
    [3] = "Gourmand",
    [4] = "Artificer",
    [5] = "Rivulet",
    [6] = "Spearmaster",
    [7] = "Saint",
    [8] = "Thanks, Andrew",
    [9] = "Watcher"
}

CAMPAIGN_ARCHIPELAGO =
{
    ["Yellow"] = 0,
    ["White"] = 1,
    ["Red"] = 2,
    ["Gourmand"] = 3,
    ["Artificer"] = 4,
    ["Rivulet"] = 5,
    ["Spear"] = 6,
    ["Saint"] = 7,
    ["Inv"] = 8,
    ["Watcher"] = 9
}

CAMPAIGN_NAMES = 
{
    [0] = "monk",
    [1] = "survivor",
    [2] = "hunter",
    [3] = "gourmand",
    [4] = "arti",
    [5] = "riv",
    [6] = "spearmaster",
    [7] = "saint",
    [8] = "inv"
}

CAMPAIGN_NUMBERS = 
{
    ["monk"] = 0,
    ["survivor"] = 1,
    ["hunter"] = 2,
    ["gourmand"] = 3,
    ["arti"] = 4,
    ["riv"] = 5,
    ["spearmaster"] = 6,
    ["saint"] = 7,
    ["inv"] = 8,
    ["watcher"] = 9
}

SLUGCAT_CODES = 
{
    ["monk"] = {"nothunter", "notarti", "mouth", "notvegan", "notriv", "notinv"},
    ["survivor"] = {"nothunter", "notarti", "mouth", "notvegan", "notriv", "notinv"},
    ["hunter"] = {"notarti", "crunch", "mouth", "notvegan", "notriv", "notinv"},
    ["gourmand"] = {"nothunter",  "notarti", "crunch", "mouth", "notvegan", "notriv", "MSC", "notinv"},
    ["arti"] = {"nothunter", "crunch", "mouth", "notvegan", "notriv", {"WaterMap", 1}, {"Gate_UpperMoon-WaterMap", 1}, {"Gate_LowerMoon-WaterMap", 1}, "MSC", "notinv"},
    ["riv"] = {"nothunter",  "notarti", "mouth", "notvegan", {"Pebbsi", 1}, {"Gate_Wall-Pebbsi", 1}, {"Gate_Underhang-Pebbsi", 1}, "MSC", "notinv"},
    ["spearmaster"] = {"nothunter",  "notarti", "crunch", "notvegan", "notriv", {"WaterMap", 1}, {"Gate_UpperMoon-WaterMap", 1}, {"Gate_LowerMoon-WaterMap", 1}, "MSC", "notinv"},
    ["saint"] = {"nothunter",  "notarti", "mouth", "notriv", {"Gate_WaterMap-Pebbs", 1}, {"Drainage", 1}, {"Castle", 1}, "MSC", "notinv"},
    ["inv"] = {"nothunter",  "notarti", "crunch", "mouth", "notvegan", "notriv", "MSC"},
}

SAINT_TABLE =
{
    ["Outskirts"] = "Suburban Drifts",
    ["Industrial Complex"] = "Icy Monument",
    ["Chimney Canopy"] = "Solitary Towers",
    ["Farm Arrays"] = "Desolate Fields",
    ["Subterranean"] = "Primordial Underground",
    ["Garbage Wastes"] = "Glacial Wasteland",
    ["Pipeyard"] = "Barren Conduits",
    ["Sky Islands"] = "Windswept Spires",
    ["Shoreline"] = "Frigid Coast"
}

INV_TABLE = 
{
    ["Outskirts"] = "i forgot to make this map, sorry",
    ["Drainage System"] = "Painage System",
    ["Garbage Wastes"] = "Nachos Will Never Be the Same",
    ["Pipeyard"] = "TOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOBS",
    ["The Exterior"] = "Tower of Gains",
    ["Five Pebbles"] = "Pebbsi"
}

TABS_MAPPING =
{
    ["cc"] = "Chimney Canopy",
    ["ds"] = "Drainage System",
    ["gw"] = "Garbage Wastes",
    ["hi"] = "Industrial Complex",
    ["lf"] = "Farm Arrays",
    ["sb"] = "Subterranean",
    ["sh"] = "Shaded Citadel",
    ["si"] = "Sky Islands",
    ["sl"] = "Shoreline",
    ["ss"] = "Five Pebbles",
    ["su"] = "Outskirts",
    ["uw"] = "The Exterior",
    ["cl"] = "Silent Construct",
    ["dm"] = "Looks to the Moon",
    ["hr"] = "Rubicon",
    ["lc"] = "Metropolis",
    ["lm"] = "Waterfront Facility",
    ["ms"] = "Submerged Superstructure",
    ["oe"] = "Outer Expanse",
    ["rm"] = "The Rot",
    ["ug"] = "Undergrowth",
    ["vs"] = "Pipeyard",
    ["wara"] = "Shattered_Terrace",
    ["warb"] = "Salination",
    ["warc"] = "Fetid_Glen",
    ["ward"] = "Cold_Storage",
    ["ware"] = "Heat_Ducts",
    ["warf"] = "Aether_Ridge",
    ["warg"] = "Surface",
    ["waua"] = "Ancient_Urban",
    ["wbla"] = "Badlands",
    ["wdsr"] = "Decaying_Tunnels",
    ["wgwr"] = "Infested_Wastes",
    ["whir"] = "Corrupted_Factories",
    ["wora"] = "Outer_Rim",
    ["wpta"] = "Signal_Spires",
    ["wrfa"] = "Coral_Caves",
    ["wrfb"] = "Turbulent_Pump",
    ["wrra"] = "Rusted_Wrecks",
    ["wrsa"] = "Daemon",
    ["wska"] = "Torrential_Railways",
    ["wskb"] = "Sunlit_Port",
    ["wskc"] = "Stormy_Coast",
    ["wskd"] = "Shrouded_Coast",
    ["wssr"] = "Unfortunate_Evolution",
    ["wsur"] = "Crumbling_Fringes",
    ["wtda"] = "Torrid_Desert",
    ["wtdb"] = "Desolate_Tract",
    ["wvwa"] = "Verdant_Waterways"
}
