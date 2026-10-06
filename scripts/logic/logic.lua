--debugging info
gatelogicdebug = false
regiondebug = false
scugdebug = false
logicdebug = false

--defaults
DEBUG_MODE = true
DEFAULT_SCUG = "monk"
SHELTER_SANITY = true
FOOD_QUEST = true
SUB_SANITY = 2
DEFAULT_MSC = true
DEFAULT_DEV_CHECKS = true

function gateprint(...)
    if gatelogicdebug then
        print(...)
    end
end
function regionprint(...)
    if regiondebug then
        print(...)
    end
end
function scugprint(...)
    if scugdebug then
        print(...)
    end
end
function logicprint(...)
    if logicdebug then
        print(...)
    end
end

--for manually adjusting dlc settings if tracker isn't connected to AP
dlcplaceholder = Tracker:FindObjectForCode("MSC").Active
dlcscug = false
function dlcselect()
    if Tracker:FindObjectForCode("scug").CurrentStage > 2 then
        Tracker:FindObjectForCode("vanilla").Active = false
        Tracker:FindObjectForCode("MSC").Active = true
        dlcscug = true
        return
    elseif dlcscug == true then
        Tracker:FindObjectForCode("MSC").Active = dlcplaceholder
        Tracker:FindObjectForCode("vanilla").Active = not dlcplaceholder
        dlcscug = false
    end
    if Tracker:FindObjectForCode("MSC").Active and (Tracker:FindObjectForCode("MSC").Active ~= dlcplaceholder) then
        Tracker:FindObjectForCode("vanilla").Active = false
        dlcplaceholder = Tracker:FindObjectForCode("MSC").Active
    elseif Tracker:FindObjectForCode("MSC").Active == false and (Tracker:FindObjectForCode("MSC").Active ~= dlcplaceholder) then
        Tracker:FindObjectForCode("vanilla").Active = true
        dlcplaceholder = Tracker:FindObjectForCode("MSC").Active
    end
end

ScriptHost:AddWatchForCode("DLC Change", "MSC", dlcselect)


character = Tracker:FindObjectForCode("scug").CurrentStage
--for updating the Slugcat campaign settings
function characterselect()
    activecampaign = CAMPAIGN_NAMES[Tracker:FindObjectForCode("scug").CurrentStage]
    if character ~= Tracker:FindObjectForCode("scug").CurrentStage then
        scugprint("Checking Campaign")
        
        if (Tracker:FindObjectForCode(CAMPAIGN_NAMES[Tracker:FindObjectForCode("scug").CurrentStage]).Active == false) then
            scugplaceholder = character
            
            scugprint(string.format("%s is NOT active, but it should be",CAMPAIGN_NAMES[Tracker:FindObjectForCode("scug").CurrentStage]))
            scugprint(string.format("%s was the previous character,deactivating",CAMPAIGN_NAMES[character]))
            
            Tracker:FindObjectForCode(CAMPAIGN_NAMES[character]).Active = false
            
            scugprint(string.format("%s should be deactivated, activating %s",CAMPAIGN_NAMES[scugplaceholder],CAMPAIGN_NAMES[Tracker:FindObjectForCode("scug").CurrentStage]))
            
            Tracker:FindObjectForCode(CAMPAIGN_NAMES[Tracker:FindObjectForCode("scug").CurrentStage]).Active = true
            
            scugprint(string.format("%s has been activated", CAMPAIGN_NAMES[Tracker:FindObjectForCode("scug").CurrentStage]))
            
            character = Tracker:FindObjectForCode("scug").CurrentStage
            activecampaign = CAMPAIGN_NAMES[Tracker:FindObjectForCode("scug").CurrentStage]
            
            scugprint(string.format("%s is the new placeholder",CAMPAIGN_NAMES[character]))
        else
            scugprint(string.format("%s is the current stage, Active state: %s",CAMPAIGN_NAMES[Tracker:FindObjectForCode("scug").CurrentStage],Tracker:FindObjectForCode(CAMPAIGN_NAMES[Tracker:FindObjectForCode("scug").CurrentStage]).Active))
            
            character = Tracker:FindObjectForCode("scug").CurrentStage
            activecampaign = CAMPAIGN_NAMES[Tracker:FindObjectForCode("scug").CurrentStage]
        end
    else
        for names, code in pairs(CAMPAIGN_NAMES) do
            if Tracker:FindObjectForCode(code).Active and (code ~= activecampaign) then
                scugprint(string.format("There are two active campaigns! %s needs to be overwritten with %s",activecampaign,code))
                Tracker:FindObjectForCode(activecampaign).Active = false
                scugprint(string.format("Turned off %s, setting campaign to stage %s", activecampaign,names))
                character = names
                activecampaign = code
                Tracker:FindObjectForCode("scug").CurrentStage = names
                scugprint(string.format("scug stage set to %s", names))
            end
        end
    end
    
    reset_slugcat_codes()
    for i, code in ipairs(SLUGCAT_CODES[activecampaign]) do
        if type(code) == "string" then
            Tracker:FindObjectForCode(code).Active = true
        else
            Tracker:FindObjectForCode(code[1]).CurrentStage = code[2]
        end
    end

    dlcselect()
    
