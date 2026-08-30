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
    if activecampaign ~= CAMPAIGN_NAMES[Tracker:FindObjectForCode("scug").CurrentStage] or Tracker:ProviderCountForCode("campaign") ~= 1 then
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
        
    else
        print(string.format("Current campaign is %s",activecampaign))
    end
    
    dlcselect()
    
end

ScriptHost:AddWatchForCode("Scug Change", "scug", characterselect)
ScriptHost:AddWatchForCode("campaign Change", "campaign", characterselect)

function reset_slugcat_codes()
    Tracker:FindObjectForCode("nothunter").Active = false
    Tracker:FindObjectForCode("notarti").Active = false

    Tracker:FindObjectForCode("mouth").Active = false
    Tracker:FindObjectForCode("crunch").Active = false
end

--for determining how many wanderer pips you should have access to
function available_regions(n)
    return Tracker:ProviderCountForCode("region") >= tonumber(n)
end

function nomadaccess()
    if available_regions(Tracker:FindObjectForCode("nomad_difficulty").AcquiredCount) then
        return true
    else
        return false
    end
end

function monkaccess()
    return true
end

function hunteraccess()
    return true
end

function dragonaccess()
    return true
end

function chieftainaccess(chieftainchecks)
    if chieftainchecks == 0 then
        return true
    else
        if Tracker:FindObjectForCode("notarti").Active then
            if has_outskirts_access() or has_farm_arrays_access() or has_outer_expanse_access() or has_garbage_access() or has_silent_access() or (has_drainage_access() and Tracker:FindObjectForCode("saint").Active) then
                return true
            else
                return false
            end
        end
    end
end

function echoaccess()
    if Tracker:FindObjectForCode("saint").Active then
        return true
    elseif echochecks == 0 then
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
    if Tracker:FindObjectForCode("riv").Active and Tracker:FindObjectForCode("sub_aquatic").Active then
        return true
    elseif Tracker:FindObjectForCode("sub_all").Active then
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

function bfs_search(starting_region)
    local logicq = Queue.new()
    Queue.pushright(logicq, starting_region)
    local counter = 0
    -- Check access from the next region in the queue
    while not Queue.isempty(logicq) do
        
        counter = counter + 1
        if counter > 500 then
            print("Something went wrong and entered a loop. Escaping.")
            return
        end
        local prev_region_name = Queue.popleft(logicq)
        print("Running check for region:", prev_region_name)
        
        -- Check the gates in the region
        for _, gate in pairs(REGIONS[prev_region_name].gates or {}) do
            local current_region_name = gate:get_next_region_name(prev_region_name)
            local current_region = REGIONS[current_region_name]
            
            -- Get access level for subregion on both sides of gate
            local prev_region_access = REGIONS[prev_region_name]:get_subregion_access(current_region_name)
            local current_region_access = current_region:get_subregion_access(prev_region_name)

            -- print("test data:", prev_region_name, prev_region_access, current_region_name, current_region_access)

            -- If the region hasn't been visited, add it to the queue and compute the region
            if current_region_access < prev_region_access then
                Queue.pushright(logicq, current_region_name)
                current_region:compute_region(prev_region_name, prev_region_access)
            end
        end
        print("Finished check for region:", prev_region_name)
    end
end

function update_region_logic()
    stating_regions = {}
    regionprint("Resetting regions")
    for i, region in ipairs(LOGIC_REGIONS) do
        REGIONS[region]:reset_region()
        
        if Tracker:FindObjectForCode(string.format("%s-spawn", region)).Active then
            regionprint(string.format("Adding %s to list of starting regions", region))
            table.insert(stating_regions, region)
        end
    end
    for _, region in ipairs(stating_regions) do
        bfs_search(region)
    end
end

-- Things that can cause gate logic to change
ScriptHost:AddWatchForCode("Spawn updated", "spawn", update_region_logic)
ScriptHost:AddWatchForCode("Gate access updated", "gate", update_region_logic)
ScriptHost:AddWatchForCode("Glowing status updated", "glow-item", update_region_logic)
ScriptHost:AddWatchForCode("Karma level updated", "karma", update_region_logic)

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
end