% 
% Subtraction of two numbers subject to ai >= bi
%
function out=subtraction_n(ai,bi)
global ifx;
cc=2^32;
a=ai;
b=bi;
c=zeros(ifx,1);
borrow=0;
for i=1:ifx
    if a(i) >= b(i)+borrow
        c(i)=mod(a(i)-b(i)-borrow,cc);
        borrow=0;
    else
        c(i)=mod(cc+a(i)-b(i)-borrow,cc);
        borrow=1;
    end
end
if borrow==1
    fprintf('Warnning for Subtraction!');
end
out=c;
return
