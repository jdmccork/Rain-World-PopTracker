OneWay = class()

--- Connection between two subregions. 
--- If a Required code is not active, the connection will not be traversable.
--- If optional code is not active, the connection will be out of logic
function OneWay:init(region1, region2, required_codes, optional_codes)
    self.region1 = region1
    self.region2 = region2
    self.required_codes = required_codes
    self.optional_codes = optional_codes
end

function OneWay:is_applicable(source)
    if source ~= self.region1 then
        return false
    end

    return true
end

-- Returns the level of access is possible.
function OneWay:check_access(source)
    local access = 0

    if #self.optional_codes == 0 and #self.required_codes == 0 then
        return 2
    end
    
    -- If any of the optional codes are missing, give out of logic access
    for _, codegroup in ipairs(self.optional_codes or {}) do
        local optional_access = 2
        for _, code in ipairs(codegroup or {}) do
            if not Tracker:FindObjectForCode(code).Active then
                optional_access = 1
            end
        end
        access = math.max(access, optional_access)
    end
    
    -- If there is no group of required codes present, give no logic access
    for _, codegroup in ipairs(self.required_codes or {}) do
        local required_access = access
        for _, code in ipairs(codegroup or {}) do
            if not Tracker:FindObjectForCode(code).Active then
                required_access = 0
            end
        end
        access = math.max(access, required_access)
    end
    
    -- Otherwise, give full access
    return access
end
