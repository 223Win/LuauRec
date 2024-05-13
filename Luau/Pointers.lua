local GlobalFuncs = require("Luau.GlobalFuncs")

local Pointers = {}

---@param Pointer string
function Pointers:GetPointer(Pointer)
    return tonumber(Pointer.sub(Pointer, 2, #Pointer))
end

return Pointers