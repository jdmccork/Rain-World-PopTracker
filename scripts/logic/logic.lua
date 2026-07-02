
--Making variables not null
monkchecks = 4
hunterchecks = 4
outlawchecks = 8
nomadchecks = 8

--debugging info
gatelogicdebug = false
regiondebug = false
scugdebug = true
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

--Gate Logics aare defined here in the case of differing gate logic
function gateandkarma(gate,karma,n)
    if gate == "Gate_Wall-Metropolis" or karma == "drone" then
        gateprint(string.format("Checking Metro Gate with drone"))
        if ((Tracker:FindObjectForCode(gate).Active) and (Tracker:FindObjectForCode(karma).Active)) then
            gateprint("Has this gate!")
            return true
        else
            gateprint("Does NOT have this gate!")
            return false
        end
    end
    gateprint(string.format("Checking gate %s and %s level %s",gate,karma,n))
    if ((Tracker:FindObjectForCode(gate).Active) and (Tracker:FindObjectForCode(karma).CurrentStage >= (n-1))) then
        gateprint("Has this gate, should have access!")
        return true
    else
        gateprint("Does NOT have this gate!")
        return false
    end
end
function gateorkarma(gate,karma,n)
    if gate == "Gate_Wall-Metropolis" or karma == "drone" then
        gateprint("Checking Metropolis gate")
        if ((Tracker:FindObjectForCode(gate).Active) or (Tracker:FindObjectForCode(karma).Active)) then
            gateprint("Has this gate, should have access!")
            return true
        else
            gateprint("Has this gate, should have access!")
            return false
        end
    end
    gateprint(string.format("Checking gate %s or %s level %s",gate,karma,n))
    if ((Tracker:FindObjectForCode(gate).Active) or (Tracker:FindObjectForCode(karma).CurrentStage >= (n-1))) then
        gateprint("Has this gate, should have access!")
        return true
    else
        gateprint("Does NOT have this gate!")
        return false
    end
end
function onlygate(gate,karma,n)
    gateprint(string.format("Checking gate %s",gate))
    if Tracker:FindObjectForCode(gate).Active then
        gateprint("Has this gate, should have access!")
        return true
    else
        gateprint("Does not have this gate!")
        return false
    end
end
function onlykarma(gate,karma,n)
    if karma == "drone" then
        if Tracker:FindObjectForCode(karma).Active then
            gateprint("Has this gate, should have access!")
            return true
        else
            gateprint("Does NOT have this gate!")
            return false
        end
    end
    gateprint(string.format("Checking %s level %s",karma,n))
    if Tracker:FindObjectForCode(karma).CurrentStage >= (n-1) then
        gateprint("Has this gate, should have access!")
        return true
    else
        gateprint("Does NOT have this gate!")
        return false
    end
end

--in case tracker isn't connected to ap, gate logic will be assigned here
function gatelogic(gate,karma,n)
    characterselect()
    dlcselect()
    if Tracker:FindObjectForCode("gateorkarma").Active then
        if gateorkarma(gate,karma,n) then
            return true
        else
            return false
        end
    elseif Tracker:FindObjectForCode("onlygate").Active then
        if onlygate(gate,karma,n) then
            return true
        else
            return false
        end
    elseif Tracker:FindObjectForCode("onlykarma").Active then
        if onlykarma(gate,karma,n) then
            return true
        else
            return false
        end
    elseif Tracker:FindObjectForCode("gateandkarma").Active then
        if gateandkarma(gate,karma,n) then
            return true
        else
            return false
        end
    else
        return false
    end
end

--for manually adjusting dlc settings if tracker isn't connected to AP
dlcplaceholder = Tracker:FindObjectForCode("MSC").Active
function dlcselect()
    if Tracker:FindObjectForCode("MSC").Active and (Tracker:FindObjectForCode("MSC").Active ~= dlcplaceholder) then
        Tracker:FindObjectForCode("vanilla").Active = false
        dlcplaceholder = Tracker:FindObjectForCode("MSC").Active
    elseif Tracker:FindObjectForCode("MSC").Active == false and (Tracker:FindObjectForCode("MSC").Active ~= dlcplaceholder) then
        Tracker:FindObjectForCode("vanilla").Active = true
        dlcplaceholder = Tracker:FindObjectForCode("MSC").Active
    end
end

--for manually settings the current slugcat campaign
character = Tracker:FindObjectForCode("scug").CurrentStage
firstset = false
function characterselect()
    if not firstset then
        activecampaign = CAMPAIGN_NAMES[Tracker:FindObjectForCode("scug").CurrentStage]
        firstset = true
    end
    if not CURRENT_CAMPAIGN then
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
    else
        print(string.format("Current campaign is %s",CURRENT_CAMPAIGN))
    end
end

--borderline recursive region access logic
visited = {}
function has_outskirts_access()
    regionprint("Checking Outskirts access...")
    if visited["outskirts"] then
        regionprint("Already in an outskirts block")
        return false
    end
    visited["outskirts"] = true
    if Tracker:FindObjectForCode("Outskirts").Active then
        visited["outskirts"] = false
        regionprint("Outskirts is active")
        return true
    end
    if gatelogic("Gate_Outskirts-Industrial","Karma",2) and has_industrial_access() then
        visited["outskirts"] = false 
        regionprint("Has Outskirts from Industrial.")
        Tracker:FindObjectForCode("Outskirts").Active = true
        return true
    end
    if gatelogic("Gate_Outskirts-Farm_Arrays","Karma",2) and has_farm_arrays_access() then 
        visited["outskirts"] = false 
        regionprint("Has Outskirts from Farm Arrays")
        Tracker:FindObjectForCode("Outskirts").Active = true
        return true
    end
    if gatelogic("Gate_Outskirts-Drainage","Karma",2) and has_drainage_access() then 
        visited["outskirts"] = false 
        regionprint("Has Outskirts from Drainage.")
        Tracker:FindObjectForCode("Outskirts").Active = true
        return true
    end
    if gatelogic("Gate_Outer_Expanse-Outskirts","Karma",1) and has_outer_expanse_access() then
        visited["outskirts"] = false 
        regionprint("")
        Tracker:FindObjectForCode("Outskirts").Active = true
        Tracker:FindObjectForCode("early").Active = true
        return true
    end
    visited["outskirts"] = false
    regionprint("does NOT have Outskirts access")
    return false
