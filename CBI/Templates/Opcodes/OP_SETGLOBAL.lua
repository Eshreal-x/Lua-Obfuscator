local run = function()
        local Opco = "Env[Const[Inst[2]]] = Stack[Inst[1]];"
    
        return Opco;
    end;
    
    return run;