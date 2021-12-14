local tablefuncs = loadfile("./Library/TableFunctions.lua")()
local bit = loadfile("./Library/BitFunctions.lua")()
local tableToString = tablefuncs.tableToString;
local shuffle = tablefuncs.shuffle;
local tableCopy = tablefuncs.tableCopy;


local ChunkData, VMData = loadfile("./CBI/Templates/Basics.lua")();


local GenChunkDecoder = function(settings)
    local TypesTable, Functions, Debug = ChunkData(settings)
    local Decoders = loadfile("./CBI/Templates/Decoders.lua")()(settings);
        
    
    return TypesTable.."\n"..Functions.."\n"..Decoders .. "\n" .. Debug .. "\n";
end

local GenVM = function(bytecode, settings)
    local Setup, Loop = VMData(bytecode, settings)
    local Opcodes = loadfile("./CBI/Templates/Opcodes.lua")()(settings);
      

    return Setup .. "\n\n"..Opcodes.."\n\n" .. Loop;
end





local GenCVM = function(bytecode, settings)
   local VM = GenChunkDecoder(settings).. string.rep('\n', 6) .. GenVM(bytecode, settings);
   return VM;
end;



return GenCVM;