DaemonWarp = class()

-- Couldn't figure out sub classes in lua but still want this to be expandable to other
-- types of logic so we're doing it this way.
function DaemonWarp:init(region1, name, exit)
    self.region1 = region1
    self.region2 = "Daemon"
    self.name = name
    self.exit = exit or false
end

function DaemonWarp:get_destination(source)
    if self.exit then
        return self.region1
    end

    return "Daemon"
end

function DaemonWarp:is_applicable(source)
    return source == self.region1 or (source == "Daemon" and self.exit)
end

-- Check if slugcat can access Daemon. Assumes you have access to the source.
function DaemonWarp:check_access(source)
    if source ~= self.region1 and (self.exit and source ~= "Daemon") then
        return 2
    end

    if Tracker:FindObjectForCode("daemon_keys").Active and not self.exit then
        if not Tracker:FindObjectForCode(self.name).Active then
            return 0
        end
    end

    if Tracker:ProviderCountForCode("ripple9") ~= 0 then
        return 2
    end
    return 0
end
