FixedWarp = class()

-- Couldn't figure out sub classes in lua but still want this to be expandable to other
-- types of logic so we're doing it this way.
function FixedWarp:init(region1, region2, name, ripple, oneWay, needsKey)
    self.region1 = region1
    self.region2 = region2
    self.ripple = ripple
    self.oneWay = oneWay
    self.needsKey = needsKey
    self.name = name
end

function FixedWarp:get_destination(source)
    if source == self.region1 or self.oneWay then
        return self.region2
    else
        return self.region1
    end
end

function FixedWarp:is_applicable(source)
    if source == self.region1 then
        return true
    end
    if source == self.region2 and not self.oneWay then
        return true
    end

    return false
end

-- Check if slugcat can access the FixedWarp. Assumes you have access to the source.
function FixedWarp:check_access(source)
    if source ~= self.region1 and source ~= self.region2 then
        return 2
    end
    if self.needsKey then
        if Tracker:FindObjectForCode(self.name).Active then
            return 2
        else
            return 0
        end
    elseif self.ripple then
        if Tracker:ProviderCountForCode("ripple3") ~= 0 then
            return 2
        else
            return 0
        end
    elseif Tracker:ProviderCountForCode("ripple2") ~= 0 then
        return 2
    end
    return 0
end