end

ScriptHost:AddWatchForCode("Scug Change", "scug", characterselect)
ScriptHost:AddWatchForCode("campaign Change", "campaign", characterselect)

function reset_slugcat_codes()
    for _, code in ipairs(SLUGCAT_RESET_CODES) do
        Tracker:FindObjectForCode(code).Active = false
    end
end

--for determining how many wanderer pips you should have access to
function available_regions(n)
    if Tracker:ProviderCountForCode("region") >= tonumber(n) then
        return AccessibilityLevel.Normal
    end
    if Tracker:ProviderCountForCode("region-ool") >= tonumber(n) then
        return AccessibilityLevel.SequenceBreak
    end
    return AccessibilityLevel.None
end

function nomadaccess()
    return available_regions(Tracker:FindObjectForCode("nomad_difficulty").AcquiredCount)
end

function has_access(region)
    return Tracker:FindObjectForCode(string.format("%s", region)).CurrentStage > 1
end

function monkaccess()
    local fruit = getFruitAccess()

    local counter = 0
    for _, _ in pairs(fruit) do
        counter = counter + 1
    end

    return counter >= tonumber(Tracker:FindObjectForCode("monk_difficulty").AcquiredCount)
end

function hunteraccess()
    local lizards = getLizardAccess()
    local meat = getMeatAccess()

    local counter = 0
    for _, _ in pairs(lizards) do
        counter = counter + 1
    end
    for _, _ in pairs(meat) do
        counter = counter + 1
    end

    return counter >= tonumber(Tracker:FindObjectForCode("hunter_difficulty").AcquiredCount)
end

function getFood(food)
    local fruit = getFruitAccess()
    local meat = getMeatAccess()

    --Specifically for mushroom, the only edible food quest item that doesn't give pips
    if food == "mushroom" then
        return math.max(
            Tracker:FindObjectForCode("Outskirts_Center").CurrentStage,
            Tracker:FindObjectForCode("Farm_Arrays").CurrentStage,
            Tracker:FindObjectForCode("Outer_Expanse").CurrentStage,
            Tracker:FindObjectForCode("Drainage_System").CurrentStage,
            Tracker:FindObjectForCode("Garbage_Wastes").CurrentStage,
            Tracker:FindObjectForCode("Shaded_Citadel_Center").CurrentStage,
            Tracker:FindObjectForCode("Subterranean").CurrentStage,
            Tracker:FindObjectForCode("Chimney_Canopy").CurrentStage,
            Tracker:FindObjectForCode("The_Exterior").CurrentStage,
            Tracker:FindObjectForCode("Industrial_Complex").CurrentStage,
            Tracker:FindObjectForCode("Sky_Islands").CurrentStage,
            Tracker:FindObjectForCode("Pipeyard").CurrentStage
        )
    end
    return fruit[food] or meat[food]
end

