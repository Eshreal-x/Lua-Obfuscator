local run = function()
        local Opco = "local Stk	= Stack;\nfor Idx = Inst[1], Inst[2] do\nStk[Idx]	= nil;\nend;"
    
        return Opco;
    end;
    
    return run;