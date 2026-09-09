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
    local access = 0

    if #optional_codes == 0 and #required_codes == 0 then
        return 2
    end
    -- If any of the optional codes are missing, give out of logic access
    for _, codegroup in ipairs(optional_codes or {}) do
        local optional_access = 2
        for _, code in ipairs(codegroup or {}) do
            if type(code) ~= "table" then
                if not Tracker:FindObjectForCode(code).Active then
                    optional_access = 1
                end
            else
                if Tracker:FindObjectForCode(code[1]).CurrentStage ~= code[2] then
                    optional_access = 1
                end
            end
        end
        access = math.max(access, optional_access)
    end
    
    -- If there is no group of required codes present, give no logic access
    for _, codegroup in ipairs(required_codes or {}) do
        local required_access = access
        for _, code in ipairs(codegroup or {}) do
            if type(code) ~= "table" then
                if not Tracker:FindObjectForCode(code).Active then
                    required_access = 0
                end
            else
                if Tracker:FindObjectForCode(code[1]).CurrentStage ~= code[2] then
                    required_access = 0
                end
            end
        end
        access = math.max(access, required_access)
    end
    
    -- Otherwise, give full access
    return access
end