function getFruitAccess()
    local food = {}
    if has_access("Outskirts") then
        if Tracker:FindObjectForCode("notspearmaster").Active then
            food["bluefruit"] = true
        end
        if Tracker:FindObjectForCode("monk").Active or Tracker:FindObjectForCode("survivor").Active or Tracker:FindObjectForCode("MSC").Active then
            food["popcorn"] = true
        end
    end
    if has_access("Industrial_Complex") then
        if Tracker:FindObjectForCode("notspearmaster").Active then
            food["bluefruit"] = true
            food["bubblefruit"] = true
        end
        food["popcorn"] = true
    end
    if has_access("Chimney_Canopy") then
        if Tracker:FindObjectForCode("notspearmaster").Active then
            food["bluefruit"] = true
        end
    end
    if has_access("Farm_Arrays") then
        food["popcorn"] = true
        if Tracker:FindObjectForCode("notspearmaster").Active then
            food["bluefruit"] = true
            if Tracker:FindObjectForCode("MSC").Active then
                food["gooieduck"] = true
            end
        end
    end
    if has_access("Subterranean") then
        food["popcorn"] = true
        if Tracker:FindObjectForCode("notspearmaster").Active then
            food["bluefruit"] = true
            food["bubblefruit"] = true
            if Tracker:FindObjectForCode("MSC").Active then
                food["gooieduck"] = true
            end
        end
    end
    if has_access("Outer_Expanse") then
        food["bluefruit"] = true
        food["gooieduck"] = true
    end
    if has_access("Drainage_System") then
        if Tracker:FindObjectForCode("notspearmaster").Active then
            food["bluefruit"] = true
            food["bubblefruit"] = true
            if Tracker:FindObjectForCode("MSC").Active then
                food["lilypuck"] = true
            end
        end
    end
    if has_access("Garbage_Wastes") then
        if Tracker:FindObjectForCode("notspearmaster").Active then
            food["bluefruit"] = true
            food["bubblefruit"] = true
        end
        food["popcorn"] = true
    end
    if has_access("Shaded_Citadel_Center") then
        if Tracker:FindObjectForCode("notspearmaster").Active then
            food["bluefruit"] = true
            food["slimemold"] = true
            if Tracker:FindObjectForCode("saint").Active then
                food["popcorn"] = true
            else
                food["bubblefruit"] = true
            end
            if Tracker:FindObjectForCode("MSC").Active and (Tracker:FindObjectForCode("monk").Active or Tracker:FindObjectForCode("survivor").Active or Tracker:FindObjectForCode("riv").Active) then
                food["lilypuck"] = true
            end
        end
    end
    if has_access("The_Exterior") then
        if Tracker:FindObjectForCode("notspearmaster").Active then
            food["bluefruit"] = true
            food["slimemold"] = true
        end
    end
    if has_access("Five_Pebbles") then
        food["neuronfly"] = true
        food["popcorn"] = true
    end
    if has_access("Pipeyard") then
        if Tracker:FindObjectForCode("notspearmaster").Active then
            food["bluefruit"] = true
            food["bubblefruit"] = true
            food["lilypuck"] = true
        end
        food["popcorn"] = true
    end
    if has_access("Sky_Islands") then
        if Tracker:FindObjectForCode("notspearmaster").Active then
            food["bluefruit"] = true
            if Tracker:FindObjectForCode("MSC").Active then
                food["dandelionpeach"] = true
            end
        end
        food["popcorn"] = true
    end
    if has_access("Shoreline") then
        if not Tracker:FindObjectForCode("hunter").Active then
            food["neuronfly"] = true
        end
        if Tracker:FindObjectForCode("notspearmaster").Active then
            food["bluefruit"] = true
            food["bubblefruit"] = true
            if Tracker:FindObjectForCode("MSC").Active and not Tracker:FindObjectForCode("arti").Active then
                food["glowweed"] = true
            end
        end
        if Tracker:FindObjectForCode("saint").Active then
            food["slimemold"] = true
        end
        food["popcorn"] = true
    end
    if has_access("Metropolis") then
        food["bluefruit"] = true
        food["popcorn"] = true
        food["neuronfly"] = true
    end
    if has_access("Submerged_Superstructure") then
        food["bluefruit"] = true
        food["bubblefruit"] = true
        food["glowweed"] = true
    end
    if has_access("Looks_to_the_Moon") then
        food["neuronfly"] = true
    end
    if has_access("Rubicon") then
        food["bluefruit"] = true
        food["popcorn"] = true
        food["dandelionpeach"] = true
    end

    return food
end

--- To be implemented for use with dragon slayer. Use getMeatAccess for now.
function getLizardAccess()
    return {}
end
    