end
function has_industrial_access()
    regionprint("Checking Industrial access...")
    if visited["industrial"] then
        regionprint("Already in an Industrial block")
        return false
    end
    visited["industrial"] = true
    if Tracker:FindObjectForCode("Industrial").Active then
        regionprint("Industrial is Active!")
        visited["industrial"] = false
        return true
    end
    if gatelogic("Gate_Outskirts-Industrial","Karma",3) and has_outskirts_access() then
        visited["industrial"] = false 
        regionprint("Industrial access from Outskirts")
        Tracker:FindObjectForCode("Industrial").Active = true
        return true
    end
    if gatelogic("Gate_Industrial-Pipeyard","Karma",2) and has_pipeyard_access() then
        visited["industrial"] = false
        regionprint("Industrial access from Pipeyard")
        Tracker:FindObjectForCode("Industrial").Active = true
        return true
    end
    if gatelogic("Gate_Industrial-Chimney","Karma",3) and has_chimney_access() then
        visited["industrial"] = false
        regionprint("Industrial access from Chimney")
        Tracker:FindObjectForCode("Industrial").Active = true
        return true
    end
    if gatelogic("Gate_Industrial-Shaded","Karma",1) and (has_shaded_access() or has_silent_access()) then
        visited["industrial"] = false
        regionprint("Industrial access from Shaded")
        Tracker:FindObjectForCode("Industrial").Active = true
        return true
    end
    if gatelogic("Gate_Industrial-Garbage","Karma",2) and has_garbage_access() then
        visited["industrial"] = false
        regionprint("Industrial access from Garbage")
        Tracker:FindObjectForCode("Industrial").Active = true
        return true
    end
    visited["industrial"] = false
    regionprint("Does NOT have industrial access!")
    return false
end
function has_chimney_access()
    regionprint("Checking Chimney access...")
    if visited["chimney"] then
        regionprint("Already in a Chimney block")
        return false
    end
    visited["chimney"] = true
    if Tracker:FindObjectForCode("Chimney").Active then
        visited["chimney"] = false
        regionprint("Chimney is active!")
        return true
    end
    if gatelogic("Gate_Industrial-Chimney","Karma",3) and has_industrial_access() then
        visited["chimney"] = false
        regionprint("Chimney access from Industrial")
        Tracker:FindObjectForCode("Chimney").Active = true
        return true
    end
    if gatelogic("Gate_Drainage-Chimney","Karma",5) and has_drainage_access() and Tracker:FindObjectForCode("MSC").Active then
        visited["chimney"] = false
        regionprint("Chimney access from Drainage")
        Tracker:FindObjectForCode("Chimney").Active = true
        return true
    end
    if gatelogic("Gate_Chimney-Exterior","Karma",1) and has_exterior_access() and Tracker:FindObjectForCode("west").Active then
        visited["chimney"] = false
        regionprint("Chimney access from The Exterior")
        Tracker:FindObjectForCode("Chimney").Active = true
        return true
    end
    if gatelogic("Gate_Chimney-Sky_Islands","Karma",3) and has_sky_islands_access() then
        visited["chimney"] = false
        regionprint("Chimney access from Sky Islands")
        Tracker:FindObjectForCode("Chimney").Active = true
        return true
    end
    visited["chimney"] = false
    regionprint("Does NOT have Chimney access!")
    return false
end
function has_farm_arrays_access()
    regionprint("Checking Farm Arrays access...")
    if visited["farm"] then
        regionprint("Already in a Farm Arrays block!")
        return false
    end
    visited["farm"] = true
    if Tracker:FindObjectForCode("Farm").Active then
        visited["farm"] = false
        regionprint("Farm Arrays is active!")
        return true
    end
    if gatelogic("Gate_Outskirts-Farm_Arrays","Karma",5) and has_outskirts_access() then
        visited["farm"] = false 
        regionprint("Farm Arrays access from Outskirts")
        Tracker:FindObjectForCode("Farm").Active = true
        return true
    end
    if gatelogic("Gate_Farm_Arrays-Sky_Islands","Karma",3) and has_sky_islands_access() then
        visited["farm"] = false
        regionprint("Farm Arrays access from Sky Islands")
        Tracker:FindObjectForCode("Farm").Active = true
        return true
    end
    if gatelogic("Gate_Farm_Arrays-Subterranean","Karma",5) and has_subterranean_access() and Tracker:FindObjectForCode("saint") then
        visited["farm"] = false
        regionprint("Farm Arrays access from Subterranean")
        Tracker:FindObjectForCode("Farm").Active = true
        return true
    end
    visited["farm"] = false
    regionprint("Does NOT have Farm Arrays access!")
    return false
end
function has_subterranean_access()
    regionprint("Checking Subterranean access...")
    if visited["subterranean"] then
        regionprint("Already in a Subterranean block!")
        return false
    end
    visited["subterranean"] = true
    if Tracker:FindObjectForCode("Subterranean").Active then
        visited["subterranean"] = false
        regionprint("Subterranean is active!")
        return true
    end
    if gatelogic("Gate_Farm_Arrays-Subterranean","Karma",4) and has_farm_arrays_access() then
        visited["subterranean"] = false
        regionprint("Subterranean access from Farm Arrays")
        Tracker:FindObjectForCode("Subterranean").Active = true
        return true
    end
    if gatelogic("Gate_Subterranean-Outer_Expanse","Karma",5) and has_outer_expanse_access() then
        visited["subterranean"] = false
        regionprint("Subterranean access from Outer Expanse")
        Tracker:FindObjectForCode("Subterranean").Active = true
        return true
    end
    if gatelogic("Gate_Pipeyard-Subterranean","Karma",5) and has_pipeyard_access() and Tracker:FindObjectForCode("glow").Active then
        visited["subterranean"] = false
        regionprint("Subterranean access from Pipeyard")
        Tracker:FindObjectForCode("Subterranean").Active = true
        return true
    end
    if gatelogic("Gate_Subterranean-Shoreline","Karma",5) and (has_shoreline_access() or has_waterfront_access()) then
        visited["subterranean"] = false
        regionprint("Subterranean access from Shoreline")
        Tracker:FindObjectForCode("Subterranean").Active = true
        return true
    end
    if gatelogic("Gate_Subterranean-Drainage","Karma",4) and has_drainage_access() and Tracker:FindObjectForCode("glow").Active then
        visited["subterranean"] = false
        regionprint("Subterranean access from Drainage")
        Tracker:FindObjectForCode("Subterranean").Active = true
        return true
    end
    visited["subterranean"] = false
    regionprint("Does NOT have Subterranean access!")
    return false
