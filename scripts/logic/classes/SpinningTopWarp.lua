SpinningTopWarp = class()

-- Couldn't figure out sub classes in lua but still want this to be expandable to other
-- types of logic so we're doing it this way.
function SpinningTopWarp:init(region1, region2)
    self.region1 = region1
    self.region2 = region2
    self.name = string.format("Warp-%s-%s", region1, region2)
end

function SpinningTopWarp:get_destination(source)
    return self.region2
end

function SpinningTopWarp:is_applicable(source)
    return source == self.region1
end

-- Check if slugcat can access the SpinningTopWarp. Assumes you have access to the source.
function SpinningTopWarp:check_access(source)
    if source ~= self.region1 then
        return 2
    end
    local has_key = not Tracker:FindObjectForCode("spinning_top_keys").Active
    
    if has_key then
        return 2
    end
    return 0
end
