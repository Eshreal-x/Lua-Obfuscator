local run = function()
        local Opco = "local A	= Inst[1];\nlocal B	= Inst[2];\nlocal C	= Inst[3];\nlocal Stk	= Stack;\nlocal Args, Results;\nlocal Limit, Edx;\nArgs	= {};\nif (B ~= 1) then\nif (B ~= 0) then\nLimit = A + B - 1;\nelse\nLimit = Top;\nend;\nEdx	= 0;\nfor Idx = A + 1, Limit do\nEdx = Edx + 1;\nArgs[Edx] = Stk[Idx];\nend;\nLimit, Results = _Returns(Stk[A](unpack(Args, 1, Limit - A)));\nelse\nLimit, Results = _Returns(Stk[A]());\nend;\nTop = A - 1;\nif (C ~= 1) then\nif (C ~= 0) then\nLimit = A + C - 2;\nelse\nLimit = Limit + A - 1;\nend;\nEdx	= 0;\nfor Idx = A, Limit do\nEdx = Edx + 1;\nStk[Idx] = Results[Edx];\nend;\nend;"
    
        return Opco;
    end;
    
return run;