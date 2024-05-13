local GlobalFuncs = require("Luau.GlobalFuncs")

---@param InfoTable table<number,string>
---@param Start number
local function GetByteRefsAndVals(InfoTable, Start)
    local Refs = {}
    local Vals = {}
    local isaddingvals = false
    for i = Start, #InfoTable do
        if isaddingvals == false then
            if GlobalFuncs.CheckIfValueNil(InfoTable[i]:find(";")) == false then
                table.insert(Refs, GlobalFuncs.replace(InfoTable[i], ";", ""))
                isaddingvals = true
            else
                table.insert(Refs, InfoTable[i])
            end
        else
            table.insert(Vals, InfoTable[i])
        end
    end
    return {
        ['Refs'] = Refs,
        ['Vals'] = Vals,
    }
end

---@class InstructionInfomation
---@field OPCode string
---@field LinePosition string
---@field Jumps table<number,string>
---@field References table<number,string>
---@field Values table<number,string>


local InstructionInfo = {}

---@param OPCode string
---@param Jumps table<number,string>
---@param References table<number,string>
---@param Values table<number,string>
---@param LinePosition string
---@return InstructionInfomation Information
function InstructionInfo:new(OPCode, Jumps, References, Values, LinePosition)
    local info = {}
    info.OPCode = OPCode
    info.References = References
    info.Values = Values

    info.Jumps = Jumps

    info.LinePosition = LinePosition

    return info
end

---@param ByteCodeLine string
---@return InstructionInfomation Information
function InstructionInfo:Create(ByteCodeLine)
    local Info = GlobalFuncs.split(ByteCodeLine, " ")
    local locatepresent = (GlobalFuncs.CheckIfValueNil(Info[2]:match("L%d+")) == false)
    if locatepresent then
        local refsandvals = GetByteRefsAndVals(Info, 4)
        return InstructionInfo:new(Info[3], { [1] = Info[2] }, refsandvals['Refs'], refsandvals['Vals'], Info[1])
    else
        local refsandvals = GetByteRefsAndVals(Info, 3)
        return InstructionInfo:new(Info[2], {}, refsandvals['Refs'], refsandvals['Vals'], Info[1])
    end
end


return {InstructionInfo = InstructionInfo}