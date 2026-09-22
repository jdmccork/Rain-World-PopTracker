SubRegion = class()

--- Creates the SubRegion node. This holds the paths that can be traveled along to reach another node.
---@param name string : The name of the subregion
---@param movement table : A list of all movements
---@param parent string : The name of the region that this subregion is in
function SubRegion:init(name, movement, parent)
    self.movement = {}
    self.name = name
    self.parent = parent

    self.connected_regions = {}

    for _, move in pairs(movement or {}) do
        if move.region1 == name then
            table.insert(self.movement, move)
            table.insert(self.connected_regions, move.region2)
        elseif move.region2 == name then
            table.insert(self.movement, move)
            table.insert(self.connected_regions, move.region1)
        end
    end
end

-- Gets the current access level of a region. 0 = No access, 1 = Out of Logic access, 2 = Full access
function SubRegion:get_access()
    return Tracker:FindObjectForCode(string.format("%s", self.name)).CurrentStage
end

-- Increase the amount of access a region has. Can only upgrade to in logic. Use set_spawn to increase past this point.
function SubRegion:upgrade_access(access)
    access = math.min(access, 2)
    if self:get_access() >= access then
        return
    end
    print(string.format("Setting subregion access for %s to stage %s", self.name, access))

    Tracker:FindObjectForCode(string.format("%s", self.name)).CurrentStage = access
    Tracker:FindObjectForCode(string.format("%s", self.parent)).CurrentStage = math.max(access, Tracker:FindObjectForCode(string.format("%s", self.parent)).CurrentStage)
end

function SubRegion:reset_region()
    if self:get_access() ~= 3 then
        Tracker:FindObjectForCode(string.format("%s", self.name)).CurrentStage = 0
        Tracker:FindObjectForCode(string.format("%s", self.parent)).CurrentStage = 0
        return 0
    end
    return 3
end

function SubRegion:set_spawn()
    Tracker:FindObjectForCode(string.format("%s", self.name)).CurrentStage = 3
    Tracker:FindObjectForCode(string.format("%s", self.parent)).CurrentStage = 3
end

function SubRegion:get_applicable_movement()
    local result = {}
    for _, move in ipairs(self.movement) do
        if move:is_applicable(self.name) then
            table.insert(result, move)
        end
    end
    return result
end