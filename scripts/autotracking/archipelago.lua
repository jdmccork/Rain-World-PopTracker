-- this is an example/default implementation for AP autotracking
-- it will use the mappings defined in item_mapping.lua and location_mapping.lua to track items and locations via their ids
-- it will also keep track of the current index of on_item messages in CUR_INDEX
-- addition it will keep track of what items are local items and which one are remote using the globals LOCAL_ITEMS and GLOBAL_ITEMS
-- this is useful since remote items will not reset but local items might
-- if you run into issues when touching A LOT of items/locations here, see the comment about Tracker.AllowDeferredLogicUpdate in autotracking.lua
ScriptHost:LoadScript("scripts/autotracking/spawn_table.lua")
ScriptHost:LoadScript("scripts/autotracking/map_switching.lua")
ScriptHost:LoadScript("scripts/autotracking/item_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/location_mapping.lua")

CUR_INDEX = -1
LOCAL_ITEMS = {}
GLOBAL_ITEMS = {}

-- resets an item to its initial state
function resetItem(item_code, item_type)
	local obj = Tracker:FindObjectForCode(item_code)
	if obj then
		item_type = item_type or obj.Type
		if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
			print(string.format("resetItem: resetting item %s of type %s", item_code, item_type))
		end
		if item_type == "toggle" or item_type == "toggle_badged" then
			obj.Active = false
		elseif item_type == "progressive" or item_type == "progressive_toggle" then
			obj.CurrentStage = 0
			obj.Active = false
		elseif item_type == "consumable" then
			obj.AcquiredCount = 0
		elseif item_type == "custom" then
			-- your code for your custom lua items goes here
		elseif item_type == "static" and AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
			print(string.format("resetItem: tried to reset static item %s", item_code))
		elseif item_type == "composite_toggle" and AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
			print(string.format(
				"resetItem: tried to reset composite_toggle item %s but composite_toggle cannot be accessed via lua." ..
				"Please use the respective left/right toggle item codes instead.", item_code))
		elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
			print(string.format("resetItem: unknown item type %s for code %s", item_type, item_code))
		end
	elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
		print(string.format("resetItem: could not find item object for code %s", item_code))
	end
end

-- advances the state of an item
function incrementItem(item_code, item_type, multiplier)
	local obj = Tracker:FindObjectForCode(item_code)
	if obj then
		item_type = item_type or obj.Type
		if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
			print(string.format("incrementItem: code: %s, type %s", item_code, item_type))
		end
		if item_type == "toggle" or item_type == "toggle_badged" then
			obj.Active = true
		elseif item_type == "progressive" or item_type == "progressive_toggle" then
			if obj.Active then
				obj.CurrentStage = obj.CurrentStage + 1
			else
				obj.Active = true
			end
		elseif item_type == "consumable" then
			obj.AcquiredCount = obj.AcquiredCount + obj.Increment * multiplier
		elseif item_type == "custom" then
			-- your code for your custom lua items goes here
		elseif item_type == "static" and AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
			print(string.format("incrementItem: tried to increment static item %s", item_code))
		elseif item_type == "composite_toggle" and AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
			print(string.format(
				"incrementItem: tried to increment composite_toggle item %s but composite_toggle cannot be access via lua." ..
				"Please use the respective left/right toggle item codes instead.", item_code))
		elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
			print(string.format("incrementItem: unknown item type %s for code %s", item_type, item_code))
		end
	elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
		print(string.format("incrementItem: could not find object for code %s", item_code))
	end
end

