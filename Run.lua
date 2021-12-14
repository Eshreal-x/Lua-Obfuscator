--[[
    Obfuscator written by me.

    Minifier was made by Stravant and rewritten in js by Herrtt.
    rerubi was used to make my VM generation. the VM itself is also based on rerubi.
]]--

--[[
    TODO:
        - Compound operator support (not in lua 5.1).
        - continue support.
        - Type support (v: any).


        - XOR's to instruction data and other stuff.
        - Constant incription ?
        - Mutate more stuff ?

]]--

math.randomseed(os.time());

local tablefuncs = loadfile("Library/TableFunctions.lua")()
local bit = loadfile("Library/BitFunctions.lua")()
local tableToString = tablefuncs.tableToString;
local shuffle = tablefuncs.shuffle;
local tableCopy = tablefuncs.tableCopy;


local options = {
    PositionShuffeling = true,
    RegisterShuffeling = true,
    OpcodeShuffeling   = true,
    Debugging = false
}

local settings = {
    Debugging = options.Debugging,
    Positions = {
        [1] = 'Instructions',
        [2] = 'Constants',
        [3] = 'Prototypes'
    };

    ABC = {
        Opcode = {},
        A      = {},
        B      = {},
        C      = {},
    },

    ABx = {
        Opcode = {},
        A      = {},
        B      = {},
    },

    AsBx = {
        Opcode = {},
        A      = {},
        B      = {},
    },
}




local outputlist = function(original, new, val)
    if val then
        for i,v in pairs(original) do
            for i2, v2 in pairs(new) do
                if v[val] == v2[val] then
                    print(v[val]..'('..i..') -->    '..i2);
                end;
            end;
        end;
    else
        for i,v in pairs(original) do
            for i2, v2 in pairs(new) do
                if v == v2 then
                    print(v..'('..i..') -->    '..i2);
                end;
            end;
        end;
    end;
end;


