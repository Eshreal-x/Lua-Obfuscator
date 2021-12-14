local tablefuncs = loadfile("./Library/TableFunctions.lua")()
local bit = loadfile("./Library/BitFunctions.lua")()
local tableToString = tablefuncs.tableToString;
local shuffle = tablefuncs.shuffle;
local tableCopy = tablefuncs.tableCopy;

local run = function(settings)
    local li = {};

    for i,v in pairs(settings.Opcodes.Opcodes) do
        local a = loadfile("./CBI/Templates/Opcodes/OP_"..v.name..".lua")()(settings)
        li[v.name] = a;
    end;

    local data = "";

    

    for i,v in pairs(settings.Opcodes.Opcodes) do
        if #data == 0 then
            data=data.."if (Enum == "..tostring(i)..") then -- "..v.name.."\n"..li[v.name].."\n";
        else
            data=data.."\nelseif (Enum == "..tostring(i)..") then -- "..v.name.."\n"..li[v.name].."\n";
        end;
    end;



    data=data.."\n end;\nend;\nend;\n"



    return data;
end;


return run;