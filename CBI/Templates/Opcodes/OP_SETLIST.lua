local run = function()
        local Opco = "local A = Inst[1];\nlocal B	= Inst[2];\nlocal C	= Inst[3];\nlocal Stk = Stack;\nif (C == 0) then\nInstrPoint = InstrPoint + 1;\nC = Instr[InstrPoint].Value;\nend;\nlocal Offset = (C - 1) * 50;\nlocal T	= Stk[A];\nif (B == 0) then\nB = Top - A;\nend;\nfor Idx = 1, B do\nT[Offset + Idx] = Stk[A + Idx];\nend;"
    
        return Opco;
    end;
    
    return run;