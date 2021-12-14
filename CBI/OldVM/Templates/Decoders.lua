local ret = function(settings)   
    local Decode_Instructions = [[
            do
                for i = 1, get_int32() do
                    local instruction = { };
            
                    local data   = get_int32();
                    local opcode = get_bits(data,]]..settings.ABC.Opcode[1]..",".. settings.ABC.Opcode[2]..[[);
                    local type   = types[opcode];
            
                    instruction.opcode = opcode;
                    instruction.type   = type;
            
            
                    if type == "ABC" then
                instruction.A = get_bits(data,]].. settings['ABC'].A[1]..","..settings['ABC'].A[2]..[[);
                instruction.B = get_bits(data,]].. settings['ABC'].C[1]..","..settings['ABC'].C[2]..[[);
                instruction.C = get_bits(data,]] ..settings['ABC'].B[1]..","..settings['ABC'].B[2]..[[);
                    elseif type == "ABx" then
                instruction.A = get_bits(data,]].. settings['ABx'].A[1]..","..settings['ABx'].A[2]..[[);
                        instruction.Bx = get_bits(data,]].. settings['ABx'].B[1]..","..settings['ABx'].B[2]..[[);
                    elseif type == "AsBx" then
                instruction.A = get_bits(data,]].. settings['AsBx'].A[1]..","..settings['AsBx'].A[2]..[[);
                        instruction.sBx = get_bits(data,]].. settings['AsBx'].B[1]..","..settings['AsBx'].B[2]..[[) - 131071;
                    end
            
                    Instructions[i] = instruction;
                end
            end
        ]]
   
       
    local Decode_Constants = [[
        do
            for i = 1, get_int32() do
                local constant = {};
                local type = get_int8();
                constant.type = type;
        
                if type == 1 then
                    constant.data = (get_int8() ~= 0);
                elseif type == 3 then
                    constant.data = get_float64();
                elseif type == 4 then
                    constant.data = get_string():sub(1, -2);
                end
        
                Constants[i-1] = constant;
            end
        end]]
        
        local Decode_Prototypes = [[
        do
            for i = 1, get_int32() do
                Prototypes[i-1] = decode_chunk();
            end
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