local bit = loadfile("./Library/BitFunctions.lua")()


local function toBase256(n)
    local f = math.floor;
    local c = string.char;
    return c(f(n % 256)) .. c(f(n / 256 % 256)) .. c(f(n / 65536 % 256)) .. c(f(n / 16777216 % 256));
end;



local types = {
	"ABC",  "ABx", "ABC",  "ABC",
	"ABC",  "ABx", "ABC",  "ABx",
	"ABC",  "ABC", "ABC",  "ABC",
	"ABC",  "ABC", "ABC",  "ABC",
	"ABC",  "ABC", "ABC",  "ABC",
	"ABC",  "ABC", "AsBx", "ABC",
	"ABC",  "ABC", "ABC",  "ABC",
	"ABC",  "ABC", "ABC",  "AsBx",
	"AsBx", "ABC", "ABC", "ABC",
	"ABx",  "ABC",
}

local names = {
	"MOVE",     "LOADK",     "LOADBOOL", "LOADNIL",
	"GETUPVAL", "GETGLOBAL", "GETTABLE", "SETGLOBAL",
	"SETUPVAL", "SETTABLE",  "NEWTABLE", "SELF",
	"ADD",      "SUB",       "MUL",      "DIV",
	"MOD",      "POW",       "UNM",      "NOT",
	"LEN",      "CONCAT",    "JMP",      "EQ",
	"LT",       "LE",        "TEST",     "TESTSET",
	"CALL",     "TAILCALL",  "RETURN",   "FORLOOP",
	"FORPREP",  "TFORLOOP",  "SETLIST",  "CLOSE",
	"CLOSURE",  "VARARG"
};



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




