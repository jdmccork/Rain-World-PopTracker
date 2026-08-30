SubRegion = class()

function SubRegion:init(name, movement, gates)
    self.movement = {}
    self.name = name
    self.gates = gates

    self.connected_regions = {}

    for _, move in pairs(movement) do
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

-- Increase the amount of access a region has
function SubRegion:upgrade_access(access)
    if self:get_access() >= access then
        return
    end
    print(string.format("Setting subregion access for %s to stage %s", self.name, access))

    if access >= 2 then
        print(string.format("Giving full access to %s", self.name))
        Tracker:FindObjectForCode(string.format("%s-access", self.name)).Active = true
        Tracker:FindObjectForCode(string.format("%s-ool", self.name)).Active = true
    end
    if access == 1 then
        print(string.format("Giving partial access to %s", self.name))
        Tracker:FindObjectForCode(string.format("%s-ool", self.name)).Active = true
    end
end

function SubRegion:get_applicable_movement(source)
    local result = {}
    for _, move in ipairs(self.movement) do
        if move:is_applicable(source) then
            table.insert(result, move)
            print("Adding to applicable movements")
        end
    end
    return result
end