function getMeatAccess()
    local meat = {}
    if has_access("Outskirts") then
        meat["batfly"] = true
        meat["noodlefly"] = true
        meat["centipede"] = true
        if Tracker:FindObjectForCode("MSC").Active == false then
            if Tracker:FindObjectForCode("monk").Active or Tracker:FindObjectForCode("hunter").Active then
                meat["hazer"] = true
            end
            if Tracker:FindObjectForCode("hunter").Active then
                meat["bluelizard"] = true
                meat["whitelizard"] = true
                meat["vulture"] = true
                meat["kingvulture"] = true
                meat["dropwig"] = true
            end
        elseif Tracker:FindObjectForCode("MSC").Active then
            if Tracker:FindObjectForCode("monk").Active then
                meat["hazer"] = true
            end
            if Tracker:FindObjectForCode("crunch").Active then
                meat["greenlizard"] = true
                meat["pinklizard"] = true
                meat["redlizard"] = true
                meat["squidcada"] = true
                meat["kingvulture"] = true
                meat["dropwig"] = true
                meat["scavenger"] = true
            end
            if Tracker:FindObjectForCode("hunter").Active or Tracker:FindObjectForCode("arti").Active or Tracker:FindObjectForCode("spearmaster").Active then
                meat["bluelizard"] = true
                meat["whitelizard"] = true
                meat["vulture"] = true
                meat["hazer"] = true
            end
            if Tracker:FindObjectForCode("spearmaster").Active then
                meat["monsterkelp"] = true
            end
        end
    end
    if has_access("Industrial_Complex") then
        meat["batfly"] = true
        meat["centipede"] = true
        meat["hazer"] = true
        meat["vulturegrub"] = true
        if Tracker:FindObjectForCode("MSC").Active == false then 
            if Tracker:FindObjectForCode("monk").Active or Tracker:FindObjectForCode("hunter").Active then
                meat["eggbugegg"] = true
            end
            if Tracker:FindObjectForCode("hunter").Active then
                meat["scavenger"] = true
                meat["greenlizard"] = true
                meat["pinklizard"] = true
                meat["bluelizard"] = true
                meat["whitelizard"] = true
                meat["cyanlizard"] = true
                meat["dropwig"] = true
                meat["eggbug"] = true
                meat["vulture"] = true
                meat["kingvulture"] = true
            end
        elseif Tracker:FindObjectForCode("MSC").Active then
            if Tracker:FindObjectForCode("monk").Active or Tracker:FindObjectForCode("hunter").Active or Tracker:FindObjectForCode("arti").Active or Tracker:FindObjectForCode("riv").Active then
                meat["eggbugegg"] = true
            end
            if Tracker:FindObjectForCode("crunch").Active then
                meat["scavenger"] = true
                meat["whitelizard"] = true
                meat["vulture"] = true
                meat["greenlizard"] = true
                meat["pinklizard"] = true
                meat["redlizard"] = true
                meat["bluelizard"] = true
                meat["cyanlizard"] = true
                meat["kingvulture"] = true
            end
            if Tracker:FindObjectForCode("hunter").Active or Tracker:FindObjectForCode("gourmand").Active then
                meat["caramellizard"] = true
            end
            if Tracker:FindObjectForCode("hunter").Active or Tracker:FindObjectForCode("arti").Active or Tracker:FindObjectForCode("spearmaster").Active then
                meat["dropwig"] = true
                meat["eggbug"] = true
            end
            if Tracker:FindObjectForCode("gourmand").Active then
                meat["snail"] = true
            end
            if Tracker:FindObjectForCode("spearmaster").Active then
                meat["poleplant"] = true
            end
        end
        if Tracker:FindObjectForCode("inv").Active then
            meat["trainlizard"] = true
        end
    end
    if has_access("Chimney_Canopy") then
        meat["vulturegrub"] = true
        meat["batfly"] = true
        if Tracker:FindObjectForCode("MSC").Active == false then
            if Tracker:FindObjectForCode("monk").Active or Tracker:FindObjectForCode("hunter").Active then
                meat["eggbugegg"] = true
            end
            if Tracker:FindObjectForCode("hunter").Active then
                meat["scavenger"] = true
                meat["pinklizard"] = true
                meat["bluelizard"] = true
                meat["whitelizard"] = true
                meat["vulture"] = true
                meat["grappleworm"] = true
                meat["cyanlizard"] = true
                meat["kingvulture"] = true
                meat["dropwig"] = true
                meat["spider"] = true
                meat["spitterspider"] = true
                meat["noodlefly"] = true
                meat["eggbug"] = true
            end
        elseif Tracker:FindObjectForCode("MSC").Active then
            if Tracker:FindObjectForCode("monk").Active or Tracker:FindObjectForCode("hunter").Active or Tracker:FindObjectForCode("arti").Active or Tracker:FindObjectForCode("riv").Active then
                meat["eggbugegg"] = true
            end
            if Tracker:FindObjectForCode("crunch").Active then
                meat["scavenger"] = true
                meat["whitelizard"] = true
                meat["vulture"] = true
                meat["pinklizard"] = true
                meat["bluelizard"] = true
                meat["grappleworm"] = true
                meat["kingvulture"] = true
                meat["dropwig"] = true
                meat["eellizard"] = true
            end
            if Tracker:FindObjectForCode("hunter").Active or Tracker:FindObjectForCode("gourmand").Active then
                meat["caramellizard"] = true
            end
            if Tracker:FindObjectForCode("hunter").Active or Tracker:FindObjectForCode("arti").Active or Tracker:FindObjectForCode("spearmaster").Active then
                meat["spider"] =  true
                meat["elitescav"] = true
                meat["noodlefly"] = true
                meat["cyanlizard"] = true
            end
            if Tracker:FindObjectForCode("arti").Active or Tracker:FindObjectForCode("spearmaster").Active then
                meat["spitterspider"] = true
            end
            if Tracker:FindObjectForCode("spearmaster").Active then
                meat["poleplant"] = true
            end
        end
    end
    if has_access("Farm_Arrays") then
        meat["centipede"] = true
        meat["vulturegrub"] = true
        meat["noodlefly"] = true
        meat["batfly"] = true
        meat["hazer"] = true
        if Tracker:FindObjectForCode("notspearmaster").Active then
            meat["eggbugegg"] = true
        end
        if Tracker:FindObjectForCode("crunch").Active then
            meat["scavenger"] = true
            meat["caramellizard"] = true
            meat["vulture"] = true
            meat["kingvulture"] = true
            meat["bluelizard"] = true
            meat["greenlizard"] = true
            meat["squidcada"] = true
            meat["eggbug"] = true
        end
        if Tracker:FindObjectForCode("gourmand").Active then
            meat["yellowlizard"] = true
            meat["redlizard"] = true
        end
        if Tracker:FindObjectForCode("hunter").Active or Tracker:FindObjectForCode("arti").Active or Tracker:FindObjectForCode("spearmaster").Active then
            meat["spider"] = true
            meat["spitterspider"] = true
        end
        if Tracker:FindObjectForCode("arti").Active or Tracker:FindObjectForCode("spearmaster").Active then
            meat["centiwing"] = true
        end
        if Tracker:FindObjectForCode("spearmaster").Active then
            meat["poleplant"] = true
        end
    end
    if has_access("Subterranean") then
        meat["centipede"] = true
        meat["batfly"] = true
        if Tracker:FindObjectForCode("MSC").Active == false then
            if Tracker:FindObjectForCode("hunter").Active then
                meat["blacklizard"] = true
                meat["scavenger"] = true
                meat["spider"] = true
                meat["salamander"] = true
                meat["bluelizard"] = true
                meat["greenlizard"] = true
                meat["dropwig"] = true
                meat["spitterspider"] = true
                meat["cyanlizard"] = true
                meat["jetfish"] = true
                meat["eggbug"] = true
                meat["eggbugegg"] = true
            end
        elseif Tracker:FindObjectForCode("MSC").Active then
            if Tracker:FindObjectForCode("survivor").Active or Tracker:FindObjectForCode("crunch").Active then
                meat["noodlefly"] = true
            end
            if Tracker:FindObjectForCode("crunch").Active then
                meat["blacklizard"] = true
                meat["jetfish"] = true
                meat["scavenger"] = true
                meat["spider"] = true
                meat["caramellizard"] = true
                meat["bluelizard"] = true
                meat["dropwig"] = true
                meat["spitterspider"] = true
                meat["salamander"] = true
                meat["cyanlizard"] = true
                meat["splitterspider"] = true
                meat["mirosbird"] = true
            end
            if Tracker:FindObjectForCode("hunter").Active or Tracker:FindObjectForCode("arti").Active or Tracker:FindObjectForCode("spearmaster").Active then
                meat["eggbug"] = true
            end
            if Tracker:FindObjectForCode("hunter").Active or Tracker:FindObjectForCode("arti").Active then
                meat["eggbugegg"] = true
            end
            if Tracker:FindObjectForCode("spearmaster").Active then
                meat["poleplant"] = true
            end
        end
    end
    if has_access("Outer_Expanse") then
        meat["centipede"] = true
        meat["batfly"] = true
        if Tracker:FindObjectForCode("gourmand").Active then
            meat["bluelizard"] = true
            meat["caramellizard"] = true
            meat["dropwig"] = true
            meat["scavenger"] = true
            meat["yeek"] = true
            meat["whitelizard"] = true
            meat["vulture"] = true
        end
    end
    if has_access("Drainage_System") then
        meat["hazer"] = true
        meat["batfly"] = true
        if Tracker:FindObjectForCode("MSC").Active == false then
            if Tracker:FindObjectForCode("hunter").Active then
                meat["snail"] = true
                meat["scavenger"] = true
                meat["salamander"] = true
                meat["greenlizard"] = true
                meat["centipede"] = true
                meat["dropwig"] = true
                meat["cyanlizard"] = true
            end
        elseif Tracker:FindObjectForCode("MSC").Active then
            if Tracker:FindObjectForCode("crunch").Active then
                meat["snail"] = true
                meat["scavenger"] = true
                meat["salamander"] = true
                meat["greenlizard"] = true
                if Tracker:FindObjectForCode("gourmand").Active then
                    meat["pinklizard"] = true
                end
                if Tracker:FindObjectForCode("hunter").Active or Tracker:FindObjectForCode("arti").Active or Tracker:FindObjectForCode("spearmaster").Active then
                    meat["centipede"] = true
                    meat["dropwig"] = true
                    meat["cyanlizard"] = true
                    if Tracker:FindObjectForCode("spearmaster").Active then
                        meat["poleplant"] = true
                    end
                end
            end
        end
    end
    if has_access("Garbage_Wastes") then
        meat["centipede"] = true
        meat["batfly"] = true
        meat["vulturegrub"] = true
        meat["hazer"] = true
        if Tracker:FindObjectForCode("MSC").Active == false then
            if Tracker:FindObjectForCode("hunter").Active then
                meat["scavenger"] = true
                meat["snail"] = true
                meat["squidcada"] = true
                meat["vulture"] = true
                meat["greenlizard"] = true
                meat["pinklizard"] = true
                meat["cyanlizard"] = true
                meat["dropwig"] = true
                meat["rotcyst"] = true
                meat["kingvulture"] = true
                meat["eggbugegg"] = true
                meat["eggbug"] = true
            end
        elseif Tracker:FindObjectForCode("MSC").Active then
            if Tracker:FindObjectForCode("crunch").Active then
                meat["scavenger"] = true
                meat["vulture"] = true
                meat["snail"] = true
                meat["squidcada"] = true
                meat["greenlizard"] = true
                if Tracker:FindObjectForCode("hunter").Active or Tracker:FindObjectForCode("gourmand").Active then
                    meat["pinklizard"] = true
                    meat["rotcyst"] = true
                    meat["caramellizard"] = true
                    if Tracker:FindObjectForCode("gourmand").Active then
                        meat["whitelizard"] = true
                    end
                end
                if Tracker:FindObjectForCode("hunter").Active or Tracker:FindObjectForCode("arti").Active or Tracker:FindObjectForCode("spearmaster").Active then
                    if Tracker:FindObjectForCode("notspearmaster").Active then
                        meat["eggbugegg"] = true
                    end
                    meat["eggbug"] = true
                    meat["cyanlizard"] = true
                    meat["rotcyst"] = true
                    meat["dropwig"] = true
                    meat["kingvulture"] = true
                    if Tracker:FindObjectForCode("arti").Active or Tracker:FindObjectForCode("spearmaster").Active then
                        meat["bluelizard"] = true
                        meat["redlizard"] = true
                        meat["spider"] = true
                        meat["spitterspider"] = true
                        if Tracker:FindObjectForCode("spearmaster").Active then
                            meat["poleplant"] = true
                            meat["rotcyst"] = true
                            meat["elitescav"] = true
                        end
                    end
                end
            end
        end
    end
    if has_access("Shaded_Citadel_Center") then
        meat["batfly"] = true
        if Tracker:FindObjectForCode("MSC").Active == false then
            if Tracker:FindObjectForCode("hunter").Active then
                meat["scavenger"] = true
                meat["blacklizard"] = true
                meat["lanternmouse"] = true
                meat["spider"] = true
                meat["dropwig"] = true
                meat["spitterspider"] = true
                meat["eggbug"] = true
                meat["eggbugegg"] = true
                meat["centipede"] = true
            end
        elseif Tracker:FindObjectForCode("MSC").Active then
            if Tracker:FindObjectForCode("notspearmaster").Active then
                meat["eggbugegg"] = true
            end
            if Tracker:FindObjectForCode("crunch").Active then
                meat["scavenger"] = true
                meat["blacklizard"] = true
                meat["eggbug"] = true
                meat["lanternmouse"] = true
                meat["spider"] = true
                meat["centipede"] = true
                meat["mirosbird"] = true
                if Tracker:FindObjectForCode("hunter").Active or Tracker:FindObjectForCode("arti").Active or Tracker:FindObjectForCode("spearmaster").Active then
                    meat["spitterspider"] = true
                    meat["dropwig"] = true
                    if Tracker:FindObjectForCode("spearmaster").Active then
                        meat["monsterkelp"] = true
                        meat["mirosvulture"] = true
                    end
                    if Tracker:FindObjectForCode("arti").Active then
                        meat["mirosvulture"] = true
                    end
                elseif Tracker:FindObjectForCode("gourmand").Active then
                    meat["pinklizard"] = true
                end
            end
        end
    end
    if has_access("The_Exterior") then
        meat["batfly"] = true
        if Tracker:FindObjectForCode("MSC").Active == false then
            if Tracker:FindObjectForCode("hunter").Active then
                meat["grappleworm"] = true
                meat["whitelizard"] = true
                meat["yellowlizard"] = true
                meat["rotcyst"] = true
                meat["bluelizard"] = true
                meat["cyanlizard"] = true
                meat["spitterspider"] = true
                meat["dropwig"] = true
                meat["kingvulture"] = true
            end
        elseif Tracker:FindObjectForCode("MSC").Active then
            if Tracker:FindObjectForCode("crunch").Active then
                meat["grappleworm"] = true
                meat["whitelizard"] = true
                meat["yellowlizard"] = true
                meat["bluelizard"] = true
                meat["dropwig"] = true
                if Tracker:FindObjectForCode("gourmand").Active or Tracker:FindObjectForCode("hunter").Active or Tracker:FindObjectForCode("arti").Active then
                    meat["rotcyst"] = true
                end
                if Tracker:FindObjectForCode("hunter").Active or Tracker:FindObjectForCode("arti").Active or Tracker:FindObjectForCode("spearmaster").Active then
                    meat["cyanlizard"] = true
                    meat["spider"] = true
                    meat["spitterspider"] = true
                    meat["kingvulture"] = true
                    if Tracker:FindObjectForCode("arti").Active or Tracker:FindObjectForCode("spearmaster").Active then
                        meat["scavenger"] = true
                        meat["mirosvulture"] = true
                        if Tracker:FindObjectForCode("spearmaster").Active then
                            meat["poleplant"] = true
                            meat["vulture"] = true
                        end
                    end
                end
            end
        end
    end
    if has_access("Five_Pebbles") then
        if Tracker:FindObjectForCode("crunch").Active then
            if Tracker:FindObjectForCode("spearmaster").Active then
                meat["inspector"] = true
            else
                meat["rotcyst"] = true
            end
        end
    end
    if has_access("Pipeyard") then
        meat["batfly"] = true
        meat["centipede"] = true
        if Tracker:FindObjectForCode("notriv").Active then
            if Tracker:FindObjectForCode("notspearmaster").Active then
                meat["eggbugegg"] = true
            end
            if Tracker:FindObjectForCode("crunch").Active then
                meat["vulture"] = true
                meat["scavenger"] = true
                meat["blacklizard"] = true
                meat["cyanlizard"] = true
                meat["salamander"] = true
                meat["dropwig"] = true
                meat["eggbug"] = true
                meat["jetfish"] = true
                meat["squidcada"] = true
                meat["snail"] = true
                if Tracker:FindObjectForCode("gourmand").Active then
                    meat["pinklizard"] = true
                    meat["bluelizard"] = true
                    meat["eellizard"] = true
                else
                    meat["kingvulture"] = true
                    if Tracker:FindObjectForCode("spearmaster").Active then
                        meat["monsterkelp"] = true
                        meat["poleplant"] = true
                    end
                end
            end
        end
    end
    if has_access("Sky_Islands") then
        if Tracker:FindObjectForCode("notriv").Active then
            meat["noodlefly"] = true
        end
        meat["batfly"] = true
        meat["centiwing"] = true
        if Tracker:FindObjectForCode("notspearmaster").Active then
            meat["eggbugegg"] = true
        end
        if Tracker:FindObjectForCode("MSC").Active == false then
            if Tracker:FindObjectForCode("hunter").Active then
                meat["squidcada"] = true
                meat["scavenger"] = true
                meat["yellowlizard"] = true
                meat["eggbug"] = true
                meat["vulture"] = true
                meat["bluelizard"] = true
                meat["whitelizard"] = true
                meat["pinklizard"] = true
                meat["cyanlizard"] = true
                meat["dropwig"] = true
                meat["kingvulture"] = true
            end
        elseif Tracker:FindObjectForCode("MSC").Active then
            if Tracker:FindObjectForCode("crunch").Active then
                meat["squidcada"] = true
                meat["scavenger"] = true
                meat["yellowlizard"] = true
                meat["vulture"] = true
                meat["whitelizard"] = true
                meat["pinklizard"] = true
                meat["bluelizard"] = true
                meat["eggbug"] = true
                meat["cyanlizard"] = true
                meat["kingvulture"] = true
                if Tracker:FindObjectForCode("gourmand").Active then
                    --intentionally blank, because the elsecase is easier to write than testing for hunter, arti, and spearmaster
                else
                    meat["dropwig"] = true
                    if Tracker:FindObjectForCode("spearmaster").Active then
                        meat["poleplant"] = true
                    end
                end
            end
        end
    end
    if has_access("Shoreline") and Tracker:FindObjectForCode("notarti") and Tracker:FindObjectForCode("notspearmaster") then
        meat["jellyfish"] = true
        meat["batfly"] = true
        meat["hazer"] = true
        if Tracker:FindObjectForCode("MSC").Active == false then
            if Tracker:FindObjectForCode("hunter").Active then
                meat["jetfish"] = true
                meat["salamander"] = true
                meat["snail"] = true
                meat["vulture"] = true
                meat["whitelizard"] = true
                meat["kingvulture"] = true
                meat["rotcyst"] = true
            end
        elseif Tracker:FindObjectForCode("MSC").Active then
            meat["aquapede"] = true
            if Tracker:FindObjectForCode("crunch").Active then
                meat["jetfish"] = true
                meat["snail"] = true
                meat["salamander"] = true
                meat["whitelizard"] = true
                meat["kingvulture"] = true
                if Tracker:FindObjectForCode("hunter").Active then
                    meat["vulture"] = true
                    meat["rotcyst"] = true
                elseif Tracker:FindObjectForCode("gourmand").Active then
                    meat["eellizard"] = true
                end
            end
        end
    end
    if has_access("Shoreline") and (Tracker:FindObjectForCode("arti") or Tracker:FindObjectForCode("spearmaster")) then
        meat["jellyfish"] = true
        meat["hazer"] = true
        meat["snail"] = true
        meat["jetfish"] = true
        meat["salamander"] = true
        meat["squidcada"] = true
        meat["dropwig"] = true
        meat["bluelizard"] = true
        meat["whitelizard"] = true
        meat["cyanlizard"] = true
        meat["eggbug"] = true
        meat["vulture"] = true
        meat["kingvulture"] = true
        meat["scavenger"] = true
        meat["yellowlizard"] = true
        if Tracker:FindObjectForCode("arti").Active then
            meat["eggbugegg"] = true
        elseif Tracker:FindObjectForCode("spearmaster").Active then
            meat["poleplant"] = true
            meat["monsterkelp"] = true
            meat["rotcyst"] = true
            meat["leviathan"] = true
        end
    end
    if has_access("Metropolis") then
        if Tracker:FindObjectForCode("notspearmaster").Active then
            meat["eggbugegg"] = true
        end
        if Tracker:FindObjectForCode("crunch").Active then
            meat["cyanlizard"] = true
            meat["whitelizard"] = true
            meat["yellowlizard"] = true
            meat["scavenger"] = true
            meat["eggbug"] = true
            if Tracker:FindObjectForCode("spearmaster").Active then
                meat["inspector"] = true
            elseif Tracker:FindObjectForCode("arti").Active then
                meat["kingvulture"] = true
                meat["elitescav"] = true
            end
        end
    end
    if has_access("Submerged_Superstructure") then
        meat["jellyfish"] = true
        meat["aquapede"] = true
        meat["giantjelly"] = true
        if Tracker:FindObjectForCode("crunch").Active then
            meat["squidcada"] = true
            meat["snail"] = true
            meat["scavenger"] = true
            meat["jetfish"] = true
            meat["eellizard"] = true
            meat["vulture"] = true
        end
        if Tracker:FindObjectForCode("spearmaster").Active then
            meat["leviathan"] = true
        end
    end
    
    if has_access("Looks_to_the_Moon") then
        meat["bluelizard"] = true
        meat["whitelizard"] = true
        meat["cyanlizard"] = true
        meat["yellowlizard"] = true
        meat["poleplant"] = true
        meat["spider"] = true
        meat["spitterspider"] = true
        meat["splitterspider"] = true
        meat["dropwig"] = true
        meat["lanternmouse"] = true
        meat["inspector"] = true
        meat["mirosvulture"] = true
    end
    return meat
