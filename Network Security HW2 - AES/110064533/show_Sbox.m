%
% generate substitution table S_Box
%   Ref. -NIST FIPS PUB 197, 5.1.1 SubBytes() Transformation, p.15~16, 
%        -S_Box and InvS_Box structure derivation and code implementation 
%         (https://blog.csdn.net/u011516178/article/details/81221646)
%   Note. bind with mult_AES.m
%
function S_Box = show_Sbox()
    % 
    S_ini = uint8(zeros(16, 16)); % store the initial values of the S_Box
    S_inv = uint8(zeros(16, 16)); % store the inverses between [0, 255]
    S_Box = uint8(zeros(16, 16)); % store the result of the S_Box
    bi = zeros(8); % bi is the i th bit of the byte, from b0, b1, ..., b7
    %
    % initialize the S_Box starting values
    % e.g. 1st row: 0x00, 0x01, 0x02, ..., 0x0f
    %      2nd row: 0x10, 0x11, 0x12, ..., 0x1f
    %
    % the counter start with 0, and add up the value row by row
    count = uint8(0);
    for row = 1 : 16
        for col = 1 : 16
            S_ini(row, col) = count;
            count = count + 1;
        end
    end
    %
    % find the multiplicative inverse
    %
    for row = 1 : 16
        for col = 1 : 16
            %
            % brute force search
            %
            for inv = 1 : 256
                %
                % if two elements mult together equals to 1, means these
                % two are multiplicative inverse. and 0 is mapped to itself
                %
                if mult_AES(inv, S_ini(row, col)) == 1
                    S_inv(row, col) = inv;
                end
            end
        end
    end
    %
    % Affine transformation
    %
    % b(i)' = b(i) xor b(i+4) xor b(i+5) xor b(i+6) xor b(i+7) xor c(i),
    % the index i has to mod 8
    % 
    for row = 1:16
        for col = 1:16
            %
            % apply the (5.1) affine transformation, for 0 <= i < 8
            %
            temp = uint8(0);
            temp = bitxor(temp, S_inv(row, col));
            affine = uint8(0);
            for i = 1 : 8
                bi(i) = bitget(temp, i);
            end
            %
            % b(i)' = b(i) xor b(i+4) xor b(i+5) xor b(i+6) xor b(i+7)
            %
            for i = 1 : 8
                % bi(i), i = 1~8 indicates b0~b7
                bi(i) = bitxor(bi(i), bitget(temp, mod((i+4)-1, 8) + 1));
                bi(i) = bitxor(bi(i), bitget(temp, mod((i+5)-1, 8) + 1));
                bi(i) = bitxor(bi(i), bitget(temp, mod((i+6)-1, 8) + 1));
                bi(i) = bitxor(bi(i), bitget(temp, mod((i+7)-1, 8) + 1));
            end
            for i = 1 : 8
                if bi(i) ~= 0
                   affine = 2^(i-1) + affine;
                end
            end
            %
            % c(i) is the i th bit of a byte c with value 0x63, or 99.
            ci = uint8(99);
            S_Box(row, col) = bitxor(affine, ci);
        end
    end
end