local function decode_bytecode(bytecode, settings)
    local level = true;
	local index = 1
	local big_endian = false
    local int_size;
    local size_t;

    -- Actual binary decoding functions. Dependant on the bytecode.
    local get_int, get_size_t;

	-- Binary decoding helper functions
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
			return (-2*get_bits(b, 32)+1)*(2^(get_bits(b, 21, 31)-1023))*((get_bits(b, 1, 20)*(2^32) + a)/(2^52)+1)
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


    local function generateProto(toplevel, sizeupvalues, numparams, sourcename)
        local prototype = {};
        prototype[2] = toBase256(1);
        prototype[3] = toBase256(0);
        prototype[4] = string.char(sizeupvalues);
        prototype[5] = string.char(numparams);
        prototype[7] = "\0";
        if toplevel then
            if not sourcename then
                sourcename = "@kekw.lua";
            end;
            prototype[1] = toBase256(#sourcename + 1) .. sourcename .. "\0";
            prototype[6] = "\2";
        else
            prototype[1] = "\0\0\0\0";
            prototype[6] = "\0";
        end;

        return table.concat(prototype);
    end;


	local function decode_chunk()
        local toplevel = level;
        level = false;

		local chunk;
		local instructions = {};
		local constants    = {};
		local prototypes   = {};

		chunk = {
			Instructions = instructions;
			Constants    = constants;
			Prototypes   = prototypes;
		};


		chunk.name       = get_string();-- Function name
		chunk.first_line = get_int();	-- First line
		chunk.last_line  = get_int();	-- Last  line

        if chunk.name then chunk.name = chunk.name:sub(1, -2); end

		chunk.sizeupvalues  = get_int8();
		chunk.numparams     = get_int8();
		chunk.varg          = get_int8();
		chunk.stack         = get_int8();



		-- Decode instructions
		do
			local sizecode = get_int32();
            if settings.Debugging then print('sizecode: ', sizecode) end;
            instructions[1] = toBase256(sizecode);

			for i = 1, sizecode do
				local data   = get_int32();
				local opcode = get_bits(data, 1, 6);
				local type   = types[opcode + 1];
			
				local t = settings[type];
				local A, B, C, newInstr;

				A = get_bits(data, 7, 14);
				if type == "ABC" then
					B = get_bits(data, 24, 32);
					C = get_bits(data, 15, 23);
                   -- print("opcode:" .. names[opcode + 1] .. "(" .. opcode .. ")","\tA:"..A, "B:"..B, "C:"..C);
				elseif type == "ABx" then
					B = get_bits(data, 15, 32);
                   -- print("opcode:" .. names[opcode + 1] .. "(" .. opcode .. ")","\tA:"..A,"Bx:"..B);
				elseif type == "AsBx" then
					B = get_bits(data, 15, 32) - 131071;
                   -- print("opcode:" .. names[opcode + 1] .. "(" .. opcode .. ")","\tA:"..A,"sBx:"..B);
				end

				local Instr = {
					Opcode = settings.Opcodes.ROpcodes[opcode],
					A = A,
					B = B,
					C = C
				}
               
            --[[
                32 bit integer
                    ABC: (8 bit B)(8 bit C)(8 bit A)(6 bit opcode)
                    ABx: (18 bit Bx)(8 bit A)(6 bit opcode)
                    AsBx: (18 bit sBx)(8 bit A)(6 bit opcode) - (signed (- 131071))
            ]]
				
			
			

			for i,v in pairs(t) do
				if type == 'AsBx' and i == 'B' then 
					Instr[i] = bit.lshift(Instr[i] + 131071, t[i][1] - 1);
				elseif type == 'ABC' and (i == 'B') then 
					Instr[i] = bit.lshift(Instr[i] or 0, t['C'][1] - 1);
				elseif type == 'ABC' and (i == 'C') then 
					Instr[i] = bit.lshift(Instr[i] or 0, t['B'][1] - 1);
				else
					Instr[i] = bit.lshift(Instr[i] or 0, t[i][1] - 1);
				end;
			end;    
			


			newInstr = bit.bor(Instr.Opcode, Instr.A or 0);
			newInstr = bit.bor(newInstr, Instr.A or 0);
			newInstr = bit.bor(newInstr, Instr.B or 0);
			newInstr = bit.bor(newInstr, Instr.C or 0);
			
			
			local opC = get_bits(newInstr, t.Opcode[1], t.Opcode[2]);
			local bA  = get_bits(newInstr, t.A[1], t.A[2]);
			local bB  = get_bits(newInstr, t.B[1], t.B[2]);
			local bC  = get_bits(newInstr, t.C and t.C[1] or 0, t.C and t.C[2] or 0);

			local opT = settings.Opcodes.Opcodes[opC].type;
			local opN = settings.Opcodes.Opcodes[opC].name;

                -- print each opcode and registers
			if opT == "ABC" and settings.Debugging then
				print("opcode:" .. opN .. "(" .. opC .. ") : ".."\t\tA : "..bA.."\tB   : "..bB.."\t\tC : "..bC);
			elseif opT == "ABx" and settings.Debugging then
				print("opcode:" .. opN .. "(" .. opC .. ") : ".."\t\tA : "..bA.."\tBx  : "..bB);
			elseif opT == "AsBx" and settings.Debugging then
				print("opcode:" .. opN .. "(" .. opC .. ") : ".."\t\tA : "..bA.."\tsBx : "..bB);
			end;


                --[[print(string.gsub(toBase256(data), ".", function(c) return "\\" .. c:byte() end));
                print(string.gsub(toBase256(newInstr), ".", function(c) return "\\" .. c:byte() end));
                print('__________________________')]]
                


				instructions[i + 1] = toBase256(newInstr);
			end
		end



		-- Decode constants
		do
            local sizek = get_int32();
            if settings.Debugging then print('\n\nsizek: ', sizek) end;
			constants[1] = toBase256(sizek);
			
			for i = 1, sizek do
				local Cons, constant;
				local t = get_int8();

		

				if t == 1 then
                    Cons = string.char(get_int8())

                    constant = "\1" .. Cons 
				elseif t == 3 then
                    Cons = string.sub(bytecode, index, index + 7);

                    get_float64();
                    
                    constant = "\3" .. Cons;
				elseif t == 4 then
                    local len = get_int32();
                    Cons	= get_string(len);

                    constant = "\4" .. toBase256(len) .. Cons;
				else
					constant = string.char(t);
				end

                --print(type, 'data: ',type == 1 and Cons ~= 0 or type == 4 and Cons:sub(1, -2) or Cons);


				constants[i + 1] = constant;
			end
		end


		-- Decode Prototypes
		do
			local sizep = get_int32();
			if settings.Debugging then print('\n\nsizep: ', sizep) end;
            prototypes[1] = toBase256(sizep);
			for i = 1, sizep do
				local chunk = decode_chunk();
				prototypes[i + 1] = chunk;
			end;
		end


		do -- Debugging
			for i = 1, get_int32() do
				get_int32()
			end;

			for i = 1, get_int32() do -- Locals in stack.
				get_string(); -- Name of local.
				get_int32(); -- Starting point.
				get_int32(); -- End point.
			end;

			for i = 1, get_int32() do -- Upvalues.
				get_string(); -- Name of upvalue.
			end;
		end;



		local BT = generateProto(toplevel, chunk.sizeupvalues, chunk.numparams, chunk.name) 
	--	generateProto(toplevel, chunk.sizeupvalues, chunk.numparams, chunk.name)  .. table.concat(chunk.instructions) .. table.concat(chunk.constants) .. table.concat(chunk.prototypes) .. string.rep("\0\0\0\0", 3);
		for i, v in pairs(settings.Positions) do
			BT = BT .. table.concat(chunk[v]);
		end;
		BT = BT .. string.rep("\0\0\0\0", 3);
		return BT;
	end;



    	-- Verify bytecode header
	do
		assert(get_string(4) == "\27Lua", "Lua bytecode expected.");
		assert(get_int8() == 0x51, "Only Lua 5.1 is supported.");
		get_int8(); 	-- Oficial bytecode
		big_endian = (get_int8() == 0);
        int_size = get_int8();
        size_t   = get_int8();

        if int_size == 4 then
            get_int = get_int32;
        elseif int_size == 8 then
            get_int = get_int64;
        else
	        -- TODO: refactor errors into table
            error("Unsupported bytecode target platform");
        end

        if size_t == 4 then
            get_size_t = get_int32;
        elseif size_t == 8 then
            get_size_t = get_int64;
        else
            error("Unsupported bytecode target platform");
        end

        assert(get_string(3) == "\4\8\0", "Unsupported bytecode target platform");
	end


	if settings.Debugging then
		return "\27Lua\81\0\1\4\4\4\8\0"..decode_chunk();
	else
		return "\27Aqua\105\0\1\4\4\4\2\0"..decode_chunk();
	end;
end



return decode_bytecode;