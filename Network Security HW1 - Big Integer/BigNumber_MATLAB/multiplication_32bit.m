%
% Mulplication of two 32-bit numbers
%
function out=multiplication_32bit(ai,bi)
cc=2^16;
a=ai;
b=bi;
ap=zeros(2,1);
bp=zeros(2,1);
cp=zeros(4,1);
c=zeros(2,1);
ap(2)=floor(a/cc);
ap(1)=mod(a,cc);
bp(2)=floor(b/cc);
bp(1)=mod(b,cc);
for i=0:1
    U=0;
    for j=0:1
        UV=cp(i+j+1)+ap(i+1)*bp(j+1)+U;
        U=floor(UV/cc);
        V=mod(UV,cc);
        cp(i+j+1)=V;
    end
    cp(i+3)=U;
end
for i=1:2
    c(i)=cc*cp(2*i)+cp(2*i-1);
end
out=c;
return