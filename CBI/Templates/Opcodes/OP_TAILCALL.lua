local run = function()
        local Opco = "local A = Inst[1];\nlocal B	= Inst[2];\nlocal Stk	= Stack;\nlocal Args, Results;\nlocal Limit;\nlocal Rets = 0;\nArgs = {};\nif (B ~= 1) then\nif (B ~= 0) then\nLimit = A + B - 1;\nelse\nLimit = Top;\nend;\nfor Idx = A + 1, Limit do\nArgs[#Args + 1] = Stk[Idx];\nend;\nResults = {Stk[A](unpack(Args, 1, Limit - A))};\nelse\nResults = {Stk[A]()};\nend;\nfor Index in pairs(Results) do\nif (Index > Rets) then\nRets = Index;\nend;\nend;\nreturn Results, Rets;"
    
        return Opco;
    end;
    
    return run;