Gate = class()

-- Couldn't figure out sub classes in lua but still want this to be expandable to other
-- types of logic so we're doing it this way.
-- Regions can be split into {Region, Subregion} but this is only requried if two gates have the same regions
function Gate:init(region1, region2, name, cost1, cost2)
    if type(region1) == "string" then
        self.region1 = region1
    else
        self.region1 = region1[1]
        self.subregion1 = region1[2]
    end

    if type(region2) == "string" then
        self.region2 = region2
    else
        self.region2 = region2[1]
        self.subregion2 = region2[2]
    end
    self.gate = name
    self.from1_cost = cost1
    self.from2_cost = cost2
end

function Gate:get_next_region_name(source)
    if source == self.region1 then
        return self.region2
    else
        return self.region1
    end
end

function Gate:get_subregion_name(region)
    if region == self.region1 then
        return self.subregion1
    else
        return self.subregion2
    end
end


-- Check if slugcat can access the Gate. Assumes you have access to the source.
function Gate:check_access(source, subregion)
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
    local has_karma
    if type(karma_required) == "number" then 
        has_karma = Tracker:FindObjectForCode("Karma").CurrentStage >= karma_required
    else
        has_karma = Tracker:FindObjectForCode("drone").Active
    end
    local gate = Tracker:FindObjectForCode(self.gate)
    local has_gate = gate and gate.Active
        
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
