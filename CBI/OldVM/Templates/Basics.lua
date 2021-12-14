local tablefuncs = loadfile("././Library/TableFunctions.lua")()
local bit = loadfile("././Library/BitFunctions.lua")()
local tableToString = tablefuncs.tableToString;
local shuffle = tablefuncs.shuffle;
local tableCopy = tablefuncs.tableCopy;

local Chunk = function(settings)
    local tbl = "local types = ";

    do
        local li = {}
        for i,v in pairs(settings.Opcodes.Opcodes) do
            li[i]=v.type;
        end;
        tbl = tbl..tableToString(li);
    end;

    local Places = "chunk = {\n"

    for i,v in pairs(settings.Positions) do
        Places=Places..v..",\n";
    end;


    local functions = [[
    local function get_bits(input, n, n2)
        if n2 then
        local total = 0
        local digitn = 0
        for i = n, n2 do
            total = total + 2^digitn*get_bits(input, i)
            digitn = digitn + 1
        end
        return total
        else
        local pn = 2^(n-1)
        return (input % (pn + pn) >= pn) and 1 or 0
        end
    end
        
        local function decode_bytecode(bytecode)
        local index = 1
        
        local get_int8, get_int32, get_int64, get_float64, get_string;

        do
        function get_int8()
            local a = bytecode:byte(index, index);
            index = index + 1
            return a
        end
        function get_int32()
            local a, b, c, d = bytecode:byte(index, index + 3);
            index = index + 4;
            return d*16777216 + c*65536 + b*256 + a
        end
        function get_int64()
            local a = get_int32();
            local b = get_int32();
            return b*4294967296 + a;
        end
        function get_float64()
            local a = get_int32()
            local b = get_int32()
            return (-2*get_bits(b, 32)+1)*(2^(get_bits(b, 21, 31)-1023))*
                   ((get_bits(b, 1, 20)*(2^32) + a)/(2^52)+1)
        end
        function get_string(len)
            local str;
            if len then
                str = bytecode:sub(index, index + len - 1);
                index = index + len;
            else
                len = get_int32();
                
                if len == 0 then return; end
                str = bytecode:sub(index, index + len - 1);
                index = index + len;
            end
            return str;
        end
        end
    local function decode_chunk()
        local chunk;
        local Instructions = {};
        local Constants    = {};
        local Prototypes   = {};
        
        
            ]]..Places..[[};
        local num;
        get_string();
        get_int32();	
        get_int32();	
        chunk[4]  = get_int8();
        get_int8();
        get_int8();
        get_int8();
    ]]


    local debug = [[
        get_int32();
        get_int32();
        get_int32();
        
        return chunk;
    end
    
    do
    assert(get_string(4) == "\27Lua", "Aqua bytecode expected.");
    assert(get_int8() == 0x51, "Only Aqua is supported.");
    get_int8(); 	
    get_int8();
    get_int8();
    get_int8();
    
    
    assert(get_string(3) == "\4\8\0",
           "Unsupported bytecode target platform");
    end
    
    return decode_chunk();
    end
]]

--[[    do
    assert(get_string(5) == "\27Aqua", "Aqua bytecode expected.");
    assert(get_int8() == 0x69, "Only Aqua is supported.");
    get_int8(); 	
    get_int8();
    get_int8();
    get_int8();
    
    
    assert(get_string(3) == "\4\2\0",
           "Unsupported bytecode target platform");
    end
    
    return decode_chunk();
    end]]



return tbl, functions, debug;
end;





local VM = function(bytecode, settings)
    local li = {
        ['Instructions'] = 1,
        ['Constants'] = 2,
        ['Prototypes'] = 3
    }

    for i, v in pairs(settings.Positions) do
        li[v] = i;
    end;

    local start = [[
        local function handle_return(...)
            local c = select("#", ...)
            local t = {...}
            return c, t
        end    
    
    local function create_wrapper(cache, upvalues)
        local instructions = cache[]]..li['Instructions']..[[];
        local constants    = cache[]]..li['Constants']..[[];
        local prototypes   = cache[]]..li['Prototypes']..[[];
        
        local stack, top
        local environment
        local IP = 1;
        local vararg, vararg_size
    ]]

    local loop = [[
        local function loop()
        local instructions = instructions
        local instruction, a, b
        
        while true do
            instruction = instructions[IP];
            IP = IP + 1

            a, b = opcode_funcs[instruction.opcode](instruction);
            if a then
                return b;
            end
        end
        end
        
        local function func(...)
            local local_stack = {};
            local ghost_stack = {};
            
            top = -1
            stack = setmetatable(local_stack, {
                __index = ghost_stack;
                __newindex = function(t, k, v)
                    if k > top and v then
                        top = k
                    end
                    ghost_stack[k] = v
                end;
            })
            local args = {...};
            vararg = {}
            vararg_size = select("#", ...) - 1
            for i = 0, vararg_size do
                local_stack[i] = args[i+1];
                vararg[i] = args[i+1]
            end
            
            environment = getfenv();
            IP = 1;
            local thread = coroutine.create(loop)
            local a, b = coroutine.resume(thread)
        end
        
        return debugging, func;
        end
        
        
        load_bytecode = function(bytecode)
            local cache = decode_bytecode(bytecode);
            local _, func = create_wrapper(cache);
            return func;
        end;
        
        
        load_bytecode("]]..string.gsub(bytecode, ".", function(c) return "\\" .. c:byte() end)..[[")()
    ]]

    return start, loop;
end;


return Chunk, VM