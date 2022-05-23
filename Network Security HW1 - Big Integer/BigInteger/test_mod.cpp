#include "BigInt_single_header.hpp"
#include <bits/stdc++.h>

int main() {

    BigInt x, y, p;
	x = "1234567890123456789012345678901234567890123456789012345678901234"; // 64-bit
	y = "32714651746517432176851327416751"; // 32-bit
	p = "3721984197262186519481783219784532179152719415297421976421974977"; // 64-bit

    std::cout << "x: " << x << std::endl;
    std::cout << "y: " << y << std::endl;
    std::cout << "p: " << p << std::endl;
    // std::cout << "Power of '(x^y) \% p' is: " << big_power(x, y, p); // (x^y) % p
    std::cout << "r: " << big_power(x, y, p); // r = (x^y) % p

    return 0;
}