end
function has_outer_expanse_access()
    regionprint("Checking Outer Expanse access...")
    if visited["outer"] then
        regionprint("Already in an Outer Expanse block!")
        return false
    end
    visited["outer"] = true
    if Tracker:FindObjectForCode("Outer").Active then
        visited["outer"] = false
        regionprint("Outer Expanse is active!")
        return true
    end
    if gatelogic("Gate_Subterranean-Outer_Expanse","Karma",2) and has_subterranean_access() then
        visited["outer"] = false
        regionprint("Outer Expanse access from Subterranean")
        Tracker:FindObjectForCode("Outer").Active = true
        return true
    end
    visited["outer"] = false
    regionprint("Does NOT have Outer Expanse access")
    return false
end
function has_drainage_access()
    regionprint("Checking Drainage access...")
    if visited["drainage"] then
        regionprint("Already in a Drainage block!")
        return false
    end
    visited["drainage"] = true
    if Tracker:FindObjectForCode("Drainage").Active then
        visited["drainage"] = false
        regionprint("Drainage is active!")
        return true
    end
    if gatelogic("Gate_Outskirts-Drainage","Karma",4) and has_outskirts_access() then
        visited["drainage"] = false
        regionprint("Drainage access from Outskirts")
        Tracker:FindObjectForCode("Drainage").Active = true
        return true
    end
    if gatelogic("Gate_Subterranean-Drainage","Karma",1) and has_subterranean_access() then 
        visited["drainage"] = false
        regionprint("Drainage access from Subterranean")
        Tracker:FindObjectForCode("Drainage").Active = true
        return true
    end
    if gatelogic("Gate_Drainage-Garbage","Karma",3) and has_garbage_access() then
        visited["drainage"] = false
        regionprint("Drainage access from Garbage")
        Tracker:FindObjectForCode("Drainage").Active = true
        return true
    end
    if gatelogic("Gate_Drainage-Chimney","Karma",3) and Tracker:FindObjectForCode("MSC").Active and has_chimney_access() then
        visited["drainage"] = false
        regionprint("Drainage access from Chimney")
        Tracker:FindObjectForCode("Drainage").Active = true
        return true
    end
    visited["drainage"] = false
    regionprint("Does NOT have Drainage access!")
    return false
end
function has_garbage_access()
    regionprint("Checking Garbage access...")
    if visited["garbage"] then
        regionprint("Already in a Garbage block!")
        return false
    end
    visited["garbage"] = true
    if Tracker:FindObjectForCode("Garbage").Active then
        visited["garbage"] = false
        regionprint("Garbage is active!")
        return true
    end
    if gatelogic("Gate_Industrial-Garbage","Karma",2) and has_industrial_access() then
        visited["garbage"] = false
        regionprint("Garbage access from Industrial")
        Tracker:FindObjectForCode("Garbage").Active = true
        return true
    end
    if gatelogic("Gate_Drainage-Garbage","Karma",1) and has_drainage_access() then
        visited["garbage"] = false
        regionprint("Garbage access from Drainage")
        Tracker:FindObjectForCode("Garbage").Active = true
        return true
    end
    if gatelogic("Gate_Garbage-Shoreline","Karma",2) and (has_shoreline_access() or has_waterfront_access()) then
        visited["garbage"] = false
        regionprint("Garbage access from Shoreline")
        Tracker:FindObjectForCode("Garbage").Active = true
        return true
    end
    if gatelogic("Gate_Garbage-Shaded","Karma",2) and ((Tracker:FindObjectForCode("MSC").Active and has_shaded_access()) or has_silent_access()) then
        visited["garbage"] = false
        regionprint("Garbage access from Shaded")
        Tracker:FindObjectForCode("Garbage").Active = true
        return true
    end
    visited["garbage"] = false
    regionprint("Does NOT have Garbage access!")
    return false
end
function has_shaded_access()
    regionprint("Checking Shaded access...")
    if Tracker:FindObjectForCode("saint").Active then
        regionprint("Shaded does not exist for Saint")
        return false
    end
    if visited["shaded"] then
        regionprint("Already in a Shaded block!")
        return false
    end
    visited["shaded"] = true
    if Tracker:FindObjectForCode("Shaded").Active then
        visited["shaded"] = false
        regionprint("Shaded is active!")
        return true
    end
    if gatelogic("Gate_Industrial-Shaded","Karma",5) and has_industrial_access() then
        visited["shaded"] = false
        regionprint("Shaded access from Industrial")
        Tracker:FindObjectForCode("Shaded").Active = true
        return true
    end
    if gatelogic("Gate_Garbage-Shaded","Karma",4) and Tracker:FindObjectForCode("MSC").Active and has_garbage_access() then
        visited["shaded"] = false
        regionprint("Shaded access from Garbage")
        Tracker:FindObjectForCode("Shaded").Active = true
        return true
    end
    if gatelogic("Gate_Shaded-Shoreline","Karma",2) and (has_shoreline_access() or has_waterfront_access()) then
        visited["shaded"] = false
        regionprint("Shaded access from Shoreline")
        Tracker:FindObjectForCode("Shaded").Active = true
        return true
    end
    if gatelogic("Gate_Shaded-Exterior","Karma",1) and has_exterior_access() and Tracker:FindObjectForCode("east").Active then 
        visited["shaded"] = false
        regionprint("Shaded access from The Exterior")
        Tracker:FindObjectForCode("Shaded").Active = true
        return true
    end
    visited["shaded"] = false
    regionprint("Does NOT have Shaded access!")
    return false
