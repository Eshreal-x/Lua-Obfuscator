local run = function()
        local Opco = "local A = Inst[1];\nlocal Cls = {};\nfor Idx = 1, #Lupvals do\nlocal List = Lupvals[Idx];\nfor Idz = 0, #List do\nlocal Upv = List[Idz];\nlocal Stk = Upv[1];\nlocal Pos = Upv[2];\nif (Stk == Stack) and (Pos >= A) then\nCls[Pos] = Stk[Pos];\nUpv[1] = Cls;\nend;\nend;\nend;"
    
        return Opco;
    end;
    
    return run;