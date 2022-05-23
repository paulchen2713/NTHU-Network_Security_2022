% 
% Additive inverse
%
function out=additive_inverse_n(ai)
global ifx n_dec;
cc=2^32;
a=n_dec;
b=ai;
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
out=c;
return
