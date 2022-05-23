% 
% Addition of two numbers
%
function out=addition_n(ai,bi)
global n_dec N ifx;
cc=2^32;
a=ai;
b=bi;
c=zeros(ifx,1);
carry=0;
for i=1:ifx
    c(i)=mod(a(i)+b(i)+carry,cc);
    carry=floor((a(i)+b(i)+carry)/cc);
end
if carry==1
    c=addition_n(c,N);
elseif large_or_equal(c,n_dec)
    a=c;
    b=n_dec;
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
end
out=c;
return