end
function has_exterior_access()
    regionprint("Checking Exterior access...")
    if Tracker:FindObjectForCode("saint").Active then
        regionprint("The Exterior does not exist for Saint")
        return false
    end
    if visited["exterior"] then
        regionprint("Already in an exterior block!")
        return false
    end
    visited["exterior"] = true
    if Tracker:FindObjectForCode("Exterior").Active then
        visited["exterior"] = false
        regionprint("Exterior is active!")
        return true
    end
    if gatelogic("Gate_Chimney-Exterior","Karma",4) and has_chimney_access() then
        visited["exterior"] = false
        regionprint("Exterior access from Chimney")
        Tracker:FindObjectForCode("Exterior").Active = true
        if Tracker:FindObjectForCode("riv").Active then
            Tracker:FindObjectForCode("west").Active = true
            Tracker:FindObjectForCode("wall").Active = true
        elseif (Tracker:FindObjectForCode("monk").Active and vanillagame) or (Tracker:FindObjectForCode("survivor").Active and vanillagame) then
            Tracker:FindObjectForCode("wall").Active = true
        else
            Tracker:FindObjectForCode("west").Active = true
            Tracker:FindObjectForCode("east").Active = true
            Tracker:FindObjectForCode("wall").Active = true
        end
        return true
    end
    if gatelogic("Gate_Wall-Metropolis","Karma",5) and has_metropolis_access() then 
        visited["exterior"] = false
        regionprint("Exterior access from Metropolis")
        Tracker:FindObjectForCode("Exterior").Active = true
        if Tracker:FindObjectForCode("riv").Active then
            Tracker:FindObjectForCode("west").Active = true
            Tracker:FindObjectForCode("wall").Active = true
        elseif (Tracker:FindObjectForCode("monk") and vanillagame) or (Tracker:FindObjectForCode("survivor").Active and vanillagame) then
            Tracker:FindObjectForCode("wall").Active = true
        else
            Tracker:FindObjectForCode("west").Active = true
            Tracker:FindObjectForCode("east").Active = true
            Tracker:FindObjectForCode("wall").Active = true
        end
        return true
    end
    if gatelogic("Gate_Wall-Five_Pebbles","Karma",1) and (has_five_pebbles_access() or has_rot_access()) then 
        visited["exterior"] = false
        regionprint("Wall access from Five Pebbles/The Rot")
        Tracker:FindObjectForCode("Exterior").Active = true
        if Tracker:FindObjectForCode("riv").Active then
            Tracker:FindObjectForCode("west").Active = true
            Tracker:FindObjectForCode("wall").Active = true
        elseif (Tracker:FindObjectForCode("monk") and vanillagame) or (Tracker:FindObjectForCode("survivor").Active and vanillagame) then
            Tracker:FindObjectForCode("wall").Active = true
        else
            Tracker:FindObjectForCode("west").Active = true
            Tracker:FindObjectForCode("east").Active = true
            Tracker:FindObjectForCode("wall").Active = true
        end
        return true
    end
    if gatelogic("Gate_Underhang-Five_Pebbles","Karma",1) and (has_five_pebbles_access() or has_rot_access()) then 
        visited["exterior"] = false
        regionprint("Underhang access from Five Pebbles/The Rot")
        Tracker:FindObjectForCode("Exterior").Active = true
        if Tracker:FindObjectForCode("riv").Active then
            Tracker:FindObjectForCode("west").Active = true
            Tracker:FindObjectForCode("wall").Active = true
        else
            Tracker:FindObjectForCode("west").Active = true
            Tracker:FindObjectForCode("east").Active = true
            Tracker:FindObjectForCode("wall").Active = true
        end
        return true
    end
    if gatelogic("Gate_Shaded-Exterior","Karma",1) and has_shaded_access() then 
        visited["exterior"] = false
        regionprint("Exterior access from Shaded")
        Tracker:FindObjectForCode("Exterior").Active = true
        if Tracker:FindObjectForCode("riv").Active then
            Tracker:FindObjectForCode("east").Active = true
        else
            Tracker:FindObjectForCode("west").Active = true
            Tracker:FindObjectForCode("east").Active = true
            Tracker:FindObjectForCode("wall").Active = true
        end
        return true
    end
    if gatelogic("Gate_Exterior-Precipice","Karma",1) and has_waterfront_access() then 
        visited["exterior"] = false
        regionprint("Exterior access from Waterfront")
        Tracker:FindObjectForCode("Exterior").Active = true
        Tracker:FindObjectForCode("west").Active = true
        Tracker:FindObjectForCode("east").Active = true
        Tracker:FindObjectForCode("wall").Active = true
        return true
    end
    visited["exterior"] = false
    regionprint("Does NOT have Exterior access!")
    return false
end
function has_five_pebbles_access()
    regionprint("Checking Five Pebbles access...")
    if Tracker:FindObjectForCode("riv").Active or Tracker:FindObjectForCode("saint").Active then
        regionprint("Five Pebbles collapsed")
        return false
    end
    if visited["5p"] then
        regionprint("Already in a Five Pebbles block!")
        return false
    end
    visited["5p"] = true
    if Tracker:FindObjectForCode("5P").Active then
        visited["5p"] = false
        regionprint("Five Pebbles is active!")
        return true
    end
    if gatelogic("Gate_Wall-Five_Pebbles","Karma",1) and has_exterior_access() and Tracker:FindObjectForCode("wall").Active then 
        visited["5p"] = false
        regionprint("5P access from The Wall")
        Tracker:FindObjectForCode("puppet").Active = true
        return true
    end
    if gatelogic("Gate_Underhang-Five_Pebbles","Karma",5) and Tracker:FindObjectForCode("west").Active then
        visited["5p"] = false
        regionprint("Five Pebbles access from Underhang")
        Tracker:FindObjectForCode("5P").Active = true
        return true
    end
    visited["5p"] = false
    regionprint("Does NOT have Five Pebbles access!")
    return false
