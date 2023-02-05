# AES
## COM 5335 Network Security Assignment #2 - AES

Network Security Assignment 2 AES, by NTHU COM 110064533 Paul   

1. This software demonstrates AES-128, AES-192, and AES-256 basic functionality, contain both Encryption and Decryption process. The implementation follow the NIST official documentation FIPS PUB 197.   

2. Run and tested on MATLAB 2015b   

3. Directly run the AES_main.m program can see the results below and run the show_Sbox.m can see the forward substitution table.   

4. main function: AES_main.m   
  sub functions: key_expansion.m, matrix_mult_AES.m, mult_AES.m, Sbox.m, show_Sbox.m   

Have fun~   

```
Round 0 ciphertext is:  165b3b039b14063a155b361b15118205   
Round 1 ciphertext is:  3b5275116e969474087bf86a1b95e57e   
Round 2 ciphertext is:  eabfc57354c7a3ab1d22d8d44b031246   
Round 3 ciphertext is:  bfa928d2217adc9a9f010c478cfdaa7f   
Round 4 ciphertext is:  b1ed3bb20d760929297e1940df09abbc   
Round 5 ciphertext is:  62b7fd9b8f9fa7f780f2bc111a1211b6   
Round 6 ciphertext is:  53c5434dd0f4ed56481a13b61e6beae9   
Round 7 ciphertext is:  f72e1b8ad6665cd094c173e56b80ca08   
Round 8 ciphertext is:  cfb83e712fd0715c97ff0d461bc8fb00   
Round 9 ciphertext is:  70b637cebd62abfc91ebbe686c2e5ee7   
Round 10 ciphertext is: 68464bfd42ecf565f81b487b4d999ef8   

Round 0 recovertext is:  51aaae947ae9588b81319ab0504e6245   
Round 1 recovertext is:  8a70d76315160fa388e8b24aaf6ca35a   
Round 2 recovertext is:  68338f30f678747e22cdaf707f314ad9   
Round 3 recovertext is:  edbf7d1e70a287e3527f1ab172a6554e   
Round 4 recovertext is:  aadb654e73898214cdc95468a2a95c82   
Round 5 recovertext is:  c838d465d7f36237a501e2a59e550109   
Round 6 recovertext is:  08dafed2fd7cacb5db5434b864d386a0   
Round 7 recovertext is:  87c6615a2093c98fa47ba662b3080a48   
Round 8 recovertext is:  e29041f39f21d982302a9d92af002202   
Round 9 recovertext is:  47fa056b1439137b5982e28059396faf   
Round 10 recovertext is: 6e33547730346b5f3565437572315479   
 
Original plaintext is:   6e33547730346b5f3565437572315479   
Encrypted ciphertext is: 68464bfd42ecf565f81b487b4d999ef8   
Recovered plaintext is:  6e33547730346b5f3565437572315479   
AES-128 secret key is:   78686f74ab206d65203e756e6720d67c   
```



