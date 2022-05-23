%
% Multiplicative inverse
%
function out=multiplicative_inverse_n(ai)
global ifx n_dec;
one=zeros(ifx,1);
one(1)=1;
zero=zeros(ifx,1);
a=ai;
%
%
u=a;
v=n_dec;
x1=one;
x2=zero;
while any(u-one) && any(v-one)
    while mod(u(1),2)==0
        for i=1:ifx-1
            u(i)=bitshift(u(i),-1);
            u(i)=bitset(u(i),32,bitget(u(i+1),1));
        end
        u(ifx)=bitshift(u(ifx),-1);
        if mod(x1(1),2)==0
            for i=1:ifx-1
                x1(i)=bitshift(x1(i),-1);
                x1(i)=bitset(x1(i),32,bitget(x1(i+1),1));
            end
            x1(ifx)=bitshift(x1(ifx),-1);
        else
            x1=special_addition_n(x1,n_dec);
            for i=1:ifx-1
                x1(i)=bitshift(x1(i),-1);
                x1(i)=bitset(x1(i),32,bitget(x1(i+1),1));
            end
            x1(ifx)=bitshift(x1(ifx),-1);
        end
    end
    %
    while mod(v(1),2)==0
        for i=1:ifx-1
            v(i)=bitshift(v(i),-1);
            v(i)=bitset(v(i),32,bitget(v(i+1),1));
        end
        v(ifx)=bitshift(v(ifx),-1);
        if mod(x2(1),2)==0
            for i=1:ifx-1
                x2(i)=bitshift(x2(i),-1);
                x2(i)=bitset(x2(i),32,bitget(x2(i+1),1));
            end
            x2(ifx)=bitshift(x2(ifx),-1);
        else
            x2=special_addition_n(x2,n_dec);
            for i=1:ifx-1
                x2(i)=bitshift(x2(i),-1);
                x2(i)=bitset(x2(i),32,bitget(x2(i+1),1));
            end
            x2(ifx)=bitshift(x2(ifx),-1);
        end
    end
    if large_or_equal(u,v)==1
        u=addition_n(u,additive_inverse_n(v));
        x1=addition_n(x1,additive_inverse_n(x2));
    else
        v=addition_n(v,additive_inverse_n(u));
        x2=addition_n(x2,additive_inverse_n(x1));
    end
end
if any(u-one)==0
    out=x1;
else
    out=x2;
end
return