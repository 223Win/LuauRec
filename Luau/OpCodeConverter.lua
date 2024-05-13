local Pointers = require("Luau.Pointers")
local function concat(...)
    local s = ""
    for i, v in pairs({ ... }) do
        ; s = s .. tostring(v);
    end; return s
end


local reftable = {}

local OpCodeData = {
    ---@type function
    ---@param Refs table<number,string>
    ---@param Vals table<number,string>
    ["LOADK"] = function(Refs, Vals)
        reftable[Refs[1]] = Vals[1]
        return concat("local ",Refs[2]," = ",Vals[1])
    end,
    ---@type function
    ---@param Refs table<number,string>
    ---@param Vals table<number,string>
    ["GETGLOBAL"] = function(Refs, Vals)
        reftable[Refs[1]] = Vals[1]
        return Vals[1]
    end,
    ---@type function
    ---@param Refs table<number,string>
    ---@param Vals table<number,string>
    ["NEWTABLE"] = function(Refs, Vals)
        local t = {}
        for i = 1, Refs[3] do
            table.insert(t, "unknown value: settable not called yet.")
        end
        reftable[Refs[1]] = t
        return table.concat(t," , \n")
    end,
    ---@type function
    ---@param Refs table<number,string>
    ---@param Vals table<number,string>
    ["SETLIST"] = function(Refs, Vals)
        --//-- Set pointer back by 1 to fix pointer invalidation --//--
        local curpointer = Pointers:GetPointer(Refs[2]) - 1
        local t = reftable[Refs[1]]
        for i = 1, Refs[3] do
            curpointer = curpointer + 1
            t[i] = reftable[Pointers:SetPointer(curpointer)]
        end
        reftable[Refs[1]] = t
        print(table.concat(reftable[Refs[1]],", \n"))
        return "--SETLIST OPCODE SKIP"
    end,
}

local e = setmetatable(OpCodeData, {
    __index = function (t, k)
        return function()
            return concat("Unknown OpCode Converter for: ", k, ", Invalid OpCode")
        end
    end
})

function Convert(OpCode, Refs, Vals)
    return OpCodeData[OpCode](Refs, Vals)
end


return {
    Convert = Convert
}