%
% Mulplication of three 32-bit numbers
%
function out=multiplication_3_32bit(ai,bi,ci)
global ipx;
a=multiplication_32bit(ai,ci);
b=bi;
c1=zeros(ipx,1);
c2=zeros(ipx,1);
c1(1:2)=multiplication_32bit(a(1),b);
c2(2:3)=multiplication_32bit(a(2),b);
c=addition_n(c1,c2);
out=c(1:3);
return