-- apply everything needed from slot_data, called from onClear
function apply_slot_data(slot_data)
	if slot_data["checks_flowersanity"] == 1 then
		Tracker:FindObjectForCode("flowerchecks").Active = true
	end
	if slot_data["checks_devtokens"] == 1 then
		Tracker:FindObjectForCode("devchecks").Active = true
	end
	if slot_data["which_gate_behavior"] == 0 then
		gatelogic = onlygate
		Tracker:FindObjectForCode("onlygate").Active = true
		Tracker:FindObjectForCode("gateandkarma").Active = false
		Tracker:FindObjectForCode("gateorkarma").Active = false
		Tracker:FindObjectForCode("onlykarma").Active = false
	elseif slot_data["which_gate_behavior"] == 1 then
		gatelogic = gateandkarma
		Tracker:FindObjectForCode("onlygate").Active = false
		Tracker:FindObjectForCode("gateandkarma").Active = true
		Tracker:FindObjectForCode("gateorkarma").Active = false
		Tracker:FindObjectForCode("onlykarma").Active = false
	elseif slot_data["which_gate_behavior"] == 2 then
		gatelogic = gateorkarma
		Tracker:FindObjectForCode("onlygate").Active = false
		Tracker:FindObjectForCode("gateandkarma").Active = false
		Tracker:FindObjectForCode("gateorkarma").Active = true
		Tracker:FindObjectForCode("onlykarma").Active = false
	elseif slot_data["which_gate_behavior"] == 3 then
		gatelogic = onlykarma
		Tracker:FindObjectForCode("onlygate").Active = false
		Tracker:FindObjectForCode("gateandkarma").Active = false
		Tracker:FindObjectForCode("gateorkarma").Active = false
		Tracker:FindObjectForCode("onlykarma").Active = true
	end
	
	if slot_data["which_campaign"] == "Yellow" then
		CURRENT_CAMPAIGN = 0
		Tracker:FindObjectForCode("nothunter").Active = true
	elseif slot_data["which_campaign"] == "White" then
		CURRENT_CAMPAIGN = 1
		Tracker:FindObjectForCode("nothunter").Active = true
	elseif slot_data["which_campaign"] == "Red" then
		CURRENT_CAMPAIGN = 2
	elseif slot_data["which_campaign"] == "Gourmand" then
		CURRENT_CAMPAIGN = 3
		Tracker:FindObjectForCode("nothunter").Active = true
	elseif slot_data["which_campaign"] == "Artificer" then
		CURRENT_CAMPAIGN = 4
		Tracker:FindObjectForCode("nothunter").Active = true
	elseif slot_data["which_campaign"] == "Rivulet" then
		CURRENT_CAMPAIGN = 5
		Tracker:FindObjectForCode("nothunter").Active = true
	elseif slot_data["which_campaign"] == "Spear" then
		CURRENT_CAMPAIGN = 6
		Tracker:FindObjectForCode("nothunter").Active = true
	elseif slot_data["which_campaign"] == "Saint" then
		CURRENT_CAMPAIGN = 7
		Tracker:FindObjectForCode("nothunter").Active = true
	elseif slot_data["which_campaign"] == "Sofanthiel" then
		CURRENT_CAMPAIGN = 8
		Tracker:FindObjectForCode("nothunter").Active = true
	elseif slot_data["which_campaign"] == "Watcher" then
		CURRENT_CAMPAIGN = 9
		Tracker:FindObjectForCode("nothunter").Active = true
	end
	
	local vanillagame = nil
	local vanillaneeded = nil
	if CURRENT_CAMPAIGN <= 2 then
		if slot_data["is_msc_enabled"] == 0 then
			vanillagame = true
		end
		vanillaneeded = true
	end
	if vanillaneeded then
		if vanillagame then
			CAMPAIGN_NAMING[CURRENT_CAMPAIGN] = string.format("Vanilla %s", CAMPAIGN_NAMING[CURRENT_CAMPAIGN])
		else
			CAMPAIGN_NAMING[CURRENT_CAMPAIGN] = string.format("MSC %s", CAMPAIGN_NAMING[CURRENT_CAMPAIGN])
		end
	end
	Tracker:UiHint("ActivateTab", CAMPAIGN_NAMING[CURRENT_CAMPAIGN])
	if slot_data["is_msc_enabled"] == 1 and Tracker:FindObjectForCode("MSC").Active == false then
		Tracker:FindObjectForCode("MSC").Active = true
	elseif slot_data["is_msc_enabled"] == 0 then
		Tracker:FindObjectForCode("vanilla").Active = false
	end
	if slot_data["checks_sheltersanity"] == 1 then
		Tracker:FindObjectForCode("sheltersanity").Active = true
	end
	if slot_data["difficulty_glow"] == 0 then
		Tracker:FindObjectForCode("glow-option").Active = true
	end
	Tracker:FindObjectForCode("scug").CurrentStage = CURRENT_CAMPAIGN
	if CURRENT_CAMPAIGN == 4 or CURRENT_CAMPAIGN == 6 then
		Tracker:FindObjectForCode("WaterMap").CurrentStage = 1
		Tracker:FindObjectForCode("Gate_UpperMoon-WaterMap").CurrentStage = 1
		Tracker:FindObjectForCode("Gate_LowerMoon-WaterMap").CurrentStage = 1
	end
	if CURRENT_CAMPAIGN == 2 or CURRENT_CAMPAIGN == 3 or CURRENT_CAMPAIGN == 4 or CURRENT_CAMPAIGN == 6 then
		Tracker:FindObjectForCode("crunch").Active = true
	end
	if CURRENT_CAMPAIGN ~= 4 then
		Tracker:FindObjectForCode("notarti").Active = true
	end
	if CURRENT_CAMPAIGN ~= 6 then
		Tracker:FindObjectForCode("mouth").Active = true
	end
	if CURRENT_CAMPAIGN == 5 then
		Tracker:FindObjectForCode("Pebbsi").CurrentStage = 1
		Tracker:FindObjectForCode("Gate_Wall-Pebbsi").CurrentStage = 1
		Tracker:FindObjectForCode("Gate_Underhang-Pebbsi").CurrentStage = 1
	else
		Tracker:FindObjectForCode("notriv").Active = true
	end
	if CURRENT_CAMPAIGN == 7 then
		Tracker:FindObjectForCode("Gate_WaterMap-Pebbs").CurrentStage = 1
		Tracker:FindObjectForCode("Drainage").CurrentStage = 1
		Tracker:FindObjectForCode("Castle").CurrentStage = 1
	else
		Tracker:FindObjectForCode("notvegan").Active = true
	end
	local spawn = SPAWN_TABLE[string.upper(slot_data["starting_room"])]
	local name = SPAWN_NAMING[spawn]
	if spawn then
		print(string.format("%s is the starting region",spawn))
		print(string.format("%s is the full name of starting region", name))
		Tracker:FindObjectForCode(spawn).Active = true
		if CURRENT_CAMPAIGN == 7 and SAINT_TABLE[name] then
			Tracker:UiHint("ActivateTab", SAINT_TABLE[name])
		elseif CURRENT_CAMPAIGN == 8 and INV_TABLE[name] then
			Tracker:UiHint("ActivateTab", INV_TABLE[name])
		else
			Tracker:UiHint("ActivateTab", name)
		end
	else
		print("Default spawn")
		if CURRENT_CAMPAIGN == 0 or CURRENT_CAMPAIGN == 1 then
			Tracker:FindObjectForCode("Outskirts").Active = true
			Tracker:UiHint("ActivateTab","Outskirts")
		elseif CURRENT_CAMPAIGN == 2 then
			Tracker:FindObjectForCode("Farm").Active = true
			Tracker:UiHint("ActivateTab","Farm Arrays")
		elseif CURRENT_CAMPAIGN == 3 then
			Tracker:FindObjectForCode("Shaded").Active = true
			Tracker:UiHint("ActivateTab","Shaded Citadel")
		elseif CURRENT_CAMPAIGN == 4 then
			Tracker:FindObjectForCode("Garbage").Active = true
			Tracker:UiHint("ActivateTab","Garbage Wastes")
		elseif CURRENT_CAMPAIGN == 5 then
			Tracker:FindObjectForCode("Drainage").Active = true
			Tracker:UiHint("ActivateTab","Drainage System")
		elseif CURRENT_CAMPAIGN == 6 then
			Tracker:FindObjectForCode("Outskirts").Active = true
			Tracker:FindObjectForCode("early").Active = true
			Tracker:UiHint("ActivateTab","Outskirts")
		elseif CURRENT_CAMPAIGN == 7 then
			Tracker:FindObjectForCode("Sky").Active = true
			Tracker:UiHint("ActivateTab","Sky Islands")
		elseif CURRENT_CAMPAIGN == 8 then
			Tracker:FindObjectForCode("Shaded").Active = true
			Tracker:UiHint("ActivateTab","Shaded Citadel")
		end
	end
	monkchecks = slot_data["difficulty_monk"]
	hunterchecks = slot_data["difficulty_hunter"]
	chieftainchecks = slot_data["difficulty_chieftain"]
	nomadchecks = slot_data["difficulty_nomad"]
	outlawchecks = slot_data["difficulty_outlaw"]
	echochecks = slot_data["difficulty_echo_low_karma"]
	subchecks = slot_data["checks_submerged"]