end

function chieftainaccess()
    if Tracker:FindObjectForCode("chieftain_difficulty").Active then
        local access = math.max(
            Tracker:FindObjectForCode("Outskirts_Center").CurrentStage,
            Tracker:FindObjectForCode("Farm_Arrays").CurrentStage,
            Tracker:FindObjectForCode("Outer_Expanse").CurrentStage,
            Tracker:FindObjectForCode("Drainage_System").CurrentStage,
            Tracker:FindObjectForCode("Garbage_Wastes").CurrentStage,
            Tracker:FindObjectForCode("Silent_Construct").CurrentStage,
            1
    )
    if access == 1 then
        return AccessibilityLevel.SequenceBreak
    else
        return AccessibilityLevel.Normal
    end
    else
        return AccessibilityLevel.Normal
    end
end

function echoaccess()
    if Tracker:FindObjectForCode("saint").Active then
        return true
    elseif Tracker:FindObjectForCode("echo_difficulty").CurrentStage == 1 then
        if Tracker:FindObjectForCode("Karma").CurrentStage >= 4 then
            return true
        else
            return false
        end
    else
        return true
    end
end

function submergedvis()
    if Tracker:FindObjectForCode("riv").Active and Tracker:FindObjectForCode("aquatic_submerged").Active then
        return true
    elseif Tracker:FindObjectForCode("all_submerged").Active then
        return true
    elseif Tracker:FindObjectForCode("aquatic-perk-option") and Tracker:FindObjectForCode("aquatic_submerged").Active then
        return true
    end
    return false
