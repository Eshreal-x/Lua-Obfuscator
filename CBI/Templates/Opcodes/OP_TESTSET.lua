local run = function()
        local Opco = "local B = Stack[Inst[2]];\nif Inst[3] then\n if B then\nInstrPoint = InstrPoint + 1;\nelse\nStack[Inst[1]] = B;\nend;\nelseif B then\nStack[Inst[1]] = B;\nelse\nInstrPoint = InstrPoint + 1;\nend;"
    
        return Opco;
    end;
    
    return run;