#include "BigInt.hpp"
#include <bits/stdc++.h>

int main() {
    // testing basic BigInt operations
    BigInt big1, big2, big3, big4;
    big1 = "1234567890123456789012345678901234567890123456789012345678901234"; // 64-digits
    big2 = "9876543210123456789098765432101234567890132465749987565466598413";
    big3 = "5498741635419846519687479498764984165498465165498461354984943296";
    big4 = "6516519845654981321654989321654697498632165498665498416365498498";
    
    std::cout << big1 << "\n" << big2 << "\n" << big3 << "\n" << big4 << "\n";
    std::cout << "big1 * big2 * big3 * big4 = " << big1 * big2 * big3 * big4 << "\n"; // 256-bit

    // get a random BigInt that has a random number of digits (up to 1000)
    big1 = big_random(10);
    std::cout << "big1 = big_random() = " << big1 << std::endl;

    // get a random BigInt that has 256 digits:
    big1 = big_random(256);
    std::cout << "big1 = big_random(256) = " << big1 << std::endl;

    std::cout << "big3 / 2 = " << big3 / 2 << std::endl;

    using std::cout;
    BigInt first;
    first = "12345";
    cout << "The number of digits"
         << " in first big integer = "
         << Length(first) << '\n';
    BigInt second(12345);
    if (first == second) {
        cout << "first and second are equal!\n";
    }
    else
        cout << "Not equal!\n";
    BigInt third("10000");
    BigInt fourth("100000");
    if (third < fourth) {
        cout << "third is smaller than fourth!\n";
    }
    BigInt fifth("10000000");
    if (fifth > fourth) {
        cout << "fifth is larger than fourth!\n";
    }
 
    // Printing all the numbers
    cout << "first = " << first << '\n';
    cout << "second = " << second << '\n';
    cout << "third = " << third << '\n';
    cout << "fourth = " << fourth<< '\n';
    cout << "fifth = " << fifth<< '\n';
    
    // Incrementing the value of first
    first++;
    cout << "After incrementing the"
         << " value of first is : ";
    cout << first << '\n';
    BigInt sum;
    sum = (fourth + fifth);
    cout << "Sum of fourth and fifth = "
         << sum << '\n';
    BigInt product;
    product = second * third;
    cout << "Product of second and third = "
         << product << '\n';
    
    // Print the fibonaccii number from 1 to 100
    cout << "-------------------------Fibonacci"
         << "------------------------------\n";
    for (int i = 0; i <= 100; i++) {
        BigInt Fib;
        Fib = NthFibonacci(i);
        cout << "Fibonacci " << i << " = " << Fib<<'\n';
    }
    cout << "-------------------------Catalan"
         << "------------------------------\n";
    for (int i = 0; i <= 100; i++) {
        BigInt Cat;
        Cat = NthCatalan(i);
        cout << "Catalan " << i << " = " << Cat<<'\n';
    }
 
    // Calculating factorial of from 1 to 100
    std::cout << "-------------------------Factorial"
         << "------------------------------\n";
    for (int i = 0; i <= 100; i++) {
        BigInt fact;
        fact = Factorial(i);
        std::cout << "Factorial of "
             << i << " = ";
        std::cout << fact << '\n';
    }

    return 0;
} 
