local run = function()
        local Opco = "local A = Inst[1];\nlocal C	= Inst[3];\nlocal Stk = Stack;\nlocal Offset = A + 2;\nlocal Result = {Stk[A](Stk[A + 1], Stk[A + 2])};\nfor Idx = 1, C do\nStack[Offset + Idx] = Result[Idx];\nend;\nif (Stk[A + 3] ~= nil) then\nStk[A + 2]	= Stk[A + 3];\nelse\nInstrPoint	= InstrPoint + 1;\nend;"
    
        return Opco;
    end;
    
    return run;