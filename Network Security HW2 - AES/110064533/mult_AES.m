%
% 8-bit GF256 multiplication for AES
%   Note. being used in matrix_mult_AES.m 
%
function out = mult_AES(a, b)
    % a, and b has to be exactly uint8
    b = uint8(b);
    base = uint8(a);
    sum = uint8(0);
    for i = 1 : 8
        % fetch the bits from the right most position(lsb)
        if bitget(b, i) == 1 
            sum = bitxor(sum, base);
        end
        if bitget(base, 8) == 0
            base = bitshift(base, 1);
        else
            % 0x1b == 16 + 11 == 27
            base = bitxor(bitshift(base, 1), uint8(27));
        end
    end
    out = sum;
return
