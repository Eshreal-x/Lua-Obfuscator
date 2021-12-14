local run = function()
        local Opco = "local Stk	= Stack;\nStk[Inst[1]] = Stk[Inst[2]][Inst[5] or Stk[Inst[3]]];"
    
        return Opco;
    end;
    
    return run;