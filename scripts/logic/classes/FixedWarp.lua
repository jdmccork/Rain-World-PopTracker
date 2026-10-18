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
    if source ~= self.region1 and self.oneWay then
        return false
    end
    if not self.oneWay and source ~= self.region2 then
        return false
    end

    return true
end

-- Check if slugcat can access the FixedWarp. Assumes you have access to the source.
function FixedWarp:check_access(source)
    if source ~= self.region1 and source ~= self.region2 then
        return 2
    end
    if self.needsKey and not Tracker:FindObjectForCode(self.name).Active then
        return 0
    end
    if self.ripple and Tracker:ProviderCountForCode("ripple3") == 0 then
        return 0
    end
    if Tracker:ProviderCountForCode("ripple2") == 0 then
        return 0
    end
    return 2
end
