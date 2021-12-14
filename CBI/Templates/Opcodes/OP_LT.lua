local run = function()
        local Opco = "local Stk = Stack;\nlocal B = Inst[4] or Stk[Inst[2]];\nlocal C = Inst[5] or Stk[Inst[3]];\nif (B < C) ~= Inst[1] then\nInstrPoint	= InstrPoint + 1;\nend;"
    
        return Opco;
    end;
    
    return run;