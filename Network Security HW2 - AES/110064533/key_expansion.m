%
% Key Expansion function, for Encryption(W) and Decryption(IW)
%   Note. bind with matrix_mult_AES.m and mult_AES.m
%
function [W, IW] = key_expansion(key, Nr, Nk)
    %
    % establish 4X4 matrice for InvMixColumns transformation
    %
    IF = [14 11 13 9; 
          9 14 11 13; 
          13 9 14 11; 
          11 13 9 14];
    IF = uint8(IF);
    %
    key = reshape(key, 4, Nk);
    %
    % key expansion
    %
    % round constant [1 0 0 0] column matrix
    Rcon = uint8([1; 0; 0; 0]);
    %
    for ikey = Nk : 4*(Nr + 1) - 1
        temp = key(:, ikey);
        %
        % W mod Nk == 0 is the first exception
        %
        if mod(ikey, Nk) == 0
            temp_1 = temp(1);
            temp(1:3) = temp(2:4); % shift left for 1 bit
            temp(4) = temp_1;
            for is = 1 : 4
                temp(is) = Sbox(temp(is), 'F');            
            end
            % bitxor with Rcon after shifting
            temp = bitxor(temp, Rcon);
            % checking for overflow
            if bitget(Rcon(1), 8) == 0
                Rcon(1) = bitshift(Rcon(1), 1);
            else
                Rcon(1) = bitxor(bitshift(Rcon(1), 1), uint8(27));
            end
        %
        % Nk == 8 is the second excpetion, W4 12 20 28 are the special cases
        %
        elseif Nk == 8 && mod(ikey, Nk) == 4
            for is = 1 : 4
                temp(is) = Sbox(temp(is), 'F');
            end
        end
        %
        % normal cases in W
        %
        key(:, ikey + 1) = bitxor(temp, key(:, ikey - Nk + 1));
    end
    %
    % key (W matrix)
    %
    W = uint8(zeros(4, 4, Nr + 1));
    for ir = 0 : Nr
        % store the computation result into W matrix
        W(:, :, ir + 1) = key(:, 4*ir + 1 : 4*(ir + 1));
    end
    %
    % inverse key (inverse W matrix)
    %
    IW = uint8(zeros(4, 4, Nr + 1));
    IW(:, :, 1) = W(:, :, Nr + 1);
    IW(:, :, Nr + 1) = W(:, :, 1);
    for ikey = 1 : Nr-1
        IW(:, :, ikey + 1) = matrix_mult_AES(IF, W(:, :, Nr + 1 - ikey));
    end
return
