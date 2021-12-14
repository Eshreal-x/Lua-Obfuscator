






local ret = function(settings)   
    local Decode_Instructions = [[
		for Idx = 1, gInt() do 
			local Data	= gBits32();
			local Opco = gBit(Data,]]..settings.ABC.Opcode[1]..",".. settings.ABC.Opcode[2]..[[);
			local Type	= Opcode[Opco];
			local Mode  = Opmode[Opco];

			local Inst	= {
				[6]	= Opco;
				Value	= Data;
			};
	
			if Type == "ABC" then
				Inst[1] = gBit(Data,]].. settings['ABC'].A[1]..","..settings['ABC'].A[2]..[[);
				Inst[2] = gBit(Data,]].. settings['ABC'].C[1]..","..settings['ABC'].C[2]..[[);
				Inst[3] = gBit(Data,]] ..settings['ABC'].B[1]..","..settings['ABC'].B[2]..[[);
			elseif Type == "ABx" then
				Inst[1] = gBit(Data,]].. settings['ABx'].A[1]..","..settings['ABx'].A[2]..[[);
				Inst[2] = gBit(Data,]].. settings['ABx'].B[1]..","..settings['ABx'].B[2]..[[);
			elseif Type == "AsBx" then
				Inst[1] = gBit(Data,]].. settings['AsBx'].A[1]..","..settings['AsBx'].A[2]..[[);
				Inst[2] = gBit(Data,]].. settings['AsBx'].B[1]..","..settings['AsBx'].B[2]..[[) - 131071;
			end

			
			do 
				
				if Opco == ]]..settings.Opcodes.ROpcodes[26]..[[ or Opco == ]]..settings.Opcodes.ROpcodes[27]..[[ then 
					Inst[3] = Inst[3] == 0;
				end

				
				if Opco == ]]..settings.Opcodes.ROpcodes[23]..[[ or Opco == ]]..settings.Opcodes.ROpcodes[24]..[[ or Opco == ]]..settings.Opcodes.ROpcodes[25]..[[ then  
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
        ]]
   
       
    local Decode_Constants = [[
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
        ]]
        
        local Decode_Prototypes = [[
        do
            for Idx = 1, gInt() do
                Proto[Idx - 1]	= ChunkDecode();
            end;
        end]]
        
        local str = "";
        local struct = {
            Instructions = Decode_Instructions,
            Constants    = Decode_Constants,
            Prototypes   = Decode_Prototypes
        }
    
        for i,v in pairs(settings.Positions) do
            str = str.. "\n" .. struct[v]
        end;


        return str;  
   end

   return ret;