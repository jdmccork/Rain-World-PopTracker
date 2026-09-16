Region = class()

-- Representation of a region. Contains the name, which gates lead into it, and any subregion splits.
--TODO: Add food and creatures contained in the region
function Region:init(name, gates, subregions)
    self.gates = {}
    self.subregions = {}
    self.name = name

    local connected_regions = {}

    for _, gate in pairs(gates) do
        if gate.region1 == name then
            table.insert(self.gates, gate)
            connected_regions[gate.region2] = true
        elseif gate.region2 == name then
            table.insert(self.gates, gate)
            connected_regions[gate.region1] = true
        end
    end

    -- Set subregions or create subregion if no subregions are definied to simplify logic
    if subregions ~= nil then
        for _, subregion in pairs(subregions) do
            self.subregions[subregion.name] = subregion
        end
    else
        self.subregions[self.name] = SubRegion:new(self.name, nil, connected_regions)
    end
end

function Region:reset_region()
    for _, subregion in pairs(self.subregions or {}) do
        if subregion:get_access() ~= 3 then
            Tracker:FindObjectForCode(string.format("%s", subregion.name)).CurrentStage = 0
        end
    end
end

-- Gets the highest level of access for the region. 0 = No access, 1 = Out of Logic access, 2 = Full access
function Region:get_access()
    local access = 0
    for _, subregion in pairs(self.subregions) do
        access = math.max(access, subregion:get_access())
    end
end

-- Gets the current access level for the region from the source subregion. 0 = No access, 1 = Out of Logic access, 2 = Full access
function Region:get_subregion_access(source)
    local access = 0
    -- Get starting subregions
    for _, subregion in pairs(self.subregions) do
        local gates = subregion.gates
        if gates ~= nil and gates[source] then
            access = math.max(access, subregion:get_access())
        end
    end
    return access
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
---@param source string: The name of the region that the slugcat is travelling from
---@param access number: The maximum access the region can have
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
    
    regionprint("Beginning region computation of:", source)
    for _, subregion in pairs(self.subregions) do
        local gates = subregion.gates
        if gates ~= nil and gates[source] then
            print("Doing bfs on", source, subregion, subregion_access_override[subregion.name])
            self:bfs(source, subregion, subregion_access_override[subregion.name] or access)
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
            local access_level = checked[prev_subregion_name] or access
            if current_subregion:get_access() < access_level then
                local movements = current_subregion:get_applicable_movement(prev_subregion_name)
                for _, movement in pairs(movements) do
                    access_level = math.min(access_level, movement:check_access(prev_subregion_name))
                end
                
                if prev_subregion_name == nil or (#movements ~= 0 and access_level ~= 0) then
                    current_subregion:upgrade_access(access_level)
                    for _, connected_subregion in pairs(current_subregion.connected_regions) do
                        Queue.pushright(SubregionQueue, {current_subregion.name, self:get_subregion(connected_subregion)})
                    end
                end
            end
            checked[current_subregion.name] = access_level
        end
    until Queue.isempty(SubregionQueue)
end

function Region:get_subregion(name)
    return self.subregions[name]
end
