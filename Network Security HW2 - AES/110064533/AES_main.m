%
% AES Algorithm
%   Author. NTHU COM 110064533, Shao-Heng Chen
%   Ref. NIST FIPS PUB 197
%   Note. bind with matrix_mult_AES.m, mult_AES.m, key_expansion.m
%
clc;
clear;
%
% input plaintext, key type and key string
%
% '...' is char array (type), just store sequence of chars
% "..." is str array (container), with funcs for working with text as data
%
plaintext = '6e33547730346b5f3565437572315479';
key_type = 128; % there're 3 types of AES-128, 192, and 256
key_str = '';   % key string, length has to be exactly the same as the spec
Nk = 0;         % number of columns can the key split into
Kr = 0;         % number of rounds
%
% all types of AES are supported, AES-128, AES-192, AES-256
if key_type == 128
    key_str = '78686f74ab206d65203e756e6720d67c';
    Nk = 4;    
    Nr = 10;   
elseif key_type == 192
    key_str = '8e73b0f7da0e6452c810f32b8090791562f8ead2522c6b7b';
    Nk = 6;
    Nr = 12;
elseif key_type == 256
    key_str = '603deb1015ca71be2b73aef0857d77811f352c073b6108d72d9810a30914dff4';
    Nk = 8;
    Nr = 14;
end
%
% show the S_Box
% showed that I know how to generate S_Box, but in run-time execution I 
% still use table look-ups for simplicity, cause my S_Box function constain
% both forward and inverse S_Box substitution already
%
S_Box = show_Sbox();
display(S_Box);
fprintf(' --------------------------------------------------------- \n');
%
% block size == 4 words == 4*32 bits == 16 bytes == 128/8
%
IN = zeros(1, 128/8); % 1x16 zero vector, [0 0 0 ... 0 0]
for i = 1 : 128/8
    % convert the plaintext from hexdec to dec, then store in IN vector
    % i=1-->{1, 2} i=2-->{3,4} ... i=16-->{31,32}
    IN(i) = hex2dec(plaintext((i - 1) * 2 + 1 : i*2));
end
IN = uint8(IN);
IN = reshape(IN, 4, 4); % reshape IN into 4x4 matrix, (.., col, row)
%
key_len = length(key_str); % access the key string length
key = zeros(1, key_len/2); % actual key
for i = 1 : key_len/2
    % convert key_str from hexdec to dec, then store in key
    key(i) = hex2dec(key_str((i - 1) * 2 + 1 : i*2));
end
key = uint8(key);
%
% key expansion
%
% W for encryption, IW for decryption
[W, IW] = key_expansion(key, Nr, Nk);
%
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%
% Encryption process
%
% 0-th round (iteration strat with 1, represent 0)
%
S = uint8(zeros(4, 4, Nr+1));
S(:, :, 1) = bitxor(IN, W(:, :, 1));
%
% 1-st ~ Nr-th round, just follow the AES encryption steps
%
for iround = 1 : Nr
    %
    % SubByte Transformation
    %
    for ir = 1 : 4
        for ic = 1 : 4
            % next S = Sbox(pre S)
            S(ir, ic, iround + 1) = Sbox(S(ir, ic, iround), 'F');
        end
    end
    %
    % ShiftRow Transformation, shift left
    %
    for ir = 2 : 4
        % shifting left mechanism:
        %     2nd row--> shift 1 bit, 3rd row--> 2 bit, 4th row--> 3 bit
        % temp will store: 
        %     1st element of 2nd row, 1 2th of 3rd, 1 2 3th of 4th
        temp = S(ir, 1 : ir - 1, iround + 1);
        S(ir, 1 : 5 - ir, iround + 1) = S(ir, ir:4, iround + 1); % shift left
        S(ir, 6 - ir : 4, iround + 1) = temp;
    end
    %
    % MixColumns Transformation
    %
    % establish 4x4 matrices for MixColumns and InvMixColumns transformations
    %
    F = [2 3 1 1;
         1 2 3 1;
         1 1 2 3;
         3 1 1 2];
    F = uint8(F);
    % last round remain the same
    if iround ~= Nr
        S(:, :, iround + 1) = matrix_mult_AES(F, S(:, :, iround + 1));
    end
    %
    % AddRoundKey Transformation
    %
    % W = key
    S(:, :, iround + 1) = bitxor(S(:, :, iround + 1), W(:, :, iround + 1));
    %
    % construct the ciphertext
    %
    tempcipher = S(:, :, iround);            % cipher in binary, numerical form
    tempcipher = reshape(tempcipher, 1, 16); % reshpae into 1x16 vector [...]
    temptext = char(); % actual ciphertext in char array or string type
    for i = 1 : 16
        temptext = strcat(temptext, dec2hex(tempcipher(i), 2));
    end
    temptext = lower(temptext);
    fprintf(' Round %i ciphertext is: %s \n', iround - 1, temptext);
