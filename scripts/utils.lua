-- from https://stackoverflow.com/questions/9168058/how-to-dump-a-table-to-console
-- dumps a table in a readable string
function dump_table(o, depth)
    if depth == nil then
        depth = 0
    end
    if type(o) == 'table' then
        local tabs = ('\t'):rep(depth)
        local tabs2 = ('\t'):rep(depth + 1)
        local s = '{\n'
        for k, v in pairs(o) do
            local kc = k
            if type(k) ~= 'number' then
                kc = '"' .. k .. '"'
            end
            s = s .. tabs2 .. '[' .. kc .. '] = ' .. dump_table(v, depth + 1) .. ',\n'
        end
        return s .. tabs .. '}'
    else
        return tostring(o)
    end
end

Queue = {}

--Queue implementation from https://www.lua.org/pil/11.4.html
function Queue.new()
      return {first = 0, last = -1}
    end

function Queue.pushleft (list, value)
  local first = list.first - 1
  list.first = first
  list[first] = value
end

function Queue.pushright (list, value)
  local last = list.last + 1
  list.last = last
  list[last] = value
end

function Queue.popleft (list)
  local first = list.first
  if first > list.last then error("list is empty") end
  local value = list[first]
  list[first] = nil        -- to allow garbage collection
  list.first = first + 1
  return value
end

function Queue.popright (list)
  local last = list.last
  if list.first > last then error("list is empty") end
  local value = list[last]
  list[last] = nil         -- to allow garbage collection
  list.last = last - 1
  return value
end

function Queue.isempty(list)
    local last = list.last
    return list.first > last
end


function check_code_access(required_codes, optional_codes)
    local optional_access = #optional_codes == 0
    local required_access = #required_codes == 0

    -- If any of the optional codes are missing, give out of logic access
    for _, codegroup in ipairs(optional_codes or {}) do
        local temp_access = true
        for _, code in ipairs(codegroup or {}) do
            if type(code) ~= "table" then
                if not Tracker:FindObjectForCode(code).Active then
                    temp_access = false
                end
            else
                if Tracker:FindObjectForCode(code[1]).CurrentStage ~= code[2] then
                    temp_access = false
                end
            end
        end

        if temp_access then
            optional_access = true
        end
    end
    
    -- If there is no group of required codes present, give no logic access
    for _, codegroup in ipairs(required_codes or {}) do
        local temp_access = true
        for _, code in ipairs(codegroup or {}) do
            if type(code) ~= "table" then
                if not Tracker:FindObjectForCode(code).Active then
                    temp_access = false
                end
            else
                if Tracker:FindObjectForCode(code[1]).CurrentStage ~= code[2] then
                    temp_access = false
                end
            end
        end
        if temp_access then
            required_access = true
        end
    end
    print(dump_table(required_codes), required_access, dump_table(optional_codes), optional_access)
    if required_access and optional_access then
        return 2
    elseif required_access then
        return 1
    else
        return 0
    end
end