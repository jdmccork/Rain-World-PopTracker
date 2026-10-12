FixedWarp = class()

-- Couldn't figure out sub classes in lua but still want this to be expandable to other
-- types of logic so we're doing it this way.
function FixedWarp:init(region1, region2)
    self.region1 = region1
    self.region2 = region2
    self.name = string.format("Warp-%s-%s", region1, region2)
end

function FixedWarp:get_destination(source)
    if source == self.region1 then
        return self.region2
    else
        return self.region1
    end
end

function FixedWarp:is_applicable(source)
    if source ~= self.region1 and source ~= self.region2 then
        return false
    end

    return true
end

-- Check if slugcat can access the FixedWarp. Assumes you have access to the source.
function FixedWarp:check_access(source)
    if source ~= self.region1 then
        return 2
    end
    if Tracker:FindObjectForCode(self.name).Active then
        return 2
    end
    return 0
end