do
    local Opcodes = {       
        [0]  = {["name"] = "MOVE",       ["type"] = "ABC",  ["Pos"] = 0,  ["Opmode"] = {["c"] = "OpArgN", ["b"] = "OpArgR"}},
        [1]  = {["name"] = "LOADK",      ["type"] = "ABx",  ["Pos"] = 1,  ["Opmode"] = {["c"] = "OpArgN", ["b"] = "OpArgK"}},
        [2]  = {["name"] = "LOADBOOL",   ["type"] = "ABC",  ["Pos"] = 2,  ["Opmode"] = {["c"] = "OpArgU", ["b"] = "OpArgU"}},
        [3]  = {["name"] = "LOADNIL",    ["type"] = "ABC",  ["Pos"] = 3,  ["Opmode"] = {["c"] = "OpArgN", ["b"] = "OpArgR"}},
        [4]  = {["name"] = "GETUPVAL",   ["type"] = "ABC",  ["Pos"] = 4,  ["Opmode"] = {["c"] = "OpArgN", ["b"] = "OpArgU"}},
        [5]  = {["name"] = "GETGLOBAL",  ["type"] = "ABx",  ["Pos"] = 5,  ["Opmode"] = {["c"] = "OpArgN", ["b"] = "OpArgK"}},
        [6]  = {["name"] = "GETTABLE",   ["type"] = "ABC",  ["Pos"] = 6,  ["Opmode"] = {["c"] = "OpArgK", ["b"] = "OpArgR"}},
        [7]  = {["name"] = "SETGLOBAL",  ["type"] = "ABx",  ["Pos"] = 7,  ["Opmode"] = {["c"] = "OpArgN", ["b"] = "OpArgK"}},
        [8]  = {["name"] = "SETUPVAL",   ["type"] = "ABC",  ["Pos"] = 8,  ["Opmode"] = {["c"] = "OpArgN", ["b"] = "OpArgU"}},
        [9]  = {["name"] = "SETTABLE",   ["type"] = "ABC",  ["Pos"] = 9,  ["Opmode"] = {["c"] = "OpArgK", ["b"] = "OpArgK"}},
        [10] = {["name"] = "NEWTABLE",   ["type"] = "ABC",  ["Pos"] = 10, ["Opmode"] = {["c"] = "OpArgU", ["b"] = "OpArgU"}},
        [11] = {["name"] = "SELF",       ["type"] = "ABC",  ["Pos"] = 11, ["Opmode"] = {["c"] = "OpArgK", ["b"] = "OpArgR"}},
        [12] = {["name"] = "ADD",        ["type"] = "ABC",  ["Pos"] = 12, ["Opmode"] = {["c"] = "OpArgK", ["b"] = "OpArgK"}},
        [13] = {["name"] = "SUB",        ["type"] = "ABC",  ["Pos"] = 13, ["Opmode"] = {["c"] = "OpArgK", ["b"] = "OpArgK"}},
        [14] = {["name"] = "MUL",        ["type"] = "ABC",  ["Pos"] = 14, ["Opmode"] = {["c"] = "OpArgK", ["b"] = "OpArgK"}},
        [15] = {["name"] = "DIV",        ["type"] = "ABC",  ["Pos"] = 15, ["Opmode"] = {["c"] = "OpArgK", ["b"] = "OpArgK"}},
        [16] = {["name"] = "MOD",        ["type"] = "ABC",  ["Pos"] = 16, ["Opmode"] = {["c"] = "OpArgK", ["b"] = "OpArgK"}},
        [17] = {["name"] = "POW",        ["type"] = "ABC",  ["Pos"] = 17, ["Opmode"] = {["c"] = "OpArgK", ["b"] = "OpArgK"}},
        [18] = {["name"] = "UNM",        ["type"] = "ABC",  ["Pos"] = 18, ["Opmode"] = {["c"] = "OpArgN", ["b"] = "OpArgR"}},
        [19] = {["name"] = "NOT",        ["type"] = "ABC",  ["Pos"] = 19, ["Opmode"] = {["c"] = "OpArgN", ["b"] = "OpArgR"}},
        [20] = {["name"] = "LEN",        ["type"] = "ABC",  ["Pos"] = 20, ["Opmode"] = {["c"] = "OpArgN", ["b"] = "OpArgR"}},
        [21] = {["name"] = "CONCAT",     ["type"] = "ABC",  ["Pos"] = 21, ["Opmode"] = {["c"] = "OpArgR", ["b"] = "OpArgR"}},
        [22] = {["name"] = "JMP",        ["type"] = "AsBx", ["Pos"] = 22, ["Opmode"] = {["c"] = "OpArgN", ["b"] = "OpArgR"}},
        [23] = {["name"] = "EQ",         ["type"] = "ABC",  ["Pos"] = 23, ["Opmode"] = {["c"] = "OpArgK", ["b"] = "OpArgK"}},
        [24] = {["name"] = "LT",         ["type"] = "ABC",  ["Pos"] = 24, ["Opmode"] = {["c"] = "OpArgK", ["b"] = "OpArgK"}},
        [25] = {["name"] = "LE",         ["type"] = "ABC",  ["Pos"] = 25, ["Opmode"] = {["c"] = "OpArgK", ["b"] = "OpArgK"}},
        [26] = {["name"] = "TEST",       ["type"] = "ABC",  ["Pos"] = 26, ["Opmode"] = {["c"] = "OpArgU", ["b"] = "OpArgR"}},
        [27] = {["name"] = "TESTSET",    ["type"] = "ABC",  ["Pos"] = 27, ["Opmode"] = {["c"] = "OpArgU", ["b"] = "OpArgR"}},
        [28] = {["name"] = "CALL",       ["type"] = "ABC",  ["Pos"] = 28, ["Opmode"] = {["c"] = "OpArgU", ["b"] = "OpArgU"}},
        [29] = {["name"] = "TAILCALL",   ["type"] = "ABC",  ["Pos"] = 29, ["Opmode"] = {["c"] = "OpArgU", ["b"] = "OpArgU"}},
        [30] = {["name"] = "RETURN",     ["type"] = "ABC",  ["Pos"] = 30, ["Opmode"] = {["c"] = "OpArgN", ["b"] = "OpArgU"}},
        [31] = {["name"] = "FORLOOP",    ["type"] = "AsBx", ["Pos"] = 31, ["Opmode"] = {["c"] = "OpArgN", ["b"] = "OpArgR"}},
        [32] = {["name"] = "FORPREP",    ["type"] = "AsBx", ["Pos"] = 32, ["Opmode"] = {["c"] = "OpArgN", ["b"] = "OpArgR"}},
        [33] = {["name"] = "TFORLOOP",   ["type"] = "ABC",  ["Pos"] = 33, ["Opmode"] = {["c"] = "OpArgU", ["b"] = "OpArgN"}},
        [34] = {["name"] = "SETLIST",    ["type"] = "ABC",  ["Pos"] = 34, ["Opmode"] = {["c"] = "OpArgU", ["b"] = "OpArgU"}},
        [35] = {["name"] = "CLOSE",      ["type"] = "ABC",  ["Pos"] = 35, ["Opmode"] = {["c"] = "OpArgN", ["b"] = "OpArgN"}},
        [36] = {["name"] = "CLOSURE",    ["type"] = "ABx",  ["Pos"] = 36, ["Opmode"] = {["c"] = "OpArgN", ["b"] = "OpArgU"}},
        [37] = {["name"] = "VARARG",     ["type"] = "ABC",  ["Pos"] = 37, ["Opmode"] = {["c"] = "OpArgN", ["b"] = "OpArgU"}},
    }


    local dupe = tableCopy(Opcodes);
    
    
    if options.OpcodeShuffeling then
        shuffle(Opcodes, 0);
        print('\n----<< Opcode Shuffeling >>----');

        outputlist(dupe, Opcodes, 'name')
    end;

    local OpcodeToRandomPos = {};


    for i, v in pairs(Opcodes) do
        for i2, v2 in pairs(dupe) do
            if v.name == v2.name then
                OpcodeToRandomPos[i2] = i;
            end;
        end;
    end;


    settings.Opcodes = {Opcodes = Opcodes, ROpcodes = OpcodeToRandomPos}
