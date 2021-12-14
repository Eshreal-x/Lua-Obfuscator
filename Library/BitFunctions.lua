local bit = {};

function bit.bxor(e, l)
    local n, o = 1, 0;
    while e > 0 and l > 0 do
        local t, c = e % 2, l % 2;
        if t ~= c then
            o = o + n;
        end;

        e, l, n = (e - t) / 2, (l - c) / 2, n * 2;
    end;
    if e < l then
        e = l;
    end;
    while e > 0 do
        local l = e % 2;
        if l > 0 then
            o = o + n;
        end;

        e, n = (e - l) / 2, n * 2;
    end;
    return o;
end;

function bit.band(a, b)
    local result = 0;
    local bitval = 1;
    while a > 0 and b > 0 do
      if a % 2 == 1 and b % 2 == 1 then
          result = result + bitval;
      end;
      bitval = bitval * 2;
      a = math.floor(a / 2);
      b = math.floor(b / 2);
    end;
    return result;
end;

function bit.bor(a, b)
    local result = 0;
    local bitval = 1;
    while a > 0 or b > 0 do
      if a % 2 == 1 or b % 2 == 1 then
          result = result + bitval;
      end;
      bitval = bitval * 2;
      a = math.floor(a / 2);
      b = math.floor(b / 2);
    end;
    return result;
end;

function bit.lshift(a, b)
    return a * 2 ^ b;
end;

function bit.rshift(a, b)
    return math.floor(a / 2 ^ b);
end;

return bit;