local run = function()
        local Opco = "if Inst[3] then\nif Stack[Inst[1]] then\nInstrPoint = InstrPoint + 1;\nend\nelseif Stack[Inst[1]] then\nelse\nInstrPoint = InstrPoint + 1;\nend;"
    
        return Opco;
    end;
    
    return run;