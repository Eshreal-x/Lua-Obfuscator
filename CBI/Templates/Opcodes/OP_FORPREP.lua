local run = function()
        local Opco = "local A = Inst[1];\nlocal Stk = Stack;\nStk[A] = assert(tonumber(Stk[A]), '`for` initial value must be a number');\nStk[A + 1] = assert(tonumber(Stk[A + 1]), '`for` limit must be a number');\nStk[A + 2] = assert(tonumber(Stk[A + 2]), '`for` step must be a number');\nStk[A]	= Stk[A] - Stk[A + 2];\nInstrPoint	= InstrPoint + Inst[2];"
    
        return Opco;
    end;
    
    return run;