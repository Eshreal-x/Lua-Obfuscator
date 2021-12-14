local script, err = loadfile("Script.txt");
if err then print(err) end;
local bytecode = string.dump(script);
local a = string.gsub(bytecode, ".", function(c) return "\\" .. c:byte() end);


io.open("Dump.luac",'w+'):write(a);
return bytecode, a;