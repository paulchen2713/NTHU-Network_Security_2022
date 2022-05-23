% 
% Addition of two numbers
%
function out=special_addition_n(ai,bi)
global ifx;
cc=2^32;
a=ai;
b=bi;
c=zeros(ifx,1);
carry=0;
for i=1:ifx
    c(i)=mod(a(i)+b(i)+carry,cc);
    carry=floor((a(i)+b(i)+carry)/cc);
end
out=c;
return
