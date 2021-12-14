local Opcode = {
	[1] = "ABC",
	[2] = "ABC",
	[3] = "ABC",
	[4] = "AsBx",
	[5] = "ABC",
	[6] = "ABC",
	[7] = "ABC",
	[8] = "ABC",
	[9] = "ABx",
	[10] = "ABx",
	[11] = "ABC",
	[12] = "ABC",
	[13] = "ABC",
	[14] = "ABC",
	[15] = "ABC",
	[16] = "ABC",
	[17] = "AsBx",
	[18] = "ABC",
	[19] = "ABC",
	[20] = "ABx",
	[21] = "ABC",
	[22] = "ABC",
	[23] = "AsBx",
	[24] = "ABC",
	[25] = "ABx",
	[26] = "ABC",
	[27] = "ABC",
	[28] = "ABC",
	[29] = "ABC",
	[30] = "ABC",
	[31] = "ABC",
	[32] = "ABC",
	[36] = "ABC",
	[37] = "ABC",
	[33] = "ABC",
	[34] = "ABC",
	[35] = "ABC",
	[0] = "ABC"
}

local Opmode ={
	[1] = {
		["c"] = "OpArgK",
		["b"] = "OpArgK"
	},
	[2] = {
		["c"] = "OpArgK",
		["b"] = "OpArgK"
	},
	[3] = {
		["c"] = "OpArgK",
		["b"] = "OpArgK"
	},
	[4] = {
		["c"] = "OpArgN",
		["b"] = "OpArgR"
	},
	[5] = {
		["c"] = "OpArgU",
		["b"] = "OpArgU"
	},
	[6] = {
		["c"] = "OpArgK",
		["b"] = "OpArgK"
	},
	[7] = {
		["c"] = "OpArgK",
		["b"] = "OpArgK"
	},
	[8] = {
		["c"] = "OpArgR",
		["b"] = "OpArgR"
	},
	[9] = {
		["c"] = "OpArgN",
		["b"] = "OpArgK"
	},
	[10] = {
		["c"] = "OpArgN",
		["b"] = "OpArgK"
	},
	[11] = {
		["c"] = "OpArgN",
		["b"] = "OpArgR"
	},
	[12] = {
		["c"] = "OpArgK",
		["b"] = "OpArgR"
	},
	[13] = {
		["c"] = "OpArgU",
		["b"] = "OpArgN"
	},
	[14] = {
		["c"] = "OpArgN",
		["b"] = "OpArgR"
	},
	[15] = {
		["c"] = "OpArgU",
		["b"] = "OpArgU"
	},
	[16] = {
		["c"] = "OpArgN",
		["b"] = "OpArgU"
	},
	[17] = {
		["c"] = "OpArgN",
		["b"] = "OpArgR"
	},
	[18] = {
		["c"] = "OpArgK",
		["b"] = "OpArgK"
	},
	[19] = {
		["c"] = "OpArgK",
		["b"] = "OpArgK"
	},
	[20] = {
		["c"] = "OpArgN",
		["b"] = "OpArgU"
	},
	[21] = {
		["c"] = "OpArgU",
		["b"] = "OpArgU"
	},
	[22] = {
		["c"] = "OpArgK",
		["b"] = "OpArgR"
	},
	[23] = {
		["c"] = "OpArgN",
		["b"] = "OpArgR"
	},
	[24] = {
		["c"] = "OpArgK",
		["b"] = "OpArgK"
	},
	[25] = {
		["c"] = "OpArgN",
		["b"] = "OpArgK"
	},
	[26] = {
		["c"] = "OpArgN",
		["b"] = "OpArgR"
	},
	[27] = {
		["c"] = "OpArgU",
		["b"] = "OpArgU"
	},
	[28] = {
		["c"] = "OpArgU",
		["b"] = "OpArgU"
	},
	[29] = {
		["c"] = "OpArgN",
		["b"] = "OpArgR"
	},
	[30] = {
		["c"] = "OpArgN",
		["b"] = "OpArgU"
	},
	[31] = {
		["c"] = "OpArgN",
		["b"] = "OpArgN"
	},
	[32] = {
		["c"] = "OpArgU",
		["b"] = "OpArgR"
	},
	[36] = {
		["c"] = "OpArgN",
		["b"] = "OpArgU"
	},
	[37] = {
		["c"] = "OpArgN",
		["b"] = "OpArgU"
	},
	[33] = {
		["c"] = "OpArgU",
		["b"] = "OpArgR"
	},
	[34] = {
		["c"] = "OpArgK",
		["b"] = "OpArgK"
	},
	[35] = {
		["c"] = "OpArgK",
		["b"] = "OpArgK"
	},
	[0] = {
		["c"] = "OpArgN",
		["b"] = "OpArgR"
	}
}


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
                
                local Chunk = {
Instr,
Const,
Proto,
};
                
                Chunk[4] = gBits8();
                Chunk[28] = gBits8();
                gBits8();
                gBits8();

                local ConstantReferences = {};    
    

		for Idx = 1, gInt() do 
			local Data	= gBits32();
			local Opco = gBit(Data,1,6);
			local Type	= Opcode[Opco];
			local Mode  = Opmode[Opco];

			local Inst	= {
				[6]	= Opco;
				Value	= Data;
			};
	
			if Type == "ABC" then
				Inst[1] = gBit(Data,25,32);
				Inst[2] = gBit(Data,7,15);
				Inst[3] = gBit(Data,16,24);
			elseif Type == "ABx" then
				Inst[1] = gBit(Data,25,32);
				Inst[2] = gBit(Data,7,24);
			elseif Type == "AsBx" then
				Inst[1] = gBit(Data,7,14);
				Inst[2] = gBit(Data,15,32) - 131071;
			end

			
			do 
				
				if Opco == 32 or Opco == 33 then 
					Inst[3] = Inst[3] == 0;
				end

				
				if Opco == 3 or Opco == 24 or Opco == 1 then  
					Inst[1] = Inst[1] ~= 0;
				end 

				
				if Mode.b == 'OpArgK' then
					Inst[3] = Inst[3] or false;
					if Inst[2] >= 256 then 
						local Cons = Inst[2] - 256;
						Inst[4] = Cons;

						local ReferenceData = ConstantReferences[Cons];
						if not ReferenceData then 
							ReferenceData = {};
							ConstantReferences[Cons] = ReferenceData;
						end

						ReferenceData[#ReferenceData + 1] = {Inst = Inst, Register = 4}
					end
				end 

		
				if Mode.c == 'OpArgK' then
					Inst[4] = Inst[4] or false
					if Inst[3] >= 256 then 
						local Cons = Inst[3] - 256;
						Inst[5] = Cons;

						local ReferenceData = ConstantReferences[Cons];
						if not ReferenceData then 
							ReferenceData = {};
							ConstantReferences[Cons] = ReferenceData;
						end

						ReferenceData[#ReferenceData + 1] = {Inst = Inst, Register = 5}
					end
				end 
			end

			Instr[Idx]	= Inst;
		end;
        
        for Idx = 1, gInt() do
			local Type	= gBits8();
			local Cons;

			if (Type == 1) then
				Cons	= (gBits8() ~= 0);
			elseif (Type == 3) then
				Cons	= gFloat();
			elseif (Type == 4) then
				Cons	= Sub(gString(), 1, -2);
			end;

			
			local Refs = ConstantReferences[Idx - 1];
			if Refs then 
				for i = 1, #Refs do
					Refs[i].Inst[Refs[i].Register] = Cons
				end 
			end

			
			Const[Idx - 1]	= Cons;
		end;
        
        do
            for Idx = 1, gInt() do
                Proto[Idx - 1]	= ChunkDecode();
            end;
        end
    
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
end






        local function _Returns(...)
            return Select('#', ...), {...};
        end;
        
        local function Wrap(Chunk, Env, Upvalues)
            local Instr = Chunk[1];
local Const = Chunk[2];
local Proto = Chunk[3];
        
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


if (Enum == 0) then -- LEN
Stack[Inst[1]] = #Stack[Inst[2]];

elseif (Enum == 2) then -- MOD
local Stk = Stack;
Stk[Inst[1]]	= (Inst[4] or Stk[Inst[2]]) % (Inst[5] or Stk[Inst[3]]);

elseif (Enum == 3) then -- EQ
local Stk = Stack;
local B = Inst[4] or Stk[Inst[2]];
local C = Inst[5] or Stk[Inst[3]];
if (B == C) ~= Inst[1] then
InstrPoint	= InstrPoint + 1;
end;

elseif (Enum == 4) then -- JMP
InstrPoint = InstrPoint + Inst[2];

elseif (Enum == 5) then -- LOADBOOL
Stack[Inst[1]]	= (Inst[2] ~= 0);
if (Inst[3] ~= 0) then
InstrPoint	= InstrPoint + 1;
end;

elseif (Enum == 6) then -- POW
local Stk = Stack;
Stk[Inst[1]] = (Inst[4] or Stk[Inst[2]]) ^ (Inst[5] or Stk[Inst[3]]);

elseif (Enum == 7) then -- SETTABLE
local Stk = Stack
Stk[Inst[1]][Inst[4] or Stk[Inst[2]]] = Inst[5] or Stk[Inst[3]];

elseif (Enum == 8) then -- CONCAT
local Stk	= Stack;
local B = Inst[2];
local K = Stk[B];
for Idx = B + 1, Inst[3] do
K = K .. Stk[Idx];
end;
Stack[Inst[1]] = K;


elseif (Enum == 10) then -- GETGLOBAL
Stack[Inst[1]]	= Env[Const[Inst[2]]];

elseif (Enum == 12) then -- SELF
local Stk	= Stack;
local A = Inst[1];
local B = Stk[Inst[2]];
local C = Inst[5] or Stk[Inst[3]];
Stk[A + 1] = B;
Stk[A] = B[C];

elseif (Enum == 14) then -- NOT
Stack[Inst[1]] = (not Stack[Inst[2]]);

elseif (Enum == 16) then -- SETUPVAL
Upvalues[Inst[2]]	= Stack[Inst[1]];

elseif (Enum == 20) then -- CLOSURE
local NewProto = Proto[Inst[2]];
local Stk = Stack;
local Indexes;
local NewUvals;
if (NewProto[4] ~= 0) then
Indexes = {};
NewUvals = setmetatable({}, {
__index = function(_, Key)
local Val = Indexes[Key];
return Val[1][Val[2]];
end,
__newindex = function(_, Key, Value)
local Val = Indexes[Key];
Val[1][Val[2]]	= Value;
end;
}
);
for Idx = 1, NewProto[4] do
local Mvm	= Instr[InstrPoint];
if (Mvm[6] == 29) then
Indexes[Idx - 1] = {Stk, Mvm[2]};
elseif (Mvm[6] == 30) then
Indexes[Idx - 1] = {Upvalues, Mvm[2]};
end;
InstrPoint = InstrPoint + 1;
end;
Lupvals[#Lupvals + 1] = Indexes;
end;
Stk[Inst[1]] = Wrap(NewProto, Env, NewUvals);

elseif (Enum == 24) then -- LT
local Stk = Stack;
local B = Inst[4] or Stk[Inst[2]];
local C = Inst[5] or Stk[Inst[3]];
if (B < C) ~= Inst[1] then
InstrPoint	= InstrPoint + 1;
end;

elseif (Enum == 28) then -- TAILCALL
local A = Inst[1];
local B	= Inst[2];
local Stk	= Stack;
local Args, Results;
local Limit;
local Rets = 0;
Args = {};
if (B ~= 1) then
if (B ~= 0) then
Limit = A + B - 1;
else
Limit = Top;
end;
for Idx = A + 1, Limit do
Args[#Args + 1] = Stk[Idx];
end;
Results = {Stk[A](unpack(Args, 1, Limit - A))};
else
Results = {Stk[A]()};
end;
for Index in pairs(Results) do
if (Index > Rets) then
Rets = Index;
end;
end;
return Results, Rets;

elseif (Enum == 32) then -- TEST
if Inst[3] then
if Stack[Inst[1]] then
InstrPoint = InstrPoint + 1;
end
elseif Stack[Inst[1]] then
else
InstrPoint = InstrPoint + 1;
end;

elseif (Enum == 33) then -- TESTSET
local B = Stack[Inst[2]];
if Inst[3] then
 if B then
InstrPoint = InstrPoint + 1;
else
Stack[Inst[1]] = B;
end;
elseif B then
Stack[Inst[1]] = B;
else
InstrPoint = InstrPoint + 1;
end;

elseif (Enum == 17) then -- FORLOOP
local A = Inst[1];
local Stk = Stack;
local Step = Stk[A + 2];
local Index	= Stk[A] + Step;
Stk[A]	= Index;
if (Step > 0) then
if Index <= Stk[A + 1] then
InstrPoint	= InstrPoint + Inst[2];
Stk[A + 3] = Index;
end;
else
if Index >= Stk[A + 1] then
InstrPoint	= InstrPoint + Inst[2];
Stk[A + 3] = Index;
end;
end;

elseif (Enum == 21) then -- SETLIST
local A = Inst[1];
local B	= Inst[2];
local C	= Inst[3];
local Stk = Stack;
if (C == 0) then
InstrPoint = InstrPoint + 1;
C = Instr[InstrPoint].Value;
end;
local Offset = (C - 1) * 50;
local T	= Stk[A];
if (B == 0) then
B = Top - A;
end;
for Idx = 1, B do
T[Offset + Idx] = Stk[A + Idx];
end;

elseif (Enum == 25) then -- LOADK
Stack[Inst[1]]	= Const[Inst[2]];

elseif (Enum == 29) then -- MOVE
Stack[Inst[1]]	= Stack[Inst[2]];

elseif (Enum == 34) then -- MUL
local Stk = Stack;
Stk[Inst[1]] = (Inst[4] or Stk[Inst[2]]) * (Inst[5] or Stk[Inst[3]]);

elseif (Enum == 9) then -- SETGLOBAL
Env[Const[Inst[2]]] = Stack[Inst[1]];

elseif (Enum == 11) then -- LOADNIL
local Stk	= Stack;
for Idx = Inst[1], Inst[2] do
Stk[Idx]	= nil;
end;

elseif (Enum == 13) then -- TFORLOOP
local A = Inst[1];
local C	= Inst[3];
local Stk = Stack;
local Offset = A + 2;
local Result = {Stk[A](Stk[A + 1], Stk[A + 2])};
for Idx = 1, C do
Stack[Offset + Idx] = Result[Idx];
end;
if (Stk[A + 3] ~= nil) then
Stk[A + 2]	= Stk[A + 3];
else
InstrPoint	= InstrPoint + 1;
end;

elseif (Enum == 15) then -- CALL
local A	= Inst[1];
local B	= Inst[2];
local C	= Inst[3];
local Stk	= Stack;
local Args, Results;
local Limit, Edx;
Args	= {};
if (B ~= 1) then
if (B ~= 0) then
Limit = A + B - 1;
else
Limit = Top;
end;
Edx	= 0;
for Idx = A + 1, Limit do
Edx = Edx + 1;
Args[Edx] = Stk[Idx];
end;
Limit, Results = _Returns(Stk[A](unpack(Args, 1, Limit - A)));
else
Limit, Results = _Returns(Stk[A]());
end;
Top = A - 1;
if (C ~= 1) then
if (C ~= 0) then
Limit = A + C - 2;
else
Limit = Limit + A - 1;
end;
Edx	= 0;
for Idx = A, Limit do
Edx = Edx + 1;
Stk[Idx] = Results[Edx];
end;
end;

elseif (Enum == 18) then -- ADD
local Stk = Stack;
Stk[Inst[1]] = (Inst[4] or Stk[Inst[2]]) + (Inst[5] or Stk[Inst[3]]);

elseif (Enum == 22) then -- GETTABLE
local Stk	= Stack;
Stk[Inst[1]] = Stk[Inst[2]][Inst[5] or Stk[Inst[3]]];

elseif (Enum == 26) then -- UNM
Stack[Inst[1]] = -Stack[Inst[2]];

elseif (Enum == 30) then -- GETUPVAL
Stack[Inst[1]]	= Upvalues[Inst[2]];

elseif (Enum == 36) then -- VARARG
local A = Inst[1];
local B	= Inst[2];
local Stk, Vars	= Stack, Vararg;
Top = A - 1;
for Idx = A, A + (B > 0 and B - 1 or Varargsz) do
Stk[Idx]	= Vars[Idx - A];
end;

elseif (Enum == 37) then -- RETURN
local A = Inst[1];
local B	= Inst[2];
local Stk = Stack;
local Edx, Output;
local Limit;
if (B == 1) then
return;
elseif (B == 0) then
Limit = Top;
else
Limit = A + B - 2;
end;
Output = {};
Edx = 0;
for Idx = A, Limit do
Edx	= Edx + 1;
Output[Edx] = Stk[Idx];
end;
return Output, Edx;

elseif (Enum == 35) then -- DIV
local Stk = Stack;
Stk[Inst[1]] = (Inst[4] or Stk[Inst[2]]) / (Inst[5] or Stk[Inst[3]]);

elseif (Enum == 31) then -- CLOSE
local A = Inst[1];
local Cls = {};
for Idx = 1, #Lupvals do
local List = Lupvals[Idx];
for Idz = 0, #List do
local Upv = List[Idz];
local Stk = Upv[1];
local Pos = Upv[2];
if (Stk == Stack) and (Pos >= A) then
Cls[Pos] = Stk[Pos];
Upv[1] = Cls;
end;
end;
end;

elseif (Enum == 1) then -- LE
local Stk = Stack;
local B = Inst[4] or Stk[Inst[2]];
local C = Inst[5] or Stk[Inst[3]];
if (B <= C) ~= Inst[1] then
InstrPoint	= InstrPoint + 1;
end;

elseif (Enum == 19) then -- SUB
local Stk = Stack;
Stk[Inst[1]] = (Inst[4] or Stk[Inst[2]]) - (Inst[5] or Stk[Inst[3]]);

elseif (Enum == 23) then -- FORPREP
local A = Inst[1];
local Stk = Stack;
Stk[A] = assert(tonumber(Stk[A]), '`for` initial value must be a number');
Stk[A + 1] = assert(tonumber(Stk[A + 1]), '`for` limit must be a number');
Stk[A + 2] = assert(tonumber(Stk[A + 2]), '`for` step must be a number');
Stk[A]	= Stk[A] - Stk[A + 2];
InstrPoint	= InstrPoint + Inst[2];

elseif (Enum == 27) then -- NEWTABLE
Stack[Inst[1]] = {};

 end;
end;
end;


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
        
        load_bytecode("\27\65\113\117\97\105\0\1\4\4\4\2\0\12\0\0\0\64\83\99\114\105\112\116\46\116\120\116\0\1\0\0\0\0\0\0\0\0\0\2\0\88\0\0\0\89\0\0\0\9\0\0\0\217\0\0\0\137\0\0\0\69\0\0\0\9\1\0\0\74\1\0\0\138\0\0\1\82\128\129\1\143\128\0\0\74\1\0\0\10\1\0\1\67\0\131\1\4\0\0\128\5\128\0\1\69\0\0\1\143\128\0\0\20\0\0\0\201\1\0\0\25\2\0\0\89\2\0\1\25\2\0\2\23\0\15\128\74\1\0\4\221\0\0\5\143\128\0\4\89\0\0\4\9\0\0\4\217\0\0\4\137\0\0\4\69\0\0\4\9\1\0\4\74\1\0\4\138\0\0\5\82\129\129\5\143\128\0\4\74\1\0\4\10\1\0\5\67\1\131\1\4\0\0\128\5\128\0\5\69\0\0\5\143\128\0\4\84\0\0\4\201\1\0\4\25\2\0\4\89\2\0\5\25\2\0\6\23\193\7\128\74\1\0\8\221\1\0\9\143\128\0\8\89\0\0\8\9\0\0\8\217\0\0\8\137\0\0\8\69\0\0\8\9\1\0\8\74\1\0\8\138\0\0\9\82\130\129\9\143\128\0\8\74\1\0\8\10\1\0\9\67\2\131\1\4\0\0\128\5\128\0\9\69\0\0\9\143\128\0\8\148\0\0\8\201\1\0\8\25\2\0\8\89\2\0\9\25\2\0\10\23\130\0\128\74\1\0\12\221\2\0\13\143\128\0\12\17\194\254\127\202\1\0\8\79\128\0\8\17\129\247\127\202\1\0\4\79\128\0\4\17\64\240\127\202\1\0\0\79\128\0\0\101\0\0\0\10\0\0\0\4\2\0\0\0\97\0\4\12\0\0\0\72\101\108\108\111\32\119\111\114\108\100\0\4\2\0\0\0\98\0\3\0\0\0\0\0\0\0\64\4\2\0\0\0\99\0\4\6\0\0\0\112\114\105\110\116\0\1\0\4\2\0\0\0\100\0\3\0\0\0\0\0\0\240\63\3\0\0\0\0\0\0\52\64\3\0\0\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0\8\0\0\0\10\0\0\0\74\0\0\1\143\128\0\0\20\0\0\0\137\0\0\0\138\0\0\0\79\128\0\0\101\0\0\0\3\0\0\0\4\6\0\0\0\112\114\105\110\116\0\4\2\0\0\0\97\0\4\2\0\0\0\101\0\1\0\0\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0\4\0\0\0\10\0\0\0\89\0\0\1\143\128\0\0\101\0\0\0\2\0\0\0\4\6\0\0\0\112\114\105\110\116\0\4\9\0\0\0\117\101\119\102\105\117\101\102\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0\8\0\0\0\10\0\0\0\74\0\0\1\143\128\0\0\20\0\0\0\137\0\0\0\138\0\0\0\79\128\0\0\101\0\0\0\3\0\0\0\4\6\0\0\0\112\114\105\110\116\0\4\2\0\0\0\97\0\4\2\0\0\0\101\0\1\0\0\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0\4\0\0\0\10\0\0\0\89\0\0\1\143\128\0\0\101\0\0\0\2\0\0\0\4\6\0\0\0\112\114\105\110\116\0\4\9\0\0\0\117\101\119\102\105\117\101\102\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0\8\0\0\0\10\0\0\0\74\0\0\1\143\128\0\0\20\0\0\0\137\0\0\0\138\0\0\0\79\128\0\0\101\0\0\0\3\0\0\0\4\6\0\0\0\112\114\105\110\116\0\4\2\0\0\0\97\0\4\2\0\0\0\101\0\1\0\0\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0\4\0\0\0\10\0\0\0\89\0\0\1\143\128\0\0\101\0\0\0\2\0\0\0\4\6\0\0\0\112\114\105\110\116\0\4\9\0\0\0\117\101\119\102\105\117\101\102\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0")()
    