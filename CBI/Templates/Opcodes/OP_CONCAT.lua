local run = function()
        local Opco = "local Stk	= Stack;\nlocal B = Inst[2];\nlocal K = Stk[B];\nfor Idx = B + 1, Inst[3] do\nK = K .. Stk[Idx];\nend;\nStack[Inst[1]] = K;\n"
    
        return Opco;
    end;
    
    return run;