end

function is_glowing()
    if Tracker:FindObjectForCode("glow-option").Active or Tracker:FindObjectForCode("glow-item").Active then
        logicprint("Has glow setting/item")
        return true
    end
    if Tracker:FindObjectForCode("gourmand").Active or Tracker:FindObjectForCode("inv").Active then
        logicprint("Glowing scug")
        return true
    end
    logicprint("Not glowing")
    return false
end

function bfs_search(graph, starting_node)
    local queue = Queue.new()
    Queue.pushright(queue, starting_node)
    local visited = {}
    local counter = 0
    -- Check access from the next region in the queue
    repeat
        local region = graph[Queue.popleft(queue)]
        local region_access = region:get_access()
        
        counter = counter + 1
        if counter > 500 then
            print("Something went wrong and entered a loop. Escaping.")
            return
        end
        if (visited[region.name] or 0) < region_access then
            local movements = region:get_applicable_movement()
            local next_regions = {}
            
            for _, movement in pairs(movements) do
                local next_region = movement:get_destination(region.name)
                local next_region_access = movement:check_access(region.name)
                if next_regions[next_region] == nil then
                    next_regions[next_region] = next_region_access
                else
                    next_regions[next_region] = math.min(next_region_access, next_regions[next_region])
                end
            end
            
            for next_region, next_region_access in pairs(next_regions) do
                graph[next_region]:upgrade_access(math.min(next_region_access, region_access))
                Queue.pushright(queue, next_region)
            end

        end
        visited[region.name] = region_access
    until Queue.isempty(queue)