end

-- called right after an AP slot is connected
function onClear(slot_data)
	-- use bulk update to pause logic updates until we are done resetting all items/locations
	slot_name = string.format("RW_%s_room", Archipelago:GetPlayerAlias(Archipelago.PlayerNumber))
	Tracker.BulkUpdate = true	
	if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
		print(string.format("called onClear, slot_data:\n%s", dump_table(slot_data)))
	end
	CUR_INDEX = -1
	-- reset locations
	for _, mapping_entry in pairs(LOCATION_MAPPING) do
		for _, location_table in ipairs(mapping_entry) do
			for _, location_code in ipairs(mapping_entry) do
				if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
					print(string.format("onClear: clearing location %s", location_code))
				end
				if location_code:sub(1, 1) == "@" then
					local obj = Tracker:FindObjectForCode(location_code)
					if obj then
						obj.AvailableChestCount = obj.ChestCount
					elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
						print(string.format("onClear: could not find location object for code %s", location_code))
					end
				else
					-- reset hosted item
					local item_type = location_table[2]
					resetItem(location_code, item_type)
				end
			end	
		end
	end
	-- reset items
	for _, item_table in pairs(ITEM_MAPPING) do
		local item_code = item_table[1]
		local item_type = item_table[2]
		if item_code then
			resetItem(item_code, item_type)
			print(string.format("onClear: clearing item %s", item_code))
		elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
			print(string.format("onClear: skipping item_table with no item_code: %s",item_table))
		end
	end
	for _, dummy_table in pairs(DUMMYITEMS) do
		local dummy_code = dummy_table[1]
		local dummy_type = dummy_table[2]
		if dummy_code then
			resetItem(dummy_code,dummy_type)
			print(string.format("onClear: clearing dummy item %s", dummy_code))
		elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
			print(string.format("onClear: skipping dummy_table with no dummy_code: %s", dummy_table))
		end
	end
	apply_slot_data(slot_data)
	LOCAL_ITEMS = {}
	GLOBAL_ITEMS = {}
	-- manually run snes interface functions after onClear in case we need to update them (i.e. because they need slot_data)
	if PopVersion < "0.20.1" or AutoTracker:GetConnectionState("SNES") == 3 then
		-- add snes interface functions here
	end
	Tracker.BulkUpdate = false
