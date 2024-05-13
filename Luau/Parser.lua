--[[

Example ByteCode:

function anon_0(??)
    1 GETGLOBAL R0 K0; 'pairs'
    2 NEWTABLE R1 0 4
    3 LOADK R3 K1; 1
    4 LOADK R4 K2; 2
    5 LOADK R5 K3; 3
    6 LOADK R6 K4; 4
    7 SETLIST R1 R3 4; 1
    8 CALL R0 1 3
    9 FORGPREP R0 L0
    10 L0 FORGLOOP R0 L0 2
    11 RETURN R0 0
end

]]

local tester = [[
function anon_0(??)
    1 GETGLOBAL R0 K0; 'pairs'
    2 NEWTABLE R1 0 4
    3 LOADK R3 K1; 1
    4 LOADK R4 K2; 2
    5 LOADK R5 K3; 3
    6 LOADK R6 K4; 4
    7 SETLIST R1 R3 4; 1
    8 CALL R0 1 3
    9 FORGPREP R0 L0
    10 L0 FORGLOOP R0 L0 2
    11 RETURN R0 0
end
]]

local TypeC = require("Luau.Type")
local Objects = require("Luau.Objects")
local OpCodeConverter = require("Luau.OpCodeConverter")

---@param t table
function ReadTable(t)
    print("Start of Table: ")
    for i, v in pairs(t) do
        if type(v) == "table" then
            ReadTable(v)
        else
            print(i, v)
        end
    end
    print("End of Table")
end

---@param Instructions string
function ParseInstructions(Instructions)
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
    local FuncTable = {}
    local addingtofuncs = false
    local currentfuncname = ""

    TypeC("string", Instructions) 

    local SplitInstructions = split(Instructions, "\n")


    for _, value in pairs(SplitInstructions) do
        if string.match(value, "function%s+[%a%d_]+%(.-%)") then
            currentfuncname = string.match(value, "function%s+([%a%d_]+)")
            FuncTable[currentfuncname] = {}
            addingtofuncs = true
            goto endofloop
        end
        if addingtofuncs == true then
            if value == "end" then
                currentfuncname = ""
                addingtofuncs = false
                goto endofloop
            else
                table.insert(FuncTable[currentfuncname], value)
            end
        end
        ::endofloop::
        do end
    end
    local data = {}

    ---@param i string
    ---@param v table
    for i,v in pairs(FuncTable) do
        local n = i
        data[n] = {}
        
        ---@param r number
        ---@param g string
        for r,g in pairs(v) do
            local Info = Objects.InstructionInfo:Create(g)
            print(OpCodeConverter.Convert(Info.OPCode,Info.References,Info.Values))
        end
    end
end

ParseInstructions(tester)