end
function has_pipeyard_access()
    regionprint("Checking Pipeyard access...")
    if visited["pipes"] then
        regionprint("Already in a Pipeyard block!")
        return false
    end
    visited["pipes"] = true
    if Tracker:FindObjectForCode("Pipeyard").Active then
        visited["pipes"] = false
        regionprint("Pipeyard is active!")
        return true
    end
    if gatelogic("Gate_Industrial-Pipeyard","Karma",4) and has_industrial_access() then
        visited["pipes"] = false
        regionprint("Pipeyard access from Industrial")
        Tracker:FindObjectForCode("Pipeyard").Active = true
        return true
    end
    if gatelogic("Gate_Pipeyard-Subterranean","Karma",3) and has_subterranean_access() then 
        visited["pipes"] = false
        regionprint("Pipeyard access from Subterranean")
        Tracker:FindObjectForCode("Pipeyard").Active = true
        return true
    end
    if gatelogic("Gate_Pipeyard-Sky_Islands","Karma",3) and has_sky_islands_access() then 
        visited["pipes"] = false
        regionprint("Pipeyard access from Sky Islands")
        Tracker:FindObjectForCode("Pipeyard").Active = true
        return true
    end
    if gatelogic("Gate_Pipeyard-Shoreline","Karma",3) and (has_shoreline_access() or has_waterfront_access()) and (Tracker:FindObjectForCode("arti").Active == false) then 
        visited["pipes"] = false
        regionprint("Pipeyard access from Shoreline")
        Tracker:FindObjectForCode("Pipeyard").Active = true
        return true
    end
    visited["pipes"] = false
    regionprint("Does NOT have Pipeyard access!")
    return false
end
function has_sky_islands_access()
    regionprint("Checking Sky Islands access...")
    if visited["sky"] then
        regionprint("Already in a Sky Islands block!")
        return false
    end
    visited["sky"] = true
    if Tracker:FindObjectForCode("Sky").Active then
        visited["sky"] = false
        regionprint("Sky Islands is active!")
        return true
    end
    if gatelogic("Gate_Chimney-Sky_Islands","Karma",2) and has_chimney_access() then 
        visited["sky"] = false
        regionprint("Sky Islands access from Chimney")
        Tracker:FindObjectForCode("Sky").Active = true
        return true
    end
    if gatelogic("Gate_Pipeyard-Sky_Islands","Karma",4) and has_pipeyard_access() then
        visited["sky"] = false
        regionprint("Sky Islands access from Pipeyard")
        Tracker:FindObjectForCode("Sky").Active = true
        return true
    end
    if gatelogic("Gate_Farm_Arrays-Sky_Islands","Karma",3) and has_farm_arrays_access() then 
        visited["sky"] = false
        regionprint("Sky Islands access from Farm Arrays")
        Tracker:FindObjectForCode("Sky").Active = true
        return true
    end
    visited["sky"] = false
    regionprint("Does NOT have Sky Islands access!")
    return false
end
function has_shoreline_access()
    regionprint("Checking Shoreline access...")
    if Tracker:FindObjectForCode("spearmaster").Active or Tracker:FindObjectForCode("arti").Active then
        regionprint("Moon hasn't collapsed yet.")
        return false
    end
    if visited["shoreline"] then
        regionprint("Already in a Shoreline block!")
        return false
    end
    visited["shoreline"] = true
    if Tracker:FindObjectForCode("Shoreline").Active then
        visited["shoreline"] = false
        regionprint("Shoreline is active!")
        return true
    end
    if gatelogic("Gate_Garbage-Shoreline","Karma",3) and has_garbage_access() then 
        visited["shoreline"] = false
        regionprint("Shoreline access from Garbage")
        Tracker:FindObjectForCode("Shoreline").Active = true
        return true
    end
    if gatelogic("Gate_Pipeyard-Shoreline","Karma",3) and has_pipeyard_access() then 
        visited["shoreline"] = false
        regionprint("Shoreline access from Pipeyard")
        Tracker:FindObjectForCode("Shoreline").Active = true
        return true
    end
    if gatelogic("Gate_Subterranean-Shoreline","Karma",2) and has_subterranean_access() then 
        visited["shoreline"] = false
        regionprint("Shoreline access from Subterranean")
        Tracker:FindObjectForCode("Shoreline").Active = true
        return true
    end
    if gatelogic("Gate_Shaded-Shoreline","Karma",3) and has_shaded_access() then 
        visited["shoreline"] = false
        regionprint("Shoreline access from Shaded")
        Tracker:FindObjectForCode("Shoreline").Active = true
        return true
    end
    if gatelogic("Gate_Shoreline-Submerged_Superstructure","Karma",1) and has_submerged_access() then 
        visited["shoreline"] = false
        regionprint("Shoreline access from Submerged")
        Tracker:FindObjectForCode("Shoreline").Active = true
        return true
    end
    if gatelogic("Gate_Bitter_Aerie-Shoreline","Karma",5) and has_submerged_access() and Tracker:FindObjectForCode("riv").Active then 
        visited["shoreline"] = false
        regionprint("Shoreline access from Bitter Aerie")
        Tracker:FindObjectForCode("Shoreline").Active = true
        return true
    end
    if has_silent_access() and gatelogic("Gate_Shoreline-Silent_Construct","Karma",1) and Tracker:FindObjectForCode("saint").Active then
        visited["shoreline"] = false
        regionprint("Shoreline access from Silent")
        Tracker:FindObjectForCode("Shoreline").Active = true
        return true
    end
    visited["shoreline"] = false
    regionprint("Does NOT have Shoreline access!")
    return false