end



-- This is probably the worst way of doing this, but oh well.
do
    local pos = 1;
    if options.RegisterShuffeling then
        pos = math.floor(math.random(1, 100) / 50) + 1;
    end
    local ABC  = {[1] = {name = 'A', Length=8, offset = {}}, [2] = {name = 'B', Length=9, offset = {}}, [3] = {name = 'C', Length=9, offset = {}}};
    local ABx  = {[1] = {name = 'A', Length=8, offset = {}}, [2] = {name = 'B', Length=18, offset = {}}};
    local AsBx = {[1] = {name = 'A', Length=8, offset = {}}, [2] = {name = 'B', Length=18, offset = {}}};
    local opcode = {name = 'Opcode', Length=6, offset = {}}


    local function CombineTable(tbl, pos)
        local t = {} 
    
        if pos == 1 then 
            table.insert(t, opcode);
            for i = 1, #tbl do table.insert(t, tbl[i]) end;
        else 
            for i = 1, #tbl do table.insert(t, tbl[i]) end;
            table.insert(t, opcode);
        end
        return t;
    end;

    if options.PositionShuffeling then
        local original = tableCopy(settings.Positions);
        shuffle(settings.Positions);
        print('\n----<< Positions >>----')
        outputlist(original, settings.Positions)
    end;
    


    local function setup(tbl, name)
        print('\n----<< '.. name ..' >>----');
        local i = 1;
        
        if options.RegisterShuffeling then
            shuffle(tbl);
        end;

        tbl=CombineTable(tbl, pos)
        
        for int = 1, #tbl do
            local v = tbl[int];

            v.offset = {i, i+v.Length-1};
            settings[name][v.name] = v.offset;

            print(i, v.name, ""..v.offset[1].."-"..v.offset[2]);
            i=i + v.Length;
        end;
    end;



    setup(ABC, 'ABC');
    setup(ABx, 'ABx');
    setup(AsBx, 'AsBx');
end;









local bytecode, str = loadfile("Genbytecode.lua")();
print(string.rep('\n', 3));
local obfbytecode = loadfile("Bytecode/MutateBytecode.lua")()(bytecode, settings);
local CVM = loadfile("CBI/GenCBI.lua")()(obfbytecode, settings);


do
    local a = io.open("minifier/input.lua",'w+');
    a:write(CVM)
    a:close();
end

os.execute("node Minifier/main.js pause");



--print(string.gsub(obfbytecode, ".", function(c) return "\\" .. c:byte() end));


print(string.rep('\n', 3));
--print(tableToString(settings))