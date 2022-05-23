%
% Mulplication module n for ECDSA
%
function out=multiplication_n(ai,bi)
global ifx;
cc=2^16;
a=ai;
b=bi;
ap=zeros(2*ifx,1);
bp=zeros(2*ifx,1);
cp=zeros(4*ifx,1);
c=zeros(2*ifx,1);
for i=ifx:-1:1
    ap(2*i)=floor(a(i)/cc);
    ap(2*i-1)=mod(a(i),cc);
    bp(2*i)=floor(b(i)/cc);
    bp(2*i-1)=mod(b(i),cc);
end
for i=0:2*ifx-1
    U=0;
    for j=0:2*ifx-1
        UV=cp(i+j+1)+ap(i+1)*bp(j+1)+U;
        U=floor(UV/cc);
        V=mod(UV,cc);
        cp(i+j+1)=V;
    end
    cp(i+2*ifx+1)=U;
end
for i=1:2*ifx
    c(i)=cc*cp(2*i)+cp(2*i-1);
end
out=module_n(c);
return