end

-- called when an item gets collected
function onItem(index, item_id, item_name, player_number)
	if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
		print(string.format("called onItem: %s, %s, %s, %s, %s", index, item_id, item_name, player_number, CUR_INDEX))
	end
	if not AUTOTRACKER_ENABLE_ITEM_TRACKING then
		return
	end
	if index <= CUR_INDEX then
		return
	end
	local is_local = player_number == Archipelago.PlayerNumber
	CUR_INDEX = index;
	local item_table = ITEM_MAPPING[item_id]
	if not item_table then
		if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
			print(string.format("onItem: could not find item mapping for id %s", item_id))
		end
		return
	else
		local item_code = item_table[1]
		local item_type = item_table[2]
		local multiplier = item_table[3] or 1
		if item_code then
			incrementItem(item_code, item_type, multiplier)
			-- keep track which items we touch are local and which are global
			if is_local then
				if LOCAL_ITEMS[item_code] then
					LOCAL_ITEMS[item_code] = LOCAL_ITEMS[item_code] + 1
				else
					LOCAL_ITEMS[item_code] = 1
				end
			else
				if GLOBAL_ITEMS[item_code] then
					GLOBAL_ITEMS[item_code] = GLOBAL_ITEMS[item_code] + 1
				else
					GLOBAL_ITEMS[item_code] = 1
				end
			end
		elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
			print(string.format("onItem: skipping empty item_table"))
		end
	end
	if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
		print(string.format("local items: %s", dump_table(LOCAL_ITEMS)))
		print(string.format("global items: %s", dump_table(GLOBAL_ITEMS)))
	end
	-- track local items via snes interface
	if PopVersion < "0.20.1" or AutoTracker:GetConnectionState("SNES") == 3 then
		-- add snes interface functions for local item tracking here
	end
	if (Tracker:FindObjectForCode("Gate_Shaded-Shoreline").Active or Tracker:FindObjectForCode("Gate_Shoreline-Silent_Construct").Active) and (Tracker:FindObjectForCode("Gate_WaterMap-Pebbs").Active == false) then
		Tracker:FindObjectForCode("Gate_WaterMap-Pebbs").Active = true
	end
	if (Tracker:FindObjectForCode("Gate_Precipice-LTTM").Active or Tracker:FindObjectForCode("Gate_Bitter_Aerie-Shoreline").Active) and (Tracker:FindObjectForCode("Gate_UpperMoon-WaterMap").Active == false) then
		Tracker:FindObjectForCode("Gate_UpperMoon-WaterMap").Active = true
	end
	if (Tracker:FindObjectForCode("Gate_Struts-Waterfront").Active or Tracker:FindObjectForCode("Gate_Shoreline-Submerged_Superstructure").Active) and (Tracker:FindObjectForCode("Gate_LowerMoon-WaterMap").Active == false) then
		Tracker:FindObjectForCode("Gate_LowerMoon-WaterMap").Active = true
	end
	if Tracker:FindObjectForCode("Gate_Wall-Five_Pebbles").Active and (Tracker:FindObjectForCode("Gate_Wall-Pebbsi").Active == false) then
		Tracker:FindObjectForCode("Gate_Wall-Pebbsi").Active = true
	end
	if Tracker:FindObjectForCode("Gate_Underhang-Five_Pebbles").Active and (Tracker:FindObjectForCode("Gate_Underhang-Pebbsi").Active == false) then
		Tracker:FindObjectForCode("Gate_Underhang-Pebbsi").Active = true
	end
