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
    if self.is_applicable(source) then
        return check_code_access(self.required_codes, self.optional_codes)
    end
    return 0
end
