// AES Algorithm
#include <bits/stdc++.h>

// hex2dec subfunction
unsigned long long hex2dec(const std::string &input);

int main() {
    // establish 4x4 matrices for MixColumns and InvMixColumns transformations
    std::vector<std::vector<uint8_t>> F = {{2 3 1 1}, {1 2 3 1}, {1 1 2 3}, {3 1 1 2}};
    std::vector<std::vector<uint8_t>> IF = {{14 11 13 9}, {9 14 11 13}, {13 9 14 11}, {11 13 9 14}};

    // input plaintext, key type and key string
    std::string plaintext = "0123456789abcdeffedcba9876543210";
    const int key_type = 128;
    std::string = "0f1571c947d9e8590cb7add6af7f6798";

    // 
    std::vector<std::vector<int>> IN(4, std::vector<int>(4, 0));
    for (int i = 0; i < 16; i++) {
        IN[i] = hex2dec(plaintext.substr(i, i*2));
    }

    return 0;
}

unsigned long long hex2dec(const std::string &input) {
    unsigned long long result;
    std::stringstream ss;
    ss << hex << uppercase << input;
    ss >> result;
    return result;
}
