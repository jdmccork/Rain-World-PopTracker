--debugging info
gatelogicdebug = false
regiondebug = false
scugdebug = false
logicdebug = false

--defaults
DEBUG_MODE = true
DEFAULT_SCUG = "survivor"
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

function monkaccess()
    return true
end

function hunteraccess()
    return true
end

function dragonaccess()
    return true
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