Gate = class()

-- Couldn't figure out sub classes in lua but still want this to be expandable to other
-- types of logic so we're doing it this way.
function Gate:init(region1, region2, name, cost1, cost2)
    self.region1 = region1
    self.region2 = region2
    self.from1_cost = cost1
    self.from2_cost = cost2
    self.gate = name
end

function Gate:get_destination(source)
    if source == self.region1 then
        return self.region2
    else
        return self.region1
    end
end

function Gate:is_applicable(source)
    if source == self.region1 and self.from1_cost ~= nil then
        return true
    elseif source == self.region2 and self.from2_cost ~= nil then
        return true
    end
    return false
end

-- Check if slugcat can access the Gate. Assumes you have access to the source.
function Gate:check_access(source)
    if source ~= self.region1 and source ~= self.region2 then
        return 2
    end
    local karma_required
    -- Karma is only required for gate setting 1,2,3
    if source == self.region1 then
        karma_required = self.from1_cost
    else
        karma_required = self.from2_cost
    end

    if karma_required == nil then
        return 0
    end

    local gate = Tracker:FindObjectForCode(self.gate)
    local has_gate = gate and gate.Active

    local has_karma = Tracker:FindObjectForCode("Karma").CurrentStage + 1 >= karma_required
    
    local gate_logic = 
    {
        [0] = has_gate,
        [1] = has_gate and has_karma,
        [2] = has_gate or has_karma,
        [3] = has_karma
    }
    
    if gate_logic[Tracker:FindObjectForCode("gatelogic").CurrentStage] then
        return 2
    end
    return 0
end
