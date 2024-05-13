local GlobalFuncs = require("Luau.GlobalFuncs")

local Pointers = {}

---@param Pointer string
---@return number|nil return
function Pointers:GetPointer(Pointer)
    return tonumber(Pointer.sub(Pointer, 2, #Pointer))
end

---@param PointerIndex number
---@return string return
function Pointers:CreatePointer(PointerIndex)
    return "R" .. tostring(PointerIndex)
end

---@param NewValue number
---@return string return
function Pointers:SetPointer(NewValue)
    return "R" .. tostring(NewValue)
end

---@param Pointer string
---@param ChangeBy number
---@return string return
function Pointers:ChangePointer(Pointer,ChangeBy)
    return self:SetPointer(self:GetPointer(Pointer) + ChangeBy)
end

return Pointers