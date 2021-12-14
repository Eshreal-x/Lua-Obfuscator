local run = function()
        local Opco = "local A = Inst[1];\nlocal Stk = Stack;\nlocal Step = Stk[A + 2];\nlocal Index	= Stk[A] + Step;\nStk[A]	= Index;\nif (Step > 0) then\nif Index <= Stk[A + 1] then\nInstrPoint	= InstrPoint + Inst[2];\nStk[A + 3] = Index;\nend;\nelse\nif Index >= Stk[A + 1] then\nInstrPoint	= InstrPoint + Inst[2];\nStk[A + 3] = Index;\nend;\nend;"
    
        return Opco;
    end;
    
    return run;