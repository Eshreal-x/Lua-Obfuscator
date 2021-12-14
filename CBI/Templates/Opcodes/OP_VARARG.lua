local run = function()
        local Opco = "local A = Inst[1];\nlocal B	= Inst[2];\nlocal Stk, Vars	= Stack, Vararg;\nTop = A - 1;\nfor Idx = A, A + (B > 0 and B - 1 or Varargsz) do\nStk[Idx]	= Vars[Idx - A];\nend;"
    
        return Opco;
    end;
    
    return run;