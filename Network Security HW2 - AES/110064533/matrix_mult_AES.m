%
% matrix multiplication function for AES
%   Note. being used in key_expansion.m and AES.m
%
function out = matrix_mult_AES(A, B)
    A = uint8(A); 
    B = uint8(B);
    C = uint8(zeros(4, 4));
    for ir = 1 : 4
        for ic = 1 : 4
            temp_sum = uint8(0);
            for im = 1 : 4
                temp = mult_AES(A(ir, im), B(im, ic));
                temp_sum = bitxor(temp_sum, temp);
            end
            C(ir, ic) = temp_sum;
        end
    end
    out = C;
return