end
tempcipher = S(:, :, Nr + 1);            % cipher in binary, numerical form
tempcipher = reshape(tempcipher, 1, 16); % reshpae into 1x16 vector [...]
temptext = char(); % actual ciphertext in char array or string type
for i = 1 : 16
    temptext = strcat(temptext, dec2hex(tempcipher(i), 2));
end
temptext = lower(temptext);
fprintf(' Round %i ciphertext is: %s \n', Nr, temptext);
fprintf(' --------------------------------------------------------- \n');
%
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%
% construct the ciphertext
%
cipher = S(:, :, Nr + 1);        % cipher in binary, numerical form
cipher = reshape(cipher, 1, 16); % reshpae into 1x16 vector [...]
ciphertext = char(); % actual ciphertext in char array or string type
for i = 1 : 16
    ciphertext = strcat(ciphertext, dec2hex(cipher(i), 2));
end
ciphertext = lower(ciphertext); % 
%
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% 
% Decryption process
%
IIN = zeros(1, 128/8); % 1x16 zero vector, [0 0 ... 0]
for i = 1 : 128/8
    % convert the ciphertext form hexdec to dec, then store in IIN vector
    % i=1-->{1, 2} i=2-->{3,4} ... i=16-->{31,32}
    IIN(i) = hex2dec(ciphertext((i - 1)*2 + 1 : i*2));
end
IIN = uint8(IIN);
IIN = reshape(IIN, 4, 4); % reshape IN into 4x4 matrix, (.., col, row)
%
% because we already had the key, and already performed key_expansion, at previous 
% encryption steps, we can just directly continued with the decryption rounds.
%
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%
% 0-th round, inverse initialization (iteration start with 1, represent 0)
%
% possible Error using bitxor: 
%     Inputs must be signed or unsigned integers of the same class or scalar doubles.
IS = uint8(zeros(4, 4, Nr + 1));
IS(:, :, 1) = bitxor(IIN, IW(:, :, 1));
%
% 1st ~ Nr-th round, AES decryption steps == encryption steps in reverse order
%
for iround = 1 : Nr
    %
    % invSubByte Transformation
    %
    for ir = 1 : 4
        for ic = 1 : 4
            % next IS = Sbox(pre IS)
            IS(ir, ic, iround + 1) = Sbox(IS(ir, ic, iround), 'I');
        end
    end
    %
    % invShiftRow Transformation, shift right
    %
    for ir = 2 : 4 
        temp = IS(ir, 6 - ir : 4, iround + 1);
        IS(ir, ir : 4, iround + 1) = IS(ir, 1 : 5-ir, iround + 1); % shift right
        IS(ir, 1 : ir - 1, iround + 1) = temp;
    end
    %
    % invMixColumns Transformation
    %
    IF = [14 11 13 9;
          9 14 11 13;
          13  9 14 11;
          11 13  9 14];
    IF = uint8(IF);
    if iround ~= Nr % ~= bitwise Not operation, last round remain the same
        IS(:, :, iround + 1) = matrix_mult_AES(IF, IS(:, :, iround + 1));
    end
    %
    % AddRoundKey Transformation(forward and inverse is the same), there is no 
    % inv-AddRoundKey because addition and subtraction are the same in binary operations
    %
    % IW = inverse key
    IS(:, :, iround + 1) = bitxor(IS(:, :, iround + 1), IW(:, :, iround + 1));
    %
    % reconstruct the recovered plaintext
    %
    tempplain = IS(:, :, iround);          % recovered_plain in binary, numerical form
    tempplain = reshape(tempplain, 1, 16); % reshpae into 1x16 vector [...]
    tempplaintext = char(); % actual recovered plaintext in char array or string type
    for i = 1 : 16
          tempplaintext = strcat(tempplaintext, dec2hex(tempplain(i), 2));
    end
    tempplaintext = lower(tempplaintext);
    fprintf(' Round %i recovertext is: %s \n', iround - 1, tempplaintext);
end
tempplain = IS(:, :, Nr + 1);          % recovered_plain in binary, numerical form
tempplain = reshape(tempplain, 1, 16); % reshpae into 1x16 vector [...]
tempplaintext = char(); % actual recovered plaintext in char array or string type
for i = 1 : 16
      tempplaintext = strcat(tempplaintext, dec2hex(tempplain(i), 2));