end

-- called when a location gets cleared
function onLocation(location_id, location_name)
	if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
		print(string.format("called onLocation: %s, %s", location_id, location_name))
	end
	if not AUTOTRACKER_ENABLE_LOCATION_TRACKING then
		return
	end
	local mapping_entry = LOCATION_MAPPING[location_id]
	if not mapping_entry then
		if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
			print(string.format("onLocation: could not find location mapping for id %s", location_id))
		end
		return
	end
	for _, location_table in pairs(mapping_entry) do
		for _, location_code in pairs(mapping_entry) do
			local obj = Tracker:FindObjectForCode(location_code)
			if obj then
				if location_code:sub(1, 1) == "@" then
					obj.AvailableChestCount = obj.AvailableChestCount - 1
				else
					-- increment hosted item
					local item_type = location_table[2]
					incrementItem(location_code, item_type)
				end
			elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
				print(string.format("onLocation: could not find object for code %s", location_code))
			end
		end
	end
end

-- called when a locations is scouted
function onScout(location_id, location_name, item_id, item_name, item_player)
	if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
		print(string.format("called onScout: %s, %s, %s, %s, %s", location_id, location_name, item_id, item_name,
			item_player))
	end
	-- not implemented yet :(
end

-- called when a bounce message is received
function onBounce(json)
	print(string.format("called onBounce: %s", dump_table(json)))
	-- your code goes here
	local roomid = nil
	slot_name, roomid = next(json.data)
	CURRENT_ROOM = string.lower(json.data[slot_name])
	print(string.format(CURRENT_ROOM))
	if CAMPAIGN_NAMING[CURRENT_CAMPAIGN] == "Saint" and SAINT_TABLE[TABS_MAPPING[CURRENT_ROOM]] ~= nil then
		roomid = string.format(SAINT_TABLE[TABS_MAPPING[CURRENT_ROOM]])
	else
		roomid = string.format(TABS_MAPPING[CURRENT_ROOM])
	end
	if CAMPAIGN_NAMING[CURRENT_CAMPAIGN] == "Inv" and INV_TABLE[TABS_MAPPING[CURRENT_ROOM]] ~= nil then
		roomid = string.format(INV_TABLE[TABS_MAPPING[CURRENT_ROOM]])
	else
		roomid = string.format(TABS_MAPPING[CURRENT_ROOM])
	end
	Tracker:UiHint("ActivateTab", CAMPAIGN_NAMING[CURRENT_CAMPAIGN])
	Tracker:UiHint("ActivateTab", roomid)
end

-- add AP callbacks
-- un-/comment as needed
Archipelago:AddClearHandler("clear handler", onClear)
if AUTOTRACKER_ENABLE_ITEM_TRACKING then
	Archipelago:AddItemHandler("item handler", onItem)
end
if AUTOTRACKER_ENABLE_LOCATION_TRACKING then
	Archipelago:AddLocationHandler("location handler", onLocation)
end
-- Archipelago:AddScoutHandler("scout handler", onScout)
Archipelago:AddBouncedHandler("bounce handler", onBounce)
