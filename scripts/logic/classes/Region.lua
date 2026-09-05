Region = class()

-- Representation of a region. Contains the name, which gates lead into it, and any subregion splits.
--TODO: Add food and creatures contained in the region
function Region:init(name, gates, subregions)
    self.gates = {}
    self.subregions = {}
    self.name = name
    self.food = {}

    for _, gate in pairs(gates) do
        if gate.region1 == name or gate.region2 == name then
            table.insert(self.gates, gate)
        end
    end

    if subregions ~= nil then
        for _, subregion in pairs(subregions) do
            table.insert(self.subregions, subregion)
        end
    end
end

function Region:reset_region()
    if Tracker:FindObjectForCode(string.format("%s-spawn", self.name)).Active then
        Tracker:FindObjectForCode(string.format("%s-ool", self.name)).Active = true
        Tracker:FindObjectForCode(string.format("%s-access", self.name)).Active = true
    else
        Tracker:FindObjectForCode(string.format("%s-ool", self.name)).Active = false
        Tracker:FindObjectForCode(string.format("%s-access", self.name)).Active = false
    end

--TODO: Allow for spawning in a subregion
    for _, subregion in pairs(self.subregions or {}) do
        if Tracker:FindObjectForCode(string.format("%s-spawn", self.name)).Active then
            Tracker:FindObjectForCode(string.format("%s-ool", subregion.name)).Active = true
            Tracker:FindObjectForCode(string.format("%s-access", subregion.name)).Active = true
        elseif Tracker:FindObjectForCode(string.format("%s-spawn", subregion.name)).Active then
            Tracker:FindObjectForCode(string.format("%s-ool", subregion.name)).Active = true
            Tracker:FindObjectForCode(string.format("%s-access", subregion.name)).Active = true
        else
            Tracker:FindObjectForCode(string.format("%s-ool", subregion.name)).Active = false
            Tracker:FindObjectForCode(string.format("%s-access", subregion.name)).Active = false
        end
    end
end


-- Gets the current access level of a region. 0 = No access, 1 = Out of Logic access, 2 = Full access
function Region:get_access()
    if Tracker:FindObjectForCode(string.format("%s-spawn", self.name)).Active then
        return 2
    elseif Tracker:FindObjectForCode(string.format("%s-access", self.name)).Active then
        return 2
    elseif Tracker:FindObjectForCode(string.format("%s-ool", self.name)).Active then
        return 1
    else
        return 0
    end
end

-- Gets the current access level for the region from the source subregion. 0 = No access, 1 = Out of Logic access, 2 = Full access
function Region:get_subregion_access(source)
    if #self.subregions == 0 then
        return self:get_access()
    end
    
    local access = 0
    -- Get starting subregions
    for _, subregion in pairs(self.subregions) do
        local gates = subregion.gates
        if gates ~= nil and gates[source] then
            -- print("printing subregion gates:", subregion, source, SUB_REGIONS[subregion]:get_access(), math.max(access, SUB_REGIONS[subregion]:get_access()))
            access = math.max(access, subregion:get_access())
        end
    end

    return access
end

-- Increase the amount of access a region has
function Region:upgrade_access(access)
    if self:get_access() >= access then
        return
    end
    print(string.format("Setting region access for %s to stage %s", self.name, access))

    if access >= 2 then
        print(string.format("Giving full access to %s", self.name))
        Tracker:FindObjectForCode(string.format("%s-access", self.name)).Active = true
    end
    if access >= 1 then
        print(string.format("Giving partial access to %s", self.name))
        Tracker:FindObjectForCode(string.format("%s-ool", self.name)).Active = true
        Tracker:FindObjectForCode(string.format("%s-region", self.name)).Active = true
    end
end

function Region:get_gates(target)
    local gates = {}
    for _, gate in pairs(self.gates) do
        if gate.region1 == target or gate.region2 == target then
            table.insert(gates, gate) 
        end
    end
    return gates
end

-- Upgrades the access for the internal subregions and returns regions that can be accessed
function Region:compute_region(source, access)
    local temp_access = 0
    local subregion_access_override = {}
    -- There must be a better way to do this
    for _, gate in ipairs(self:get_gates(source)) do
        local gate_access = gate:check_access(source)
        subregion_access_override[gate:get_subregion_name(source) or source] = math.min(gate_access, access)
        temp_access = math.max(gate_access, temp_access)
    end
    access = math.min(temp_access, access)

    if access == 0 then
        return {}
    end
    if #self.subregions == 0 then
        for _, gate in ipairs(self.gates) do
            self:upgrade_access(access)
            return
        end
    end
    
    regionprint("Beginning region computation of:", source)
    for _, subregion in pairs(self.subregions) do
        local gates = subregion.gates
        if gates ~= nil and gates[source] then
            print("Doing bfs on", source, subregion, subregion_access_override[subregion])
            self:bfs(source, subregion, subregion_access_override[subregion] or access)
        end
    end
    regionprint("Finished region computation of:", source)
end

-- For use within the Region function.
function Region:bfs(source, subregion, access)
    -- Another BFS search. Might try to combine with the upper BFS if I can.
    local SubregionQueue = Queue.new()
    local checked = {}
    
    Queue.pushright(SubregionQueue, {nil, subregion})

    repeat
        local t = Queue.popleft(SubregionQueue)
        local prev_subregion_name = t[1]
        local current_subregion = t[2]
        
        if checked[current_subregion.name] == nil then
            local access_level = access
            checked[current_subregion.name] = access_level
            if current_subregion:get_access() < access_level then
                local movements = current_subregion:get_applicable_movement(prev_subregion_name)
                for _, movement in pairs(movements) do
                    access_level = math.min(access_level, movement:check_access(prev_subregion_name) or access_level)
                end
                if prev_subregion_name == nil or (#movements ~= 0 and access_level ~= 0) then
                    self:upgrade_access(access_level)
                    current_subregion:upgrade_access(access_level)
                    for _, connected_subregion in pairs(current_subregion.connected_regions) do
                        Queue.pushright(SubregionQueue, {current_subregion.name, self:get_subregion(connected_subregion)})
                    end
                end
            end
        end
    until Queue.isempty(SubregionQueue)
end

function Region:get_subregion(name)
    for _, subregion in ipairs(self.subregions) do
        if subregion.name == name then
            return subregion
        end
    end
end

function Region:add_food(food)
    self.food[food] = true
end