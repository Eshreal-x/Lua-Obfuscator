local run = function(settings)
        local Opco = "local NewProto = Proto[Inst[2]];\nlocal Stk = Stack;\nlocal Indexes;\nlocal NewUvals;\nif (NewProto[4] ~= 0) then\nIndexes = {};\nNewUvals = setmetatable({}, {\n__index = function(_, Key)\nlocal Val = Indexes[Key];\nreturn Val[1][Val[2]];\nend,\n__newindex = function(_, Key, Value)\nlocal Val = Indexes[Key];\nVal[1][Val[2]]	= Value;\nend;\n}\n);\nfor Idx = 1, NewProto[4] do\nlocal Mvm	= Instr[InstrPoint];\nif (Mvm[6] == "..settings.Opcodes.ROpcodes[0]..") then\nIndexes[Idx - 1] = {Stk, Mvm[2]};\nelseif (Mvm[6] == "..settings.Opcodes.ROpcodes[4]..") then\nIndexes[Idx - 1] = {Upvalues, Mvm[2]};\nend;\nInstrPoint = InstrPoint + 1;\nend;\nLupvals[#Lupvals + 1] = Indexes;\nend;\nStk[Inst[1]] = Wrap(NewProto, Env, NewUvals);"
    
        return Opco;
    end;
    
    return run;