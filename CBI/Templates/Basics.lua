local tablefuncs = loadfile("././Library/TableFunctions.lua")()
local bit = loadfile("././Library/BitFunctions.lua")()
local tableToString = tablefuncs.tableToString;
local shuffle = tablefuncs.shuffle;
local tableCopy = tablefuncs.tableCopy;

local Chunk = function(settings)



    local tbl = "local Opcode = ";

    do
        local li  = {};
        local li2 = {};
        for i,v in pairs(settings.Opcodes.Opcodes) do
            li[i]=v.type;
            li2[i]=v.Opmode;
        end;
        tbl = tbl..tableToString(li).. "\n\n".."local Opmode ="..tableToString(li2).. "\n\n";
    end;



    local Places = "local Chunk = {\n"

    for i,v in pairs(settings.Positions) do
        Places=Places..v:sub(1,5)..",\n";
    end;

    

    local functions = [[
        local Select	= select;
        local Byte		= string.byte;
        local Sub		= string.sub;
        
        
        
        local function gBit(Bit, Start, End)
            if End then 
                local Res	= (Bit / 2 ^ (Start - 1)) % 2 ^ ((End - 1) - (Start - 1) + 1);
        
                return Res - Res % 1;
            else
                local Plc = 2 ^ (Start - 1);
        
                if (Bit % (Plc + Plc) >= Plc) then
                    return 1;
                else
                    return 0;
                end;
            end;
        end;
        
        local function GetMeaning(ByteString)
            local Pos	= 1;
            local gSizet;
            local gInt;
        
            local function gBits8() 
                local F	= Byte(ByteString, Pos, Pos);
        
                Pos	= Pos + 1;
        
                return F;
            end;
        
            local function gBits32()
                local W, X, Y, Z	= Byte(ByteString, Pos, Pos + 3);
        
                Pos	= Pos + 4;
        
                return (Z * 16777216) + (Y * 65536) + (X * 256) + W;
            end;
        
            local function gBits64()
                return gBits32() * 4294967296 + gBits32();
            end;
        
            local function gFloat()
                local Left = gBits32();
                local Right = gBits32();
                local IsNormal = 1
                local Mantissa = (gBit(Right, 1, 20) * (2 ^ 32))
                                + Left;
        
                local Exponent = gBit(Right, 21, 31);
                local Sign = ((-1) ^ gBit(Right, 32));
        
                if (Exponent == 0) then
                    if (Mantissa == 0) then
                        return Sign * 0 -- +-0
                    else
                        Exponent = 1
                        IsNormal = 0
                    end
                elseif (Exponent == 2047) then
                    if (Mantissa == 0) then
                        return Sign * (1 / 0) -- +-Inf
                    else
                        return Sign * (0 / 0) -- +-Q/Nan
                    end
                end
        
                -- sign * 2**e-1023 * isNormal.mantissa
                return math.ldexp(Sign, Exponent - 1023) * (IsNormal + (Mantissa / (2 ^ 52)))
            end;
        
            local function gString(Len)
                local Str;
        
                if Len then
                    Str	= Sub(ByteString, Pos, Pos + Len - 1);
        
                    Pos = Pos + Len;
                else
                    Len = gSizet();
        
                    if (Len == 0) then return; end;
        
                    Str	= Sub(ByteString, Pos, Pos + Len - 1);
        
                    Pos = Pos + Len;
                end;
        
                return Str;
            end;
        
            local function ChunkDecode()
                local Instr	= {};
                local Const	= {};
                local Proto	= {};

                gString();
                gInt();
                gInt();
                
                ]]..Places..[[};
                
                Chunk[4] = gBits8();
                Chunk[28] = gBits8();
                gBits8();
                gBits8();

                local ConstantReferences = {};    
    ]]


    local debug = [[
        gBits32();
        gBits32();
        gBits32();
        
        return Chunk;
    end
    
    do
        assert(gString(4) == "\27Lua", "Aqua bytecode expected.");
        assert(gBits8() == 0x51, "Only Aqua is supported.");
        gBits8(); 	
        gBits8();
        gBits8();
        gBits8();
        
        gSizet	= gBits32;
        gInt	= gBits32;
        
        assert(gString(3) == "\4\8\0", "Unsupported bytecode target platform");
        end
        
        return ChunkDecode();
    end
]]

local ending = [[    
    gBits32();
    gBits32();
    gBits32();
    
    return Chunk;
end

do
    assert(gString(5) == "\27Aqua", "Aqua bytecode expected.");
    assert(gBits8() == 0x69, "Only Aqua is supported.");
    gBits8(); 	
    gBits8();
    gBits8();
    gBits8();
    
    gSizet	= gBits32;
    gInt	= gBits32;
    
    assert(gString(3) == "\4\2\0", "Unsupported bytecode target platform");
    end
    
    return ChunkDecode();
end]]

    if settings.Debugging then
        return tbl, functions, debug;
    else
        return tbl, functions, ending;
    end;
end;





local VM = function(bytecode, settings)
    local posstr = "";

    do
        local li = {};
        for i, v in pairs(settings.Positions) do
            table.insert(li, "local ".. v:sub(1, 5) .. " = Chunk[" .. i .. "];\n") 
        end;

        shuffle(li);

        for i,v in pairs(li) do
            posstr = posstr..v;
        end;
    end;

    local start = [[
        local function _Returns(...)
            return Select('#', ...), {...};
        end;
        
        local function Wrap(Chunk, Env, Upvalues)
            ]]..posstr..[[
        
            local function OnError(Err, Position) -- Handle your errors in whatever way.
                print(Err, Position);
            end;
        
            return function(...)
                local InstrPoint, Top	= 1, -1;
                local Vararg, Varargsz	= {}, Select('#', ...) - 1;
        
                local GStack	= {};
                local Lupvals	= {};
                local Stack		= setmetatable({}, {
                    __index		= GStack;
                    __newindex	= function(_, Key, Value)
                        if (Key > Top) then
                            Top	= Key;
                        end;
        
                        GStack[Key]	= Value;
                    end;
                });


            local function Loop()
                local Inst, Enum;
    
                while true do
                    Inst		= Instr[InstrPoint];
                    Enum		= Inst[6];
                    InstrPoint	= InstrPoint + 1;
]]        

    local loop = [[
		local Args	= {...};
        local int = Chunk[28];

		for Idx = 0, Varargsz do
			if (Idx >= int) then
				Vararg[Idx - int] = Args[Idx + 1];
			else
				Stack[Idx] = Args[Idx + 1];
			end;
		end;

		local A, B, C	= pcall(Loop); -- Pcalling to allow yielding

		if A then -- We're always expecting this to come out true (because errorless code)
			if B and (C > 0) then -- So I flipped the conditions.
				return unpack(B, 1, C);
			end;

			return;
		else
			OnError(B, InstrPoint - 1); -- Didn't get time to test the `-1` honestly, but I assume it works properly
		end;
	end;
end;

local load_bytecode = function(BCode, Env) 
	local Buffer	= GetMeaning(BCode);

	return Wrap(Buffer, Env or getfenv(0)), Buffer;
end;
        
        load_bytecode("]]..string.gsub(bytecode, ".", function(c) return "\\" .. c:byte() end)..[[")()
    ]]

    return start, loop;
end;


return Chunk, VM