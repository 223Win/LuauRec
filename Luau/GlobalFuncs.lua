---@return table<number,string> Return
---@param str string
---@param sep string
local function split(str, sep)
    local t = {}
    for c in string.gmatch(str, "([^" .. sep .. "]+)") do
        table.insert(t, c)
    end

    return t
end
---@param str string
---@param match string
---@param replacement string
---@return string Result
local function replace(str, match, replacement)
    local r = string.gsub(str, match, replacement)

    return r
end

---@param Value any
---@return boolean Return
local function CheckIfValueNil(Value)
    return (Value == nil) and true or false
end


return {CheckIfValueNil = CheckIfValueNil,replace = replace, split = split}