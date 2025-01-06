function closed = isclose(a, b, rtol, atol)
% alpha와 beta의 변화가 있는지 없는지 확인하는 코드
if abs(a - b) <= (atol + rtol * abs(b))
    closed = 1;
else
    closed = 0;
end
end