end
tempplaintext = lower(tempplaintext);
fprintf(' Round %i recovertext is: %s \n', Nr, tempplaintext);
fprintf(' --------------------------------------------------------- \n');
%
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
%
% reconstruct the recovered plaintext
%
R_plain = IS(:, :, Nr+1); % recovered_plain in binary, numerical form
R_plain = reshape(R_plain, 1, 16); % reshpae into 1x16 vector [...]
R_plaintext = char(); % actual recovered plaintext in char array or string type
for i = 1 : 16
      R_plaintext = strcat(R_plaintext, dec2hex(R_plain(i), 2));
end
R_plaintext = lower(R_plaintext);
%
% print out the resulting data
%
fprintf(' Original plaintext is:   %s\n', plaintext);
fprintf(' Encrypted ciphertext is: %s\n', ciphertext);
fprintf(' Recovered plaintext is:  %s\n', R_plaintext);
fprintf(' AES-%i secret key is:   %s\n',  key_type, key_str);
%
% S_Box =
%    99  124  119  123  242  107  111  197   48    1  103   43  254  215  171  118
%   202  130  201  125  250   89   71  240  173  212  162  175  156  164  114  192
%   183  253  147   38   54   63  247  204   52  165  229  241  113  216   49   21
%     4  199   35  195   24  150    5  154    7   18  128  226  235   39  178  117
%     9  131   44   26   27  110   90  160   82   59  214  179   41  227   47  132
%    83  209    0  237   32  252  177   91  106  203  190   57   74   76   88  207
%   208  239  170  251   67   77   51  133   69  249    2  127   80   60  159  168
%    81  163   64  143  146  157   56  245  188  182  218   33   16  255  243  210
%   205   12   19  236   95  151   68   23  196  167  126   61  100   93   25  115
%    96  129   79  220   34   42  144  136   70  238  184   20  222   94   11  219
%   224   50   58   10   73    6   36   92  194  211  172   98  145  149  228  121
%   231  200   55  109  141  213   78  169  108   86  244  234  101  122  174    8
%   186  120   37   46   28  166  180  198  232  221  116   31   75  189  139  138
%   112   62  181  102   72    3  246   14   97   53   87  185  134  193   29  158
%   225  248  152   17  105  217  142  148  155   30  135  233  206   85   40  223
%   140  161  137   13  191  230   66  104   65  153   45   15  176   84  187   22
%  --------------------------------------------------------- 
%  Round 0 ciphertext is: 165b3b039b14063a155b361b15118205 
%  Round 1 ciphertext is: 3b5275116e969474087bf86a1b95e57e 
%  Round 2 ciphertext is: eabfc57354c7a3ab1d22d8d44b031246 
%  Round 3 ciphertext is: bfa928d2217adc9a9f010c478cfdaa7f 
%  Round 4 ciphertext is: b1ed3bb20d760929297e1940df09abbc 
%  Round 5 ciphertext is: 62b7fd9b8f9fa7f780f2bc111a1211b6 
%  Round 6 ciphertext is: 53c5434dd0f4ed56481a13b61e6beae9 
%  Round 7 ciphertext is: f72e1b8ad6665cd094c173e56b80ca08 
%  Round 8 ciphertext is: cfb83e712fd0715c97ff0d461bc8fb00 
%  Round 9 ciphertext is: 70b637cebd62abfc91ebbe686c2e5ee7 
%  Round 10 ciphertext is: 68464bfd42ecf565f81b487b4d999ef8 
%  --------------------------------------------------------- 
%  Round 0 recovertext is: 51aaae947ae9588b81319ab0504e6245 
%  Round 1 recovertext is: 8a70d76315160fa388e8b24aaf6ca35a 
%  Round 2 recovertext is: 68338f30f678747e22cdaf707f314ad9 
%  Round 3 recovertext is: edbf7d1e70a287e3527f1ab172a6554e 
%  Round 4 recovertext is: aadb654e73898214cdc95468a2a95c82 
%  Round 5 recovertext is: c838d465d7f36237a501e2a59e550109 
%  Round 6 recovertext is: 08dafed2fd7cacb5db5434b864d386a0 
%  Round 7 recovertext is: 87c6615a2093c98fa47ba662b3080a48 
%  Round 8 recovertext is: e29041f39f21d982302a9d92af002202 
%  Round 9 recovertext is: 47fa056b1439137b5982e28059396faf 
%  Round 10 recovertext is: 6e33547730346b5f3565437572315479 
%  --------------------------------------------------------- 
%  Original plaintext is:   6e33547730346b5f3565437572315479
%  Encrypted ciphertext is: 68464bfd42ecf565f81b487b4d999ef8
%  Recovered plaintext is:  6e33547730346b5f3565437572315479
%  AES-128 secret key is:   78686f74ab206d65203e756e6720d67c
%
