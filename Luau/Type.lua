---@param content any
---@param typeto type
---@return boolean|nil
function TypeCheck(typeto, content)
    if type(typeto) ~= "string" then
        if type(content) ~= type(typeto) then
            error("Content Does not match Input Type.", 3)
        end
    else
        if type(content) ~= typeto then
            return true
        end
    end
end




return TypeCheck