end

function update_region_logic()
    local stating_regions = {}
    print("Resetting regions")
    local logic_regions = get_regions()
    for region_name, region in pairs(logic_regions) do
        if region:reset_region() == 3 then
            table.insert(stating_regions, region)
        end
    end
    
    for _, region in ipairs(stating_regions) do
        region:set_spawn()
        bfs_search(logic_regions, region.name)
    end
end
 
-- Things that can cause gate logic to change
ScriptHost:AddWatchForCode("Code related to region logic updated", "region_logic", update_region_logic)

function passage_check(needs_enabled)
    local passage_settings = Tracker:FindObjectForCode("passage_progress").CurrentStage
    local survivor_reached = Tracker:FindObjectForCode("Karma").CurrentStage >= 4
    if passage_settings == 2 then
        return true
    elseif passage_settings == 1 and needs_enabled then
        return true
    end

    return survivor_reached
end

-- Defaults for testing
if DEBUG_MODE then
    if DEFAULT_SCUG ~= nil then
        Tracker:FindObjectForCode("scug").CurrentStage = CAMPAIGN_NUMBERS[DEFAULT_SCUG]
    end
    if SHELTER_SANITY ~= nil then
        Tracker:FindObjectForCode("sheltersanity").Active = SHELTER_SANITY
    end
    if FOOD_QUEST ~= nil then
        Tracker:FindObjectForCode("foodquest").Active = SHELTER_SANITY
    end
    if SUB_SANITY ~= nil then
        Tracker:FindObjectForCode("subsanity").CurrentStage = SUB_SANITY
    end
    if DEFAULT_MSC ~= nil then
        Tracker:FindObjectForCode("MSC").Active = DEFAULT_MSC
    end
    if DEFAULT_DEV_CHECKS ~= nil then
        Tracker:FindObjectForCode("devchecks").Active = DEFAULT_DEV_CHECKS
    end
end