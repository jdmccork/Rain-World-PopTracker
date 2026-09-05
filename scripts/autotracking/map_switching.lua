CURRENT_REGION = nil
CURRENT_CAMPAIGN = nil

SPAWN_NAMING =
{
    ["Chimney_Canopy"] = "Chimney Canopy",
    ["Drainage_System"] = "Drainage System",
    ["Garbage_Wastes"] = "Garbage Wastes",
    ["Industrial_Complex"] = "Industrial Complex",
    ["Farm_Arrays"] = "Farm Arrays",
    ["Subterranean"] = "Subterranean",
    ["Shaded_Citadel"] = "Shaded Citadel",
    ["Sky_Islands"] = "Sky Islands",
    ["Shoreline"] = "Shoreline",
    ["Five_Pebbles"] = "Five Pebbles",
    ["Outskirts"] = "Outskirts",
    ["The_Exterior"] = "The Exterior",
    ["Silent_Construct"] = "Silent Construct",
    ["Looks_to_the_Moon"] = "Looks to the Moon",
    ["Metropolis"] = "Metropolis",
    ["Outer_Expanse"] = "Outer Expanse",
    ["Pipeyard"] = "Pipeyard"
}

LOGIC_REGIONS = 
{
    "Chimney_Canopy",
    "Drainage_System",
    "Garbage_Wastes",
    "Industrial_Complex",
    "Farm_Arrays",
    "Subterranean",
    "Sky_Islands",
    "Five_Pebbles",
    "The_Exterior",
    "Outskirts",
    "Shaded_Citadel",
    "Silent_Construct",
    "Looks_to_the_Moon",
    "Metropolis",
    "Shoreline",
    "Outer_Expanse",
    "Pipeyard",
    "Submerged_Superstructure"
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
    ["monk"] = {"nothunter", "notarti", "notspearmaster", "notsaint", "notriv", "notinv"},
    ["survivor"] = {"nothunter", "notarti", "notspearmaster", "notsaint", "notriv", "notinv"},
    ["hunter"] = {"notarti", "crunch", "notspearmaster", "notsaint", "notriv", "notinv"},
    ["gourmand"] = {"nothunter",  "notarti", "crunch", "notspearmaster", "notsaint", "notriv", "MSC", "notinv"},
    ["arti"] = {"nothunter", "crunch", "notspearmaster", "notsaint", "notriv", "MSC", "notinv"},
    ["riv"] = {"nothunter",  "notarti", "notspearmaster", "notsaint", "MSC", "notinv"},
    ["spearmaster"] = {"nothunter",  "notarti", "crunch", "notsaint", "notriv", "MSC", "notinv"},
    ["saint"] = {"nothunter",  "notarti", "notspearmaster", "notriv", "MSC", "notinv"},
    ["inv"] = {"nothunter",  "notarti", "crunch", "notspearmaster", "notsaint", "notriv", "MSC"},
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
