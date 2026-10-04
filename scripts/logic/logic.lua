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
DEFAULT_MSC = false
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
    local food = 0
    local bluefruit = false
    local popcorn = false
    local bubblefruit = false
    local gooieduck = false
    local lilypuck = false
    local slime = false
    local neuron = false
    local peach = false
    local glowweed = false
    if has_access("Outskirts") then
        if Tracker:FindObjectForCode("notspearmaster").Active then
            bluefruit = true
        end
        if Tracker:FindObjectForCode("monk").Active or Tracker:FindObjectForCode("survivor").Active or Tracker:FindObjectForCode("MSC").Active then
            popcorn = true
        end
    end
    if has_access("Industrial_Complex") then
        if Tracker:FindObjectForCode("notspearmaster").Active then
            bluefruit = true
            bubblefruit = true
        end
        popcorn = true
    end
    if has_access("Chimney_Canopy") then
        if Tracker:FindObjectForCode("notspearmaster").Active then
            bluefruit = true
        end
    end
    if has_access("Farm_Arrays") then
        popcorn = true
        if Tracker:FindObjectForCode("notspearmaster").Active then
            bluefruit = true
            if Tracker:FindObjectForCode("MSC").Active then
                gooieduck = true
            end
        end
    end
    if has_access("Subterranean") then
        popcorn = true
        if Tracker:FindObjectForCode("notspearmaster").Active then
            bluefruit = true
            bubblefruit = true
            if Tracker:FindObjectForCode("MSC").Active then
                gooieduck = true
            end
        end
    end
    if has_access("Outer_Expanse") then
        bluefruit = true
        gooieduck = true
    end
    if has_access("Drainage_System") then
        if Tracker:FindObjectForCode("notspearmaster").Active then
            bluefruit = true
            bubblefruit = true
            if Tracker:FindObjectForCode("MSC").Active then
                lilypuck = true
            end
        end
    end
    if has_access("Garbage_Wastes") then
        if Tracker:FindObjectForCode("notspearmaster").Active then
            bluefruit = true
            bubblefruit = true
        end
        popcorn = true
    end
    if has_access("Shaded_Citadel") then
        if Tracker:FindObjectForCode("notspearmaster").Active and Tracker:FindObjectForCode("notsaint").Active then
            bluefruit = true
            bubblefruit = true
            slime = true
            if Tracker:FindObjectForCode("MSC").Active and (Tracker:FindObjectForCode("monk").Active or Tracker:FindObjectForCode("survivor").Active or Tracker:FindObjectForCode("riv").Active) then
                lilypuck = true
            end
        end
    end
    if has_access("The_Exterior") then
        if Tracker:FindObjectForCode("notspearmaster").Active then
            bluefruit = true
            slime = true
        end
    end
    if has_access("Five_Pebbles") then
        neuron = true
        popcorn = true
    end
    if has_access("Pipeyard") then
        if Tracker:FindObjectForCode("notspearmaster").Active then
            bluefruit = true
            bubblefruit = true
            bubblefruit = true
            lilypuck = true
        end
        popcorn = true
    end
    if has_access("Sky_Islands") then
        if Tracker:FindObjectForCode("notspearmaster").Active then
            bluefruit = true
            if Tracker:FindObjectForCode("MSC").Active then
                peach = true
            end
        end
        popcorn = true
    end
    if has_access("Shoreline") then
        if Tracker:FindObjectForCode("notspearmaster").Active then
            bluefruit = true
            bubblefruit = true
            if Tracker:FindObjectForCode("MSC").Active and not Tracker:FindObjectForCode("arti").Active then
                glowweed = true
            end
        end
        if Tracker:FindObjectForCode("saint").Active then
            slime = true
        end
        popcorn = true
    end
    if has_access("Metropolis") then
        bluefruit = true
        popcorn = true
        neuron = true
    end
    if has_access("Submerged_Superstructure") then
        bluefruit = true
        bubblefruit = true
        glowweed = true
    end
    if has_access("Silent_Construct") then
        bluefruit = true
        popcorn = true
        slime = true
    end
    if has_access("Looks_to_the_Moon") then
        neuron = true
    end
    if has_access("Rubicon") then
        bluefruit = true
        popcorn = true
        peach = true
    end
    if bluefruit then
        food = food + 1
    end
    if popcorn then
        food = food + 1
    end
    if bubblefruit then
        food = food + 1
    end
    if gooieduck then
        food = food + 1
    end
    if lilypuck then
        food = food + 1
    end
    if slime then
        food = food + 1
    end
    if neuron then
        food = food + 1
    end
    if peach then
        food = food + 1
    end
    if glowweed then
        food = food + 1
    end
    local counter = (food >= tonumber(Tracker:FindObjectForCode("monk_difficulty").AcquiredCount))
    if counter then
        return true
    else
        return false
    end
    return true
