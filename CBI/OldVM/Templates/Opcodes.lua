local run = function(settings)
    local opcodes = {
        [1] = [[[]]..tostring(settings.Opcodes.ROpcodes[0])..[[]  = function(instruction)
            stack[instruction.A] = stack[instruction.B];
        end,]],
        [2] =  [[[]]..tostring(settings.Opcodes.ROpcodes[1])..[[]  = function(instruction)
            stack[instruction.A] = constants[instruction.Bx].data;
        end,]],

        [3] = [[[]]..tostring(settings.Opcodes.ROpcodes[2])..[[]  = function(instruction)
            stack[instruction.A] = instruction.B ~= 0
            if instruction.C ~= 0 then
                IP = IP + 1
            end
        end,]],
        [4] = [[[]]..tostring(settings.Opcodes.ROpcodes[3])..[[]  = function(instruction)	
            local stack = stack
            for i = instruction.A, instruction.B do
                stack[i] = nil
            end
        end,]],
        [5] = [[[]]..tostring(settings.Opcodes.ROpcodes[4])..[[] = function(instruction)	
            stack[instruction.A] = upvalues[instruction.B]
        end,]],
        [6] = [[[]]..tostring(settings.Opcodes.ROpcodes[5])..[[]  = function(instruction)	
            local key = constants[instruction.Bx].data;
            stack[instruction.A] = environment[key];
        end,]],
        [7] = [[[]]..tostring(settings.Opcodes.ROpcodes[6])..[[]  = function(instruction)	
            local C = instruction.C
            local stack = stack
            C = C > 255 and constants[C-256].data or stack[C]
            stack[instruction.A] = stack[instruction.B][C];
        end,]],
        [8] = [[[]]..tostring(settings.Opcodes.ROpcodes[7])..[[]  = function(instruction)	
            local key = constants[instruction.Bx].data;
            environment[key] = stack[instruction.A];
        end,]],
        [9] = [[[]]..tostring(settings.Opcodes.ROpcodes[8])..[[] = function (instruction)	
            upvalues[instruction.B] = stack[instruction.A]
        end,]],
        [10] = [[[]]..tostring(settings.Opcodes.ROpcodes[9])..[[] = function (instruction)	
            local B = instruction.B;
            local C = instruction.C;
            local stack, constants = stack, constants;
        
            B = B > 255 and constants[B-256].data or stack[B];
            C = C > 255 and constants[C-256].data or stack[C];
        
            stack[instruction.A][B] = C
        end,]],
        [11] = [[[]]..tostring(settings.Opcodes.ROpcodes[10])..[[] = function (instruction)	
            stack[instruction.A] = {}
        end,]],
        [12] = [[[]]..tostring(settings.Opcodes.ROpcodes[11])..[[] = function (instruction)
            local A = instruction.A
            local B = instruction.B
            local C = instruction.C
            local stack = stack
        
            B = stack[B]
            C = C > 255 and constants[C-256].data or stack[C]
        
            stack[A+1] = B
            stack[A]   = B[C]
        end,]],
        [13] = [[[]]..tostring(settings.Opcodes.ROpcodes[12])..[[] = function(instruction)
            local B = instruction.B;
            local C = instruction.C;
            local stack, constants = stack, constants;
        
            B = B > 255 and constants[B-256].data or stack[B];
            C = C > 255 and constants[C-256].data or stack[C];
        
            stack[instruction.A] = B+C;
        end,]],
        [14] = [[[]]..tostring(settings.Opcodes.ROpcodes[13])..[[] = function(instruction)
            local B = instruction.B;
            local C = instruction.C;
            local stack, constants = stack, constants;
        
            B = B > 255 and constants[B-256].data or stack[B];
            C = C > 255 and constants[C-256].data or stack[C];
        
            stack[instruction.A] = B - C;
        end,]],
        [15] = [[[]]..tostring(settings.Opcodes.ROpcodes[14])..[[] = function(instruction)
            local B = instruction.B;
            local C = instruction.C;
            local stack, constants = stack, constants;
        
            B = B > 255 and constants[B-256].data or stack[B];
            C = C > 255 and constants[C-256].data or stack[C];
        
            stack[instruction.A] = B * C;
        end,]],
        [16] = [[[]]..tostring(settings.Opcodes.ROpcodes[15])..[[] = function(instruction)
            local B = instruction.B;
            local C = instruction.C;
            local stack, constants = stack, constants;
        
            B = B > 255 and constants[B-256].data or stack[B];
            C = C > 255 and constants[C-256].data or stack[C];
        
            stack[instruction.A] = B / C;
        end,]],
        [17] = [[[]]..tostring(settings.Opcodes.ROpcodes[16])..[[] = function(instruction) 
            local B = instruction.B;
            local C = instruction.C;
            local stack, constants = stack, constants;
        
            B = B > 255 and constants[B-256].data or stack[B];
            C = C > 255 and constants[C-256].data or stack[C];
        
            stack[instruction.A] = B % C;
        end,]],
        [18] = [[[]]..tostring(settings.Opcodes.ROpcodes[17])..[[] = function(instruction)
            local B = instruction.B;
            local C = instruction.C;
            local stack, constants = stack, constants;
        
            B = B > 255 and constants[B-256].data or stack[B];
            C = C > 255 and constants[C-256].data or stack[C];
        
            stack[instruction.A] = B ^ C;
        end,]],
        [19] = [[[]]..tostring(settings.Opcodes.ROpcodes[18])..[[] = function(instruction)	
            stack[instruction.A] = -stack[instruction.B]
        end,]],
        [20] = [[[]]..tostring(settings.Opcodes.ROpcodes[19])..[[] = function(instruction)	
            stack[instruction.A] = not stack[instruction.B]
        end,]],
        [21] = [[[]]..tostring(settings.Opcodes.ROpcodes[20])..[[] = function(instruction)	
            stack[instruction.A] = #stack[instruction.B]
        end,]],
        [22] = [[[]]..tostring(settings.Opcodes.ROpcodes[21])..[[] = function(instruction)	
            local B = instruction.B
            local result = stack[B]
            for i = B+1, instruction.C do
                result = result .. stack[i]
            end
            stack[instruction.A] = result
        end,]],
        [23] = [[[]]..tostring(settings.Opcodes.ROpcodes[22])..[[] = function(instruction)	
            IP = IP + instruction.sBx
        end,]],
        [24] = [[[]]..tostring(settings.Opcodes.ROpcodes[23])..[[] = function(instruction)	
            local A = instruction.A
            local B = instruction.B
            local C = instruction.C
            local stack, constants = stack, constants
        
            A = A ~= 0
            if (B > 255) then B = constants[B-256].data else B = stack[B] end
            if (C > 255) then C = constants[C-256].data else C = stack[C] end
            if (B == C) ~= A then
                IP = IP + 1
            end
        end,]],
        [25] = [[[]]..tostring(settings.Opcodes.ROpcodes[24])..[[] = function(instruction)	
            local A = instruction.A
            local B = instruction.B
            local C = instruction.C
            local stack, constants = stack, constants
        
            A = A ~= 0
            B = B > 255 and constants[B-256].data or stack[B]
            C = C > 255 and constants[C-256].data or stack[C]
            if (B < C) ~= A then
                IP = IP + 1
            end
        end,]],
        [26] = [[[]]..tostring(settings.Opcodes.ROpcodes[25])..[[] = function(instruction)	
            local A = instruction.A
            local B = instruction.B
            local C = instruction.C
            local stack, constants = stack, constants
        
            A = A ~= 0
            B = B > 255 and constants[B-256].data or stack[B]
            C = C > 255 and constants[C-256].data or stack[C]
            if (B <= C) ~= A then
                IP = IP + 1
            end
        end,]],
        [27] = [[[]]..tostring(settings.Opcodes.ROpcodes[26])..[[] = function(instruction)	
            local A = stack[instruction.A];
            if (not not A) == (instruction.C == 0) then
                IP = IP + 1
            end
        end,]],
        [28] = [[[]]..tostring(settings.Opcodes.ROpcodes[27])..[[] = function(instruction)	
            local stack = stack
            local B = stack[instruction.B]
        
            if (not not B) == (instruction.C == 0) then
                IP = IP + 1
            else
                stack[instruction.A] = B
            end
        end,]],
        [29] = [[[]]..tostring(settings.Opcodes.ROpcodes[28])..[[] = function(instruction)	
            local A = instruction.A;
            local B = instruction.B;
            local C = instruction.C;
            local stack = stack;
            local args, results;
            local limit, loop
        
            args = {};
            if B ~= 1 then
                if B ~= 0 then
                    limit = A+B-1;
                else
                    limit = top
                end
        
                loop = 0
                for i = A+1, limit do
                    loop = loop + 1
                    args[loop] = stack[i];
                end
        
                limit, results = handle_return(stack[A](unpack(args, 1, limit-A)))
            else
                limit, results = handle_return(stack[A]())
            end
        
            top = A - 1
        
            if C ~= 1 then
                if C ~= 0 then
                    limit = A+C-2;
                else
                    limit = limit+A-1
                end
        
                loop = 0;
                for i = A, limit do
                    loop = loop + 1;
                    stack[i] = results[loop];
                end
            end
        end,]],
        [30] = [[[]]..tostring(settings.Opcodes.ROpcodes[29])..[[] = function (instruction)	
            local A = instruction.A;
            local B = instruction.B;
            local C = instruction.C;
            local stack = stack;
            local args, results;
            local top, limit, loop = top
        
            args = {};
            if B ~= 1 then
                if B ~= 0 then
                    limit = A+B-1;
                else
                    limit = top
                end
        
                loop = 0
                for i = A+1, limit do
                    loop = loop + 1
                    args[#args+1] = stack[i];
                end
        
                results = {stack[A](unpack(args, 1, limit-A))};
            else
                results = {stack[A]()};
            end
        
            return true, results
        end,]],
        [31] = [[[]]..tostring(settings.Opcodes.ROpcodes[30])..[[] = function(instruction) 
            local A = instruction.A;
            local B = instruction.B;
            local stack = stack;
            local limit;
            local loop, output;
        
            if B == 1 then
                return true;
            end
            if B == 0 then
                limit = top
            else
                limit = A + B - 2;
            end
        
            output = {};
            local loop = 0
            for i = A, limit do
                loop = loop + 1
                output[loop] = stack[i];
            end
            return true, output;
        end,]],
        [32] = [[[]]..tostring(settings.Opcodes.ROpcodes[31])..[[] = function(instruction)	
            local A = instruction.A
            local stack = stack
        
            local step = stack[A+2]
            local index = stack[A] + step
            stack[A] = index
        
            if step > 0 then
                if index <= stack[A+1] then
                    IP = IP + instruction.sBx
                    stack[A+3] = index
                end
            else
                if index >= stack[A+1] then
                    IP = IP + instruction.sBx
                    stack[A+3] = index
                end
            end
        end,]],
        [33] = [[[]]..tostring(settings.Opcodes.ROpcodes[32])..[[] = function(instruction)	
            local A = instruction.A
            local stack = stack
        
            stack[A] = stack[A] - stack[A+2]
            IP = IP + instruction.sBx
        end,]],
        [34] = [[[]]..tostring(settings.Opcodes.ROpcodes[33])..[[] = function(instruction)	
            local A = instruction.A
            local B = instruction.B
            local C = instruction.C
            local stack = stack
        
            local offset = A+2
            local result = {stack[A](stack[A+1], stack[A+2])}
            for i = 1, C do
                stack[offset+i] = result[i]
            end
        
            if stack[A+3] ~= nil then
                stack[A+2] = stack[A+3]
            else
                IP = IP + 1
            end
        end,]],
        [35] = [[[]]..tostring(settings.Opcodes.ROpcodes[34])..[[] = function(instruction)	
            local A = instruction.A
            local B = instruction.B
            local C = instruction.C
            local stack = stack
        
            if C == 0 then
                error("NYI: extended SETLIST")
            else
                local offset = (C - 1) * 50
                local t = stack[A]
        
                if B == 0 then
                    B = top
                end
                for i = 1, B do
                    t[offset+i] = stack[A+i]
                end
            end
        end,]],
        [36] = [[[]]..tostring(settings.Opcodes.ROpcodes[35])..[[] = function(instruction)	
            io.stderr:write("NYI: CLOSE")
            io.stderr:flush()
        end,]],
        [37] = [[[]]..tostring(settings.Opcodes.ROpcodes[36])..[[] = function(instruction)	
            local proto = prototypes[instruction.Bx]
            local instructions = instructions
            local stack = stack
        
            local indices = {}
            local new_upvals = setmetatable({},
                {
                    __index = function(t, k)
                        local upval = indices[k]
                        return upval.segment[upval.offset]
                    end,
                    __newindex = function(t, k, v)
                        local upval = indices[k]
                        upval.segment[upval.offset] = v
                    end
                }
            )
            for i = 1, proto[4] do
                local movement = instructions[IP]
                if movement.opcode == 0 then 
                    indices[i-1] = {segment = stack, offset = movement.B}
                elseif instructions[IP].opcode == 4 then 
                    indices[i-1] = {segment = upvalues, offset = movement.B}
                end
                IP = IP + 1
            end
        
            local _, func = create_wrapper(proto, new_upvals)
            stack[instruction.A] = func
        end,]],
        [38] = [[[]]..tostring(settings.Opcodes.ROpcodes[37])..[[] = function(instruction)	
            local A = instruction.A
            local B = instruction.B
            local stack, vararg = stack, vararg
        
            for i = A, A + (B > 0 and B - 1 or vararg_size) do
                stack[i] = vararg[i - A]
            end
        end,]]
    }

    return opcodes;
end;


return run;