local run = function()
        local Opco = "Stack[Inst[1]]	= (Inst[2] ~= 0);\nif (Inst[3] ~= 0) then\nInstrPoint	= InstrPoint + 1;\nend;"
    
        return Opco;
    end;
    
    return run;