end

function hunteraccess()
    local food = 0
    local greenliz = false
    local pinkliz = false
    local squidcada = false
    local scav = false
    local batfly = false
    local noodlefly = false
    local poleplant = false
    local centipede = false
    local hazer = false
    local blueliz = false
    local whiteliz = false
    local redliz = false
    local vulture = false
    local kingvulture = false
    local monsterkelp = false
    local dropwig = false
    local caramelliz = false
    local strawberryliz = false
    local centiwing = false
    local vulturegrub = false
    local eggbug = false
    local eggbugegg = false
    local snail = false
    local cyanliz = false
    local yellowliz = false
    local lanternmouse = false
    local eelliz = false
    local grappleworm = false
    local spider = false
    local spitterspider = false
    local elitescav = false
    local jetfish = false
    local blackliz = false
    local salamander = false
    local stowaway = false
    local splitterspider = false
    local yeek = false
    local bll = false
    local dll = false
    local mll = false
    local inspector = false
    local jellyfish = false
    local aquapede = false
    local giantjelly = false
    if has_access("Outskirts") then
        batfly = true
        noodlefly = true
        centipede = true
        if Tracker:FindObjectForCode("MSC").Active == false then
            if Tracker:FindObjectForCode("monk").Active or Tracker:FindObjectForCode("hunter").Active then
                hazer = true
            end
            if Tracker:FindObjectForCode("hunter").Active then
                blueliz = true
                whiteliz = true
                vulture = true
                kingvulture = true
                dropwig = true
            end
        elseif Tracker:FindObjectForCode("MSC").Active then
            if Tracker:FindObjectForCode("monk").Active then
                hazer = true
            end
            if Tracker:FindObjectForCode("crunch").Active then
                greenliz = true
                pinkliz = true
                squidcada = true
                kingvulture = true
                dropwig = true
                scav = true
            end
            if Tracker:FindObjectForCode("hunter").Active or Tracker:FindObjectForCode("arti").Active or Tracker:FindObjectForCode("spearmaster").Active then
                blueliz = true
                whiteliz = true
                vulture = true
                hazer = true
            end
            if Tracker:FindObjectForCode("spearmaster").Active then
                monsterkelp = true
            end
        end
    end
    if has_access("Industrial_Complex") then
        batfly = true
        centipede = true
        hazer = true
        vulturegrub = true
        if Tracker:FindObjectForCode("MSC").Active == false then 
            if Tracker:FindObjectForCode("monk").Active or Tracker:FindObjectForCode("hunter").Active then
                eggbugegg = true
            end
            if Tracker:FindObjectForCode("hunter").Active then
                scav = true
                greenliz = true
                pinkliz = true
                blueliz = true
                whiteliz = true
                cyanliz = true
                dropwig = true
                eggbug = true
                vulture = true
                kingvulture = true
            end
        elseif Tracker:FindObjectForCode("MSC").Active then
            if Tracker:FindObjectForCode("monk").Active or Tracker:FindObjectForCode("hunter").Active or Tracker:FindObjectForCode("arti").Active or Tracker:FindObjectForCode("riv").Active then
                eggbugegg = true
            end
            if Tracker:FindObjectForCode("crunch").Active then
                scav = true
                whiteliz = true
                vulture = true
                greenliz = true
                pinkliz = true
                blueliz = true
                cyanliz = true
                kingvulture = true
            end
            if Tracker:FindObjectForCode("hunter").Active or Tracker:FindObjectForCode("gourmand").Active then
                caramelliz = true
            end
            if Tracker:FindObjectForCode("hunter").Active or Tracker:FindObjectForCode("arti").Active or Tracker:FindObjectForCode("spearmaster").Active then
                dropwig = true
                eggbug = true
            end
            if Tracker:FindObjectForCode("gourmand").Active then
                snail = true
            end
            if Tracker:FindObjectForCode("spearmaster").Active then
                poleplant = true
            end
        end
    end
    if has_access("Chimney_Canopy") then
        vulturegrub = true
        batfly = true
        if Tracker:FindObjectForCode("MSC").Active == false then
            if Tracker:FindObjectForCode("monk").Active or Tracker:FindObjectForCode("hunter").Active then
                eggbugegg = true
            end
            if Tracker:FindObjectForCode("hunter").Active then
                scav = true
                pinkliz = true
                blueliz = true
                whiteliz = true
                vulture = true
                grappleworm = true
                cyanliz = true
                kingvulture = true
                dropwig = true
                spider = true
                spitterspider = true
                noodlefly = true
                eggbug = true
            end
        elseif Tracker:FindObjectForCode("MSC").Active then
            if Tracker:FindObjectForCode("monk").Active or Tracker:FindObjectForCode("hunter").Active or Tracker:FindObjectForCode("arti").Active or Tracker:FindObjectForCode("riv").Active then
                eggbugegg = true
            end
            if Tracker:FindObjectForCode("crunch").Active then
                scav = true
                whiteliz = true
                vulture = true
                pinkliz = true
                blueliz = true
                grappleworm = true
                kingvulture = true
                dropwig = true
            end
            if Tracker:FindObjectForCode("hunter").Active or Tracker:FindObjectForCode("gourmand").Active then
                caramelliz = true
            end
            if Tracker:FindObjectForCode("hunter").Active or Tracker:FindObjectForCode("arti").Active or Tracker:FindObjectForCode("spearmaster").Active then
                spider =  true
                elitescav = true
                noodlefly = true
                cyanliz = true
            end
            if Tracker:FindObjectForCode("arti").Active or Tracker:FindObjectForCode("spearmaster").Active then
                spitterspider = true
            end
            if Tracker:FindObjectForCode("spearmaster").Active then
                poleplant = true
            end
        end
    end
    if has_access("Farm_Arrays") then
        centipede = true
        vulturegrub = true
        noodlefly = true
        batfly = true
        hazer = true
        if Tracker:FindObjectForCode("notspearmaster").Active then
            eggbugegg = true
        end
        if Tracker:FindObjectForCode("crunch").Active then
            scav = true
            caramelliz = true
            vulture = true
            kingvulture = true
            blueliz = true
            greenliz = true
            squidcada = true
            eggbug = true
        end
        if Tracker:FindObjectForCode("gourmand").Active then
            yellowliz = true
        end
        if Tracker:FindObjectForCode("hunter").Active or Tracker:FindObjectForCode("arti").Active or Tracker:FindObjectForCode("spearmaster").Active then
            spider = true
            spitterspider = true
        end
        if Tracker:FindObjectForCode("arti").Active or Tracker:FindObjectForCode("spearmaster").Active then
            centiwing = true
        end
        if Tracker:FindObjectForCode("spearmaster").Active then
            poleplant = true
        end
    end
    if has_access("Subterranean") then
        centipede = true
        batfly = true
        if Tracker:FindObjectForCode("MSC").Active == false then
            if Tracker:FindObjectForCode("hunter").Active then
                blackliz = true
                scav = true
                spider = true
                salamander = true
                blueliz = true
                greenliz = true
                dropwig = true
                spitterspider = true
                cyanliz = true
                jetfish = true
                eggbug = true
                eggbugegg = true
            end
        elseif Tracker:FindObjectForCode("MSC").Active then
            if Tracker:FindObjectForCode("survivor").Active or Tracker:FindObjectForCode("crunch").Active then
                noodlefly = true
            end
            if Tracker:FindObjectForCode("crunch").Active then
                blackliz = true
                jetfish = true
                scav = true
                spider = true
                caramelliz = true
                blueliz = true
                dropwig = true
                spitterspider = true
                salamander = true
                cyanliz = true
                splitterspider = true
            end
            if Tracker:FindObjectForCode("hunter").Active or Tracker:FindObjectForCode("arti").Active or Tracker:FindObjectForCode("spearmaster").Active then
                eggbug = true
            end
            if Tracker:FindObjectForCode("hunter").Active or Tracker:FindObjectForCode("arti").Active then
                eggbugegg = true
            end
            if Tracker:FindObjectForCode("spearmaster").Active then
                poleplant = true
            end
        end
    end
    if has_access("Outer_Expanse") then
        centipede = true
        batfly = true
        if Tracker:FindObjectForCode("gourmand").Active then
            blueliz = true
            caramelliz = true
            dropwig = true
            scav = true
            yeek = true
            whiteliz = true
            vulture = true
        end
    end
    if has_access("Drainage_System") then
        hazer = true
        batfly = true
        if Tracker:FindObjectForCode("MSC").Active == false then
            if Tracker:FindObjectForCode("hunter").Active then
                snail = true
                scav = true
                salamander = true
                greenliz = true
                centipede = true
                dropwig = true
                cyanliz = true
            end
        elseif Tracker:FindObjectForCode("MSC").Active then
            if Tracker:FindObjectForCode("crunch").Active then
                snail = true
                scav = true
                salamander = true
                greenliz = true
                if Tracker:FindObjectForCode("gourmand").Active then
                    pinkliz = true
                end
                if Tracker:FindObjectForCode("hunter").Active or Tracker:FindObjectForCode("arti").Active or Tracker:FindObjectForCode("spearmaster").Active then
                    centipede = true
                    dropwig = true
                    cyanliz = true
                    if Tracker:FindObjectForCode("spearmaster").Active then
                        poleplant = true
                    end
                end
            end
        end
    end
    if has_access("Garbage_Wastes") then
        centipede = true
        batfly = true
        vulturegrub = true
        hazer = true
        if Tracker:FindObjectForCode("MSC").Active == false then
            if Tracker:FindObjectForCode("hunter").Active then
                scav = true
                snail = true
                squidcada = true
                bll = true
                vulture = true
                greenliz = true
                pinkliz = true
                cyanliz = true
                dropwig = true
                dll = true
                kingvulture = true
                eggbugegg = true
                eggbug = true
            end
        elseif Tracker:FindObjectForCode("MSC").Active then
            if Tracker:FindObjectForCode("crunch").Active then
                scav = true
                vulture = true
                snail = true
                squidcada = true
                greenliz = true
                if Tracker:FindObjectForCode("hunter").Active or Tracker:FindObjectForCode("gourmand").Active then
                    pinkliz = true
                    bll = true
                    caramelliz = true
                    if Tracker:FindObjectForCode("gourmand").Active then
                        whiteliz = true
                    end
                end
                if Tracker:FindObjectForCode("hunter").Active or Tracker:FindObjectForCode("arti").Active or Tracker:FindObjectForCode("spearmaster").Active then
                    if Tracker:FindObjectForCode("notspearmaster").Active then
                        eggbugegg = true
                    end
                    eggbug = true
                    cyanliz = true
                    dll = true
                    dropwig = true
                    kingvulture = true
                    if Tracker:FindObjectForCode("arti").Active or Tracker:FindObjectForCode("spearmaster").Active then
                        blueliz = true
                        spider = true
                        spitterspider = true
                        if Tracker:FindObjectForCode("spearmaster").Active then
                            poleplant = true
                            mll = true
                            elitescav = true
                        end
                    end
                end
            end
        end
    end
    if has_access("Shaded_Citadel") then
        batfly = true
        if Tracker:FindObjectForCode("MSC").Active == false then
            if Tracker:FindObjectForCode("hunter").Active then
                scav = true
                blackliz = true
                lanternmouse = true
                spider = true
                dropwig = true
                spitterspider = true
                eggbug = true
                eggbugegg = true
                centipede = true
            end
        elseif Tracker:FindObjectForCode("MSC").Active then
            if Tracker:FindObjectForCode("notspearmaster").Active then
                eggbugegg = true
            end
            if Tracker:FindObjectForCode("crunch").Active then
                scav = true
                blackliz = true
                eggbug = true
                lanternmouse = true
                spider = true
                centipede = true
                if Tracker:FindObjectForCode("hunter").Active or Tracker:FindObjectForCode("arti").Active or Tracker:FindObjectForCode("spearmaster").Active then
                    spitterspider = true
                    dropwig = true
                    if Tracker:FindObjectForCode("spearmaster").Active then
                        monsterkelp = true
                    end
                elseif Tracker:FindObjectForCode("gourmand").Active then
                    pinkliz = true
                end
            end
        end
    end
    if has_access("The_Exterior") then
        batfly = true
        if Tracker:FindObjectForCode("MSC").Active == false then
            if Tracker:FindObjectForCode("hunter").Active then
                grappleworm = true
                whiteliz = true
                yellowliz = true
                dll = true
                blueliz = true
                cyanliz = true
                spitterspider = true
                dropwig = true
                kingvulture = true
            end
        elseif Tracker:FindObjectForCode("MSC").Active then
            if Tracker:FindObjectForCode("crunch").Active then
                grappleworm = true
                whiteliz = true
                yellowliz = true
                blueliz = true
                dropwig = true
                if Tracker:FindObjectForCode("gourmand").Active or Tracker:FindObjectForCode("hunter").Active or Tracker:FindObjectForCode("arti").Active then
                    dll = true
                end
                if Tracker:FindObjectForCode("hunter").Active or Tracker:FindObjectForCode("arti").Active or Tracker:FindObjectForCode("spearmaster").Active then
                    cyanliz = true
                    spider = true
                    spitterspider = true
                    kingvulture = true
                    if Tracker:FindObjectForCode("arti").Active or Tracker:FindObjectForCode("spearmaster").Active then
                        scav = true
                        if Tracker:FindObjectForCode("spearmaster").Active then
                            poleplant = true
                            vulture = true
                        end
                    end
                end
            end
        end
    end
    if has_access("Five_Pebbles") then
        if Tracker:FindObjectForCode("crunch").Active then
            if Tracker:FindObjectForCode("spearmaster").Active then
                inspector = true
            else
                dll = true
            end
        end
    end
    if has_access("Pipeyard") then
        batfly = true
        centipede = true
        if Tracker:FindObjectForCode("notriv").Active then
            if Tracker:FindObjectForCode("notspearmaster").Active then
                eggbugegg = true
            end
            if Tracker:FindObjectForCode("crunch").Active then
                vulture = true
                scav = true
                blackliz = true
                cyanliz = true
                salamander = true
                dropwig = true
                eggbug = true
                jetfish = true
                squidcada = true
                snail = true
                if Tracker:FindObjectForCode("gourmand").Active then
                    pinkliz = true
                    blueliz = true
                    eelliz = true
                else
                    kingvulture = true
                    if Tracker:FindObjectForCode("spearmaster").Active then
                        monsterkelp = true
                        poleplant = true
                    end
                end
            end
        end
    end
    if has_access("Sky_Islands") then
        if Tracker:FindObjectForCode("notriv").Active then
            noodlefly = true
        end
        batfly = true
        centiwing = true
        if Tracker:FindObjectForCode("notspearmaster").Active then
            eggbugegg = true
        end
        if Tracker:FindObjectForCode("MSC").Active == false then
            if Tracker:FindObjectForCode("hunter").Active then
                squidcada = true
                scav = true
                yellowliz = true
                eggbug = true
                vulture = true
                blueliz = true
                whiteliz = true
                pinkliz = true
                cyanliz = true
                dropwig = true
                kingvulture = true
            end
        elseif Tracker:FindObjectForCode("MSC").Active then
            if Tracker:FindObjectForCode("crunch").Active then
                squidcada = true
                scav = true
                yellowliz = true
                vulture = true
                whiteliz = true
                pinkliz = true
                blueliz = true
                eggbug = true
                cyanliz = true
                kingvulture = true
                if Tracker:FindObjectForCode("gourmand").Active then
                    --intentionally blank, because the elsecase is easier to write than testing for hunter, arti, and spearmaster
                else
                    dropwig = true
                    if Tracker:FindObjectForCode("spearmaster").Active then
                        poleplant = true
                    end
                end
            end
        end
    end
    if has_access("Shoreline") and Tracker:FindObjectForCode("notarti") and Tracker:FindObjectForCode("notspearmaster") then
        jellyfish = true
        batfly = true
        hazer = true
        if Tracker:FindObjectForCode("MSC").Active == false then
            if Tracker:FindObjectForCode("hunter").Active then
                jetfish = true
                salamander = true
                snail = true
                vulture = true
                whiteliz = true
                kingvulture = true
                bll = true
            end
        elseif Tracker:FindObjectForCode("MSC").Active then
            aquapede = true
            if Tracker:FindObjectForCode("crunch").Active then
                jetfish = true
                snail = true
                salamander = true
                whiteliz = true
                kingvulture = true
                if Tracker:FindObjectForCode("hunter").Active then
                    vulture = true
                    bll = true
                elseif Tracker:FindObjectForCode("gourmand").Active then
                    eelliz = true
                end
            end
        end
    end
    if has_access("Shoreline") and (Tracker:FindObjectForCode("arti") or Tracker:FindObjectForCode("spearmaster")) then
        jellyfish = true
        hazer = true
        snail = true
        jetfish = true
        salamander = true
        squidcada = true
        dropwig = true
        blueliz = true
        whiteliz = true
        cyanliz = true
        eggbug = true
        vulture = true
        kingvulture = true
        scav = true
        yellowliz = true
        if Tracker:FindObjectForCode("arti").Active then
            eggbugegg = true
        elseif Tracker:FindObjectForCode("spearmaster").Active then
            poleplant = true
            monsterkelp = true
            dll = true
        end
    end
    if has_access("Metropolis") then
        if Tracker:FindObjectForCode("notspearmaster").Active then
            eggbugegg = true
        end
        if Tracker:FindObjectForCode("crunch").Active then
            cyanliz = true
            whiteliz = true
            yellowliz = true
            scav = true
            eggbug = true
            if Tracker:FindObjectForCode("spearmaster").Active then
                inspector = true
            elseif Tracker:FindObjectForCode("arti").Active then
                kingvulture = true
                elitescav = true
            end
        end
    end
    if has_access("Submerged_Superstructure") then
        jellyfish = true
        aquapede = true
        giantjelly = true
        if Tracker:FindObjectForCode("crunch").Active then
            squidcada = true
            snail = true
            scav = true
            jetfish = true
            eelliz = true
            vulture = true
        end
    end
    
    if has_access("Looks_to_the_Moon") then
        blueliz = true
        whiteliz = true
        cyanliz = true
        yellowliz = true
        poleplant = true
        spider = true
        spitterspider = true
        splitterspider = true
        dropwig = true
        lanternmouse = true
        inspector = true
    end
    if greenliz then
        food = food + 1
    end
    if pinkliz then
        food = food + 1
    end
    if squidcada then
        food = food + 1
    end
    if scav then
        food = food + 1
    end
    if batfly then
        food = food + 1
    end
    if noodlefly then
        food = food + 1
    end
    if poleplant then
        food = food + 1
    end
    if centipede then
        food = food + 1
    end
    if hazer then
        food = food + 1
    end
    if blueliz then
        food = food + 1
    end
    if whiteliz then
        food = food + 1
    end
    if redliz then
        food = food + 1
    end
    if vulture then
        food = food + 1
    end
    if kingvulture then
        food = food + 1
    end
    if monsterkelp then
        food = food + 1
    end
    if dropwig then
        food = food + 1
    end
    if caramelliz then
        food = food + 1
    end
    if strawberryliz then
        food = food + 1
    end
    if centiwing then
        food = food + 1
    end
    if vulturegrub then
        food = food + 1
    end
    if eggbug then
        food = food + 1
    end
    if eggbugegg then
        food = food + 1
    end
    if snail then
        food = food + 1
    end
    if cyanliz then
        food = food + 1
    end
    if yellowliz then
        food = food + 1
    end
    if lanternmouse then
        food = food + 1
    end
    if eelliz then
        food = food + 1
    end
    if grappleworm then
        food = food + 1
    end
    if spider then
        food = food + 1
    end
    if spitterspider then
        food = food + 1
    end
    if elitescav then
        food = food + 1
    end
    if jetfish then
        food = food + 1
    end
    if blackliz then
        food = food + 1
    end
    if salamander then
        food = food + 1
    end
    if stowaway then
        food = food + 1
    end
    if splitterspider then
        food = food + 1
    end
    if yeek then
        food = food + 1
    end
    if bll then
        food = food + 1
    end
    if dll then
        food = food + 1
    end
    if mll then
        food = food + 1
    end
    if inspector then
        food = food + 1
    end
    if jellyfish then
        food = food + 1
    end
    if aquapede then
        food = food + 1
    end
    if giantjelly then
        food = food + 1
    end
    local counter = (food >= tonumber(Tracker:FindObjectForCode("hunter_difficulty").AcquiredCount))
    if counter then
        return true
    end
    return false
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