end
function has_submerged_access()
    regionprint("Checking Submerged access...")
    if Tracker:FindObjectForCode("spearmaster").Active or Tracker:FindObjectForCode("arti").Active then
        regionprint("Moon hasn't collapsed")
        return false
    end
    if visited["submerged"] then
        regionprint("Already in a Submerged block!")
        return false
    end
    visited["submerged"] = true
    if Tracker:FindObjectForCode("Submerged").Active then
        visited["submerged"] = false
        regionprint("Submerged is active!")
        return true
    end
    if gatelogic("Gate_Shoreline-Submerged_Superstructure","Karma",5) and has_shoreline_access() then
        visited["submerged"] = false
        regionprint("Submerged access from Shoerline")
        Tracker:FindObjectForCode("Submerged").Active = true
        return true
    end
    visited["submerged"] = false
    regionprint("Does NOT have Submerged access!")
    return false
end
function has_waterfront_access()
    regionprint("Checking Waterfront access...")
    if Tracker:FindObjectForCode("spearmaster").Active or Tracker:FindObjectForCode("arti").Active then
        if visited["water"] then
            regionprint("Already in a Waterfront block!")
            return false
        end
        visited["water"] = true
        if Tracker:FindObjectForCode("Waterfront").Active then
            visited["water"] = false
            regionprint("Waterfront is active!")
            return true
        end
        if has_exterior_access() and gatelogic("Gate_Exterior-Precipice","Karma",1) then 
            visited["water"] = false
            regionprint("Waterfront access from The Exterior")
            Tracker:FindObjectForCode("Waterfront").Active = true
            return true
        end
        if has_garbage_access() and gatelogic("Gate_Garbage-Shoreline","Karma",3) then 
            visited["water"] = false
            regionprint("Waterfront access from Garbage")
            Tracker:FindObjectForCode("Waterfront").Active = true
            return true
        end
        if has_shaded_access() and gatelogic("Gate_Shaded-Shoreline","Karma",3) then 
            visited["water"] = false
            regionprint("Waterfront access from Shaded")
            Tracker:FindObjectForCode("Waterfront").Active = true
            return true
        end
        if has_subterranean_access() and gatelogic("Gate_Subterranean-Shoreline","Karma",2) then 
            visited["water"] = false
            regionprint("Waterfront access from Subterranean")
            Tracker:FindObjectForCode("Waterfront").Active = true
            return true
        end
        if has_pipeyard_access() and gatelogic("Gate_Pipeyard-Shoreline","Karma",3) and (Tracker:FindObjectForCode("arti").Active == false) then 
            visited["water"] = false
            regionprint("Waterfront access from Pipeyard")
            Tracker:FindObjectForCode("Waterfront").Active = true
            return true
        end
        if gatelogic("Gate_Struts-Waterfront","Karma",1) and Tracker:FindObjectForCode("spearmaster").Active and has_lttm_access() then 
            visited["water"] = false
            regionprint("Waterfront access from The Struts")
            Tracker:FindObjectForCode("Waterfront").Active = true
            return true
        end
        if gatelogic("Gate_Precipice-LTTM","Karma",1) and Tracker:FindObjectForCode("spearmaster").Active and has_lttm_access() then 
            visited["water"] = false
            regionprint("Precipice access from Moon")
            Tracker:FindObjectForCode("Waterfront").Active = true
            return true
        end
        visited["water"] = false
        regionprint("Does NOT have Waterfront access!")
        return false
    else
        regionprint("Moon has collapsed!")
        return false
    end
end
function has_metro_access()
    regionprint("Checking Metropolis access...")
    if visited["metro"] then
        regionprint("Already in a Metro block")
        return false
    end
    visited["metro"] = true
    if Tracker:FindObjectForCode("Metro").Active then
        visited["metro"] = false
        regionprint("Metropolis is active!")
        return true
    end
    if gatelogic("Gate_Wall-Metropolis","drone",0) and Tracker:FindObjectForCode("arti").Active and has_exterior_access() then 
        visited["metro"] = false
        regionprint("Metropolis access from The Wall")
        Tracker:FindObjectForCode("Metro").Active = true
        return true
    end
    visited["metro"] = false
    regionprint("Does NOT have Metropolis access!")
    return false
end
function has_rot_access()
    regionprint("Checking Rot access...")
    if Tracker:FindObjectForCode("riv").Active then
        if visited["rot"] then
            regionprint("Already in a Rot block!")
            return false
        end
        visited["rot"] = true
        if Tracker:FindObjectForCode("Rot").Active then
            visited["rot"] = false
            regionprint("The Rot is Active!")
            return true
        end
        if has_exterior_access() and Tracker:FindObjectForCode("west").Active and (gatelogic("Gate_Wall-Five_Pebbles","Karma",1) or gatelogic("Gate_Underhang-Five_Pebbles","Karma",5)) then 
            visited["rot"] = false
            regionprint("Rot access from the Exterior")
            Tracker:FindObjectForCode("Rot").Active = true
            return true
        end
        visited["rot"] = false
        regionprint("Does NOT have Rot access!")
        return false
    else
        regionprint("Rot is Rivulet exclusive!")
        return false
    end
end
function has_lttm_access()
    regionprint("Checking LTTM access...")
    if Tracker:FindObjectForCode("spearmaster").Active then
        if visited["moon"] then
            regionprint("Already in a Moon block!")
            return false
        end
        visited["moon"] = true
        if Tracker:FindObjectForCode("Moon").Active then
            visited["moon"] = false
            regionprint("LTTM is active!")
            return true
        end
        if gatelogic("Gate_Struts-Waterfront","Karma",1) and has_waterfront_access() then 
            visited["moon"] = false
            regionprint("Moon access from Waterfront")
            Tracker:FindObjectForCode("Moon").Active = true
            return true
        end
        if gatelogic("Gate_Precipice-LTTM","Karma",5) and has_waterfront_access() then 
            visited["moon"] = false
            regionprint("Moon access from The Precipice")
            Tracker:FindObjectForCode("Moon").Active = true
            return true
        end
        visited["moon"] = false
        regionprint("Does NOT have Moon access!")
        return false
    else
        regionprint("LTTM is Spearmaster exclusive!")
        return false
    end
