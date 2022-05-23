%
% Module n for ECDSA (B163)
%
function out=module_n(ci)
global ifx n_dec;
ipx=ifx;
zero=zeros(ipx,1);
two16=2^16;
two32=2^32;
CC=ci;
CB=CC(ipx:2*ipx-1);
for i=1:3
    CB=bitshift_right_B163(CB);
end
%
while any(CB-zero)==1
    a=CB;
    b=n_dec;
    ap=zeros(2*ipx,1);
    bp=zeros(2*ipx,1);
    cp=zeros(4*ipx,1);
    c=zeros(2*ipx,1);
    for i=ipx:-1:1
        ap(2*i)=floor(a(i)/two16);
        ap(2*i-1)=mod(a(i),two16);
        bp(2*i)=floor(b(i)/two16);
        bp(2*i-1)=mod(b(i),two16);
    end
    for i=0:2*ipx-1
        U=0;
        for j=0:2*ipx-1
            UV=cp(i+j+1)+ap(i+1)*bp(j+1)+U;
            U=floor(UV/two16);
            V=mod(UV,two16);
            cp(i+j+1)=V;
        end
        cp(i+2*ipx+1)=U;
    end
    for i=1:2*ipx
        c(i)=two16*cp(2*i)+cp(2*i-1);
    end
    CN=c;
    %
    a=CC;
    b=CN;
    c=zeros(2*ipx,1);
    borrow=0;
    for i=1:2*ipx
        if a(i) >= b(i)+borrow
            c(i)=mod(a(i)-b(i)-borrow,two32);
            borrow=0;
        else
            c(i)=mod(two32+a(i)-b(i)-borrow,two32);
            borrow=1;
        end
    end
    CC=c;
    %
    CB=CC(ipx:2*ipx-1);
    for i=1:3
        CB=bitshift_right_B163(CB);
    end
end
%
CCC=CC(1:ipx);
borrow=0;
while borrow==0
    a=CCC;
    b=n_dec;
    borrow=0;
    for i=1:ipx
        if a(i) >= b(i)+borrow
            borrow=0;
        else
            borrow=1;
        end
    end
    if borrow==0
        c=zeros(ipx,1);
        borrow=0;
        for i=1:ipx
            if a(i) >= b(i)+borrow
                c(i)=mod(a(i)-b(i)-borrow,two32);
                borrow=0;
            else
                c(i)=mod(two32+a(i)-b(i)-borrow,two32);
                borrow=1;
            end
        end
        CCC=c;
    end
end
%
out=CCC;
return