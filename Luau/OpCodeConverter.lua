local function concat(...)
    local s = ""for i,v in pairs({...})do;s = s..tostring(v);end;return s
end

local reftable = {}

local OpCodeData = {
    ---@type function
    ---@param Refs table<number,string>
    ---@param Vals table<number,string>
    ["LOADK"] = function(Refs, Vals)
        reftable[Refs[1]] = Vals
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
        for i = 0, Refs[3] do
            table.insert(t, "unknown value: settable not called yet.")
        end
        reftable[Refs[1]] = t
        return table.concat(t," , \n")
    end,
    ---@type function
    ---@param Refs table<number,string>
    ---@param Vals table<number,string>
    ["SETLIST"] = function(Refs, Vals)
        local t = {}
        for i = 0, Refs[3] do
            table.insert(t, "unknown value: settable not called yet.")
        end
        reftable[Refs[1]] = t
        return table.concat(t, " , \n")
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