end
function has_silent_access()
    regionprint("Checking Silent Construct access...")
    if Tracker:FindObjectForCode("saint").Active then
        if visited["silent"] then
            regionprint("Already in a Silent block!")
            return false
        end
        visited["silent"] = true
        if Tracker:FindObjectForCode("Silent").Active then
            visited["silent"] = false
            regionprint("Silent Construct is active!")
            return true
        end
        if has_shoreline_access() and gatelogic("Gate_Shoreline-Silent_Construct","Karma",5) then 
            visited["silent"] = false
            regionprint("Silent access from Shoreline")
            Tracker:FindObjectForCode("Silent").Active = true
            return true
        end
        if gatelogic("Gate_Industrial-Shaded","Karma",5) and has_industrial_access() then 
            visited["silent"] = false
            regionprint("Silent access from Industrial")
            Tracker:FindObjectForCode("Silent").Active = true
            return true
        end
        if gatelogic("Gate_Garbage-Shaded","Karma",4) and has_garbage_access() then 
            visited["silent"] = false
            regionprint("Silent access from Garbage")
            Tracker:FindObjectForCode("Silent").Active = true
            return true
        end
        visited["silent"] = false
        regionprint("Does NOT have Silent access!")
        return false
    else
        regionprint("Silent Construct is Saint exclusive!")
        return false
    end
end
function has_rubicon_access()
    regionprint("Checking Rubicon access...")
    if has_subterranean_access() and (Tracker:FindObjectForCode("Karma").CurrentStage == 8) and Tracker:FindObjectForCode("saint").Active and Tracker:FindObjectForCode("glow").Active then 
        Tracker:FindObjectForCode("Rubicon").Active = true
        regionprint("Has Rubicon access")
        return true
    end
    regionprint("Does NOT have Rubicon access!")
    return false
end


--for determining how many wanderer pips you should have access to
function wanderer_pips(n)
    local pip = 0
    if has_outskirts_access() then
        pip = pip + 1
    end
    if has_industrial_access() then
        pip = pip + 1
    end
    if has_chimney_access() then
        pip = pip + 1
    end
    if has_farm_arrays_access() then
        pip = pip + 1
    end
    if has_subterranean_access() then
        pip = pip + 1
    end
    if has_outer_expanse_access() then
        pip = pip + 1
    end
    if has_drainage_access() then
        pip = pip + 1
    end
    if has_garbage_access() then
        pip = pip + 1
    end
    if has_shaded_access() then
        pip = pip + 1
    end
    if has_exterior_access() then
        pip = pip + 1
    end
    if has_five_pebbles_access() then
        pip = pip + 1
    end
    if has_pipeyard_access() then
        pip = pip + 1
    end
    if has_sky_islands_access() then
        pip = pip + 1
    end
    if has_shoreline_access() then
        pip = pip + 1
    end
    if has_metro_access() then
        pip = pip + 1
    end
    if has_submerged_access() then
        pip = pip + 1
    end
    if has_silent_access() then
        pip = pip + 1
    end
    if has_rot_access() then
        pip = pip + 1
    end
    if has_waterfront_access() then
        pip = pip + 1
    end
    if has_lttm_access() then
        pip = pip + 1
    end
    if has_rubicon_access() then
        pip = pip + 1
    end
    local counter = (pip >= tonumber(n))
    if counter then
        return true
    end
    return false
end

function nomadaccess()
    if wanderer_pips(nomadchecks) then
        return true
    else
        return false
    end
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
    if has_outskirts_access() then
        if Tracker:FindObjectForCode("mouth").Active then
            bluefruit = true
        end
        if Tracker:FindObjectForCode("monk").Active or Tracker:FindObjectForCode("survivor").Active or Tracker:FindObjectForCode("MSC").Active then
            popcorn = true
        end
    end
    if has_industrial_access() then
        if Tracker:FindObjectForCode("mouth").Active then
            bluefruit = true
            bubblefruit = true
        end
        popcorn = true
    end
    if has_chimney_access() then
        if Tracker:FindObjectForCode("mouth").Active then
            bluefruit = true
        end
    end
    if has_farm_arrays_access() then
        popcorn = true
        if Tracker:FindObjectForCode("mouth").Active then
            bluefruit = true
            if Tracker:FindObjectForCode("MSC").Active then
                gooieduck = true
            end
        end
    end
    if has_subterranean_access() then
        popcorn = true
        if Tracker:FindObjectForCode("mouth").Active then
            bluefruit = true
            bubblefruit = true
            if Tracker:FindObjectForCode("MSC").Active then
                gooieduck = true
            end
        end
    end
    if has_outer_expanse_access() then
        bluefruit = true
        gooieduck = true
    end
    if has_drainage_access() then
        if Tracker:FindObjectForCode("mouth").Active then
            bluefruit = true
            bubblefruit = true
            if Tracker:FindObjectForCode("MSC").Active then
                lilypuck = true
            end
        end
    end
    if has_garbage_access() then
        if Tracker:FindObjectForCode("mouth").Active then
            bluefruit = true
            bubblefruit = true
        end
        popcorn = true
    end
    if has_shaded_access() then
        if Tracker:FindObjectForCode("mouth").Active then
            bluefruit = true
            bubblefruit = true
            slime = true
            if Tracker:FindObjectForCode("MSC").Active and (Tracker:FindObjectForCode("monk").Active or Tracker:FindObjectForCode("survivor").Active or Tracker:FindObjectForCode("riv").Active) then
                lilypuck = true
            end
        end
    end
    if has_exterior_access() then
        if Tracker:FindObjectForCode("mouth").Active then
            bluefruit = true
            slime = true
        end
    end
    if has_five_pebbles_access() then
        neuron = true
        popcorn = true
    end
    if has_pipeyard_access() then
        if Tracker:FindObjectForCode("mouth").Active then
            bluefruit = true
            bubblefruit = true
            bubblefruit = true
            lilypuck = true
        end
        popcorn = true
    end
    if has_sky_islands_access() then
        if Tracker:FindObjectForCode("mouth").Active then
            bluefruit = true
            if Tracker:FindObjectForCode("MSC").Active then
                peach = true
            end
        end
        popcorn = true
    end
    if has_shoreline_access() then
        if Tracker:FindObjectForCode("mouth").Active then
            bluefruit = true
            bubblefruit = true
            if Tracker:FindObjectForCode("MSC").Active then
                glowweed = true
            end
        end
        if Tracker:FindObjectForCode("saint").Active then
            slime = true
        end
        popcorn = true
    end
    if has_metro_access() then
        bluefruit = true
        popcorn = true
        neuron = true
    end
    if has_submerged_access() then
        bluefruit = true
        bubblefruit = true
        glowweed = true
    end
    if has_silent_access() then
        bluefruit = true
        popcorn = true
        slime = true
    end
    if has_rot_access() then
        neuron = true
        popcorn = true
    end
    if has_waterfront_access() then
        if Tracker:FindObjectForCode("mouth").Active then
            bluefruit = true
            bubblefruit = true
        end
        popcorn = true
    end
    if has_lttm_access() then
        neuron = true
    end
    if has_rubicon_access() then
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
    local counter = (food >= tonumber(monkchecks))
    if counter then
        return true
    else
        return false
    end
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
    if has_outskirts_access() then
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
    if has_industrial_access() then
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
    if has_chimney_access() then
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
    if has_farm_arrays_access() then
        centipede = true
        vulturegrub = true
        noodlefly = true
        batfly = true
        hazer = true
        if Tracker:FindObjectForCode("mouth").Active then
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
    if has_subterranean_access() then
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
    if has_outer_expanse_access() then
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
    if has_drainage_access() then
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
    if has_garbage_access() then
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
                    if Tracker:FindObjectForCode("mouth").Active then
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
    if has_shaded_access() then
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
            if Tracker:FindObjectForCode("mouth").Active then
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
    if has_exterior_access() then
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
    if has_five_pebbles_access() then
        if Tracker:FindObjectForCode("crunch").Active then
            if Tracker:FindObjectForCode("spearmaster").Active then
                inspector = true
            else
                dll = true
            end
        end
    end
    if has_pipeyard_access() then
        batfly = true
        centipede = true
        if Tracker:FindObjectForCode("notriv").Active then
            if Tracker:FindObjectForCode("mouth").Active then
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
    if has_sky_islands_access() then
        if Tracker:FindObjectForCode("notriv").Active then
            noodlefly = true
        end
        batfly = true
        centiwing = true
        if Tracker:FindObjectForCode("mouth").Active then
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
    if has_shoreline_access() then
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
    if has_metro_access() then
        if Tracker:FindObjectForCode("mouth").Active then
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
    if has_submerged_access() then
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
    if has_waterfront_access() then
        snail = true
        jetfish = true
        jellyfish = true
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
        hazer = true
        if Tracker:FindObjectForCode("arti").Active then
            eggbugegg = true
        elseif Tracker:FindObjectForCode("spearmaster").Active then
            poleplant = true
            monsterkelp = true
            dll = true
        end
    end
    if has_lttm_access() then
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
    local counter = (food >= tonumber(hunterchecks))
    if counter then
        return true
    end
    return false
end

function dragonaccess()
    green = false
    pink = false
    blue = false
    white = false
    yellow = false
    black = false
    red = false
    cyan = false
    caramel = false
    strawberry = false
    if has_chimney_access() then
        if Tracker:FindObjectForCode("vanilla").Active then
            pink = true
            blue = true
            white = true
            if Tracker:FindObjectForCode("monk").Active then
                green = true
            end
        elseif Tracker:FindObjectForCode("MSC").Active then
            white = true
            if Tracker:FindObjectForCode("monk").Active or Tracker:FindObjectForCode("survivor").Active or Tracker:FindObjectForCode("hunter").Active or Tracker:FindObjectForCode("gourmand").Active then
                pink = true
                blue = true
                caramel = true
                if Tracker:FindObjectForCode("hunter").Active then
                    cyan = true
                end
            elseif Tracker:FindObjectForCode("arti").Active or Tracker:FindObjectForCode("spearmaster").Active then
                cyan = true
                pink = true
                blue = true
            elseif Tracker:FindObjectForCode("riv").Active then
                yellow = true
                blue = true
                caramel = true
                cyan = true
            elseif Tracker:FindObjectForCode("saint") then
                yellow = true
                strawberry = true
                cyan = true
            end
        end
    end
    if has_drainage_access() then
        if Tracker:FindObjectForCode("vanilla").Active then
            green = true
            if Tracker:FindObjectForCode("nothunter").Active then
                pink = true
            end
        elseif Tracker:FindObjectForCode("MSC").Active then
            green = true
            if Tracker:FindObjectForCode("monk").Active or Tracker:FindObjectForCode("survivor").Active or Tracker:FindObjectForCode("gourmand").Active then
                pink = true
            elseif Tracker:FindObjectForCode("hunter").Active or Tracker:FindObjectForCode("arti").Active or Tracker:FindObjectForCode("spearmaster").Active then
                cyan = true
            elseif tracker:FindObjectForCode("riv").Active then
                blue = true
            end
        end
    end
    if has_exterior_access() then
        white = true
        yellow = true
        blue = true
        if Tracker:FindObjectForCode("MSC").Active then
            if Tracker:FindObjectForCode("hunter").Active or Tracker:FindObjectForCode("arti").Active or Tracker:FindObjectForCode("spearmaster").Active then
                cyan = true
            end
        end
    end
    if has_farm_arrays_access() then
        if Tracker:FindObjectForCode("vanilla").Active then
            green = true
            blue = true
            if Tracker:FindObjectForCode("nothunter").Active then
                yellow = true
            else
                pink = true
            end
        elseif Tracker:FindObjectForCode("MSC").Active then
            if tracker:FindObjectForCode("notvegan").Active then
                blue = true
                if Tracker:FindObjectForCode("notriv").Active then
                    green = true
                end
            end
        end
    end
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
    if Tracker:FindObjectForCode("riv").Active then
        return true
    else
        if subchecks == 1 then
            return true
        else
            return false
        end
    end
end