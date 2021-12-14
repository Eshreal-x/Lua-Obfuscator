local run = function()
        local Opco = "local A = Inst[1];\nlocal B	= Inst[2];\nlocal Stk = Stack;\nlocal Edx, Output;\nlocal Limit;\nif (B == 1) then\nreturn;\nelseif (B == 0) then\nLimit = Top;\nelse\nLimit = A + B - 2;\nend;\nOutput = {};\nEdx = 0;\nfor Idx = A, Limit do\nEdx	= Edx + 1;\nOutput[Edx] = Stk[Idx];\nend;\nreturn Output, Edx;"
    
        return Opco;
    end;
    
    return run;