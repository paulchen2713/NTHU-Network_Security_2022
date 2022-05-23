%
% Comparison of a and b
% a>=b: output=1
% a<b: output=0
%
function out=large_or_equal(ai,bi)
global ifx;
a=ai;
b=bi;
borrow=0;
for i=1:ifx
    if a(i) >= b(i)+borrow
        borrow=0;
    else
        borrow=1;
    end
end
if borrow == 1
    out=0;
else
    out=1;
end
return