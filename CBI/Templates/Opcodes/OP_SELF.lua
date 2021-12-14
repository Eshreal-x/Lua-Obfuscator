local run = function()
        local Opco = "local Stk	= Stack;\nlocal A = Inst[1];\nlocal B = Stk[Inst[2]];\nlocal C = Inst[5] or Stk[Inst[3]];\nStk[A + 1] = B;\nStk[A] = B[C];"
    
        return Opco;
    end;
    
    return run;