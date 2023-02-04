// C++ implemented BigInt 
#include <bits/stdc++.h>

using namespace std;

class BigInt {
	std::string digits;
public:
	//Constructors:
	BigInt(unsigned long long n = 0);
	BigInt(string &);
	BigInt(const char *);
	BigInt(BigInt &);

	//Helper Functions:
	friend void divide_by_2(BigInt &a);
	friend bool Null(const BigInt &);
	friend int Length(const BigInt &);
	int operator[](const int)const;

			/* * * * Operator Overloading * * * */

	//Direct assignment
	BigInt &operator=(const BigInt &);

	//Post/Pre - Incrementation
	BigInt &operator++();
	BigInt operator++(int temp);
	BigInt &operator--();
	BigInt operator--(int temp);

	//Addition and Subtraction
	friend BigInt &operator+=(BigInt &, const BigInt &);
	friend BigInt operator+(const BigInt &, const BigInt &);
	friend BigInt operator-(const BigInt &, const BigInt &);
	friend BigInt &operator-=(BigInt &, const BigInt &);

	//Comparison operators
	friend bool operator==(const BigInt &, const BigInt &);
	friend bool operator!=(const BigInt &, const BigInt &);

	friend bool operator>(const BigInt &, const BigInt &);
	friend bool operator>=(const BigInt &, const BigInt &);
	friend bool operator<(const BigInt &, const BigInt &);
	friend bool operator<=(const BigInt &, const BigInt &);

	//Multiplication and Division
	friend BigInt &operator*=(BigInt &, const BigInt &);
	friend BigInt operator*(const BigInt &, const BigInt &);
	friend BigInt &operator/=(BigInt &, const BigInt &);
	friend BigInt operator/(const BigInt &, const BigInt &);

	//Modulo
	friend BigInt operator%(const BigInt &, const BigInt &);
	friend BigInt &operator%=(BigInt &, const BigInt &);

	//Power Function
	friend BigInt &operator^=(BigInt &,const BigInt &);
	friend BigInt operator^(BigInt &, const BigInt &);
	
	//Square Root Function
	friend BigInt sqrt(BigInt &a);

	//Read and Write
	friend ostream &operator<<(ostream &,const BigInt &);
	friend istream &operator>>(istream &, BigInt &);

	//Others
	friend BigInt big_random(size_t num_digits);
	friend BigInt NthCatalan(int n);
	friend BigInt NthFibonacci(int n);
	friend BigInt Factorial(int n);
};

BigInt::BigInt(string & s) {
	digits = "";
	int n = s.size();
	for (int i = n - 1; i >= 0;i--) {
		if (!isdigit(s[i])) {
			throw("ERROR");
		}
		digits.push_back(s[i] - '0');
	}
}
BigInt::BigInt(unsigned long long nr) {
	do {
		digits.push_back(nr % 10);
		nr /= 10;
	} while (nr);
}
BigInt::BigInt(const char *s) {
	digits = "";
	for (int i = strlen(s) - 1; i >= 0; i--) {
		if(!isdigit(s[i])) {
			throw("ERROR");
		}
		digits.push_back(s[i] - '0');
	}
}
BigInt::BigInt(BigInt & a) {
	digits = a.digits;
}

bool Null(const BigInt& a) {
	if (a.digits.size() == 1 && a.digits[0] == 0) {
		return true;
	}
	return false;
}
int Length(const BigInt & a) {
	return a.digits.size();
}
int BigInt::operator[](const int index) const {
	if(digits.size() <= index || index < 0)
		throw("ERROR");
	return digits[index];
}
bool operator==(const BigInt &a, const BigInt &b) {
	return a.digits == b.digits;
}
bool operator!=(const BigInt & a,const BigInt &b) {
	return !(a == b);
}
bool operator<(const BigInt&a,const BigInt&b) {
	int n = Length(a), m = Length(b);
	if(n != m)
		return n < m;
	while(n--)
		if(a.digits[n] != b.digits[n])
			return a.digits[n] < b.digits[n];
	return false;
}
bool operator>(const BigInt&a,const BigInt&b) {
	return b < a;
}
bool operator>=(const BigInt&a,const BigInt&b) {
	return !(a < b);
}
bool operator<=(const BigInt&a,const BigInt&b) {
	return !(a > b);
}

BigInt &BigInt::operator=(const BigInt &a) {
	digits = a.digits;
	return *this;
}

BigInt &BigInt::operator++() {
	int i, n = digits.size();
	for (i = 0; i < n && digits[i] == 9;i++)
		digits[i] = 0;
	if (i == n) {
		digits.push_back(1);
	}
	else digits[i]++;
	return *this;
}
BigInt BigInt::operator++(int temp) {
	BigInt aux;
	aux = *this;
	++(*this);
	return aux;
}

BigInt &BigInt::operator--() {
	if(digits[0] == 0 && digits.size() == 1)
		throw("UNDERFLOW");
	int i, n = digits.size();
	for (i = 0; digits[i] == 0 && i < n;i++)
		digits[i] = 9;
	digits[i]--;
	if(n > 1 && digits[n - 1] == 0)
		digits.pop_back();
	return *this;
}
BigInt BigInt::operator--(int temp) {
	BigInt aux;
	aux = *this;
	--(*this);
	return aux;
}

BigInt &operator+=(BigInt &a,const BigInt& b) {
	int t = 0, s, i;
	int n = Length(a), m = Length(b);
	if (m > n) {
		a.digits.append(m - n, 0);
	}
	n = Length(a);
	for (i = 0; i < n; i++) {
		if (i < m) {
			s = (a.digits[i] + b.digits[i]) + t;
		}
		else s = a.digits[i] + t;
		t = s / 10;
		a.digits[i] = (s % 10);
	}
	if (t) a.digits.push_back(t);
	return a;
}
BigInt operator+(const BigInt &a, const BigInt &b){
	BigInt temp;
	temp = a;
	temp += b;
	return temp;
}

BigInt &operator-=(BigInt&a,const BigInt &b){
	if(a < b)
		throw("UNDERFLOW");
	int n = Length(a), m = Length(b);
	int i, t = 0, s;
	for (i = 0; i < n;i++){
		if(i < m)
			s = a.digits[i] - b.digits[i]+ t;
		else
			s = a.digits[i]+ t;
		if(s < 0)
			s += 10,
			t = -1;
		else
			t = 0;
		a.digits[i] = s;
	}
	while(n > 1 && a.digits[n - 1] == 0)
		a.digits.pop_back(),
		n--;
	return a;
}
BigInt operator-(const BigInt& a, const BigInt&b) {
	BigInt temp;
	temp = a;
	temp -= b;
	return temp;
}

BigInt &operator*=(BigInt &a, const BigInt &b) {
	if (Null(a) || Null(b)) {
		a = BigInt();
		return a;
	}
	int n = a.digits.size(), m = b.digits.size();
	vector<int> v(n + m, 0);
	for (int i = 0; i < n; i++) {
		for (int j = 0; j < m; j++) {
			v[i + j] += (a.digits[i] ) * (b.digits[j]);
		}
	}
	n += m;
	a.digits.resize(v.size());
	for (int s, i = 0, t = 0; i < n; i++) {
		s = t + v[i];
		v[i] = s % 10;
		t = s / 10;
		a.digits[i] = v[i] ;
	}
	for (int i = n - 1; i >= 1 && !v[i]; i--) {
		a.digits.pop_back();
	}
	return a;
}
BigInt operator*(const BigInt& a, const BigInt& b) {
	BigInt temp;
	temp = a;
	temp *= b;
	return temp;
}

BigInt &operator/=(BigInt& a,const BigInt &b) {
	if (Null(b)) {
		throw("Arithmetic Error: Division By 0");
	}
	if (a < b) {
		a = BigInt();
		return a;
	}
	if (a == b) {
		a = BigInt(1);
		return a;
	}
	int i, lgcat = 0, cc;
	int n = Length(a), m = Length(b);
	vector<int> cat(n, 0);
	BigInt t;
	for (i = n - 1; t * 10 + a.digits[i] < b; i--) {
		t *= 10;
		t += a.digits[i] ;
	}
	for (; i >= 0; i--) {
		t = t * 10 + a.digits[i];
		for (cc = 9; cc * b > t;cc--);
		t -= cc * b;
		cat[lgcat++] = cc;
	}
	a.digits.resize(cat.size());
	for (i = 0; i < lgcat;i++) {
		a.digits[i] = cat[lgcat - i - 1];
	}
	a.digits.resize(lgcat);
	return a;
}
BigInt operator/(const BigInt &a, const BigInt &b) {
	BigInt temp;
	temp = a;
	temp /= b;
	return temp;
}

BigInt &operator%=(BigInt& a,const BigInt &b) {
	if (Null(b)) {
		throw("Arithmetic Error: Division By 0");
	}
	if (a < b) {
		a = BigInt();
		return a;
	}
	if (a == b) {
		a = BigInt(1);
		return a;
	}
	int i, lgcat = 0, cc;
	int n = Length(a), m = Length(b);
	vector<int> cat(n, 0);
	BigInt t;
	for (i = n - 1; t * 10 + a.digits[i] < b; i--) {
		t *= 10;
		t += a.digits[i];
	}
	for (; i >= 0; i--) {
		t = t * 10 + a.digits[i];
		for (cc = 9; cc * b > t; cc--);
		t -= cc * b;
		cat[lgcat++] = cc;
	}
	a = t;
	return a;
}
BigInt operator%(const BigInt &a, BigInt &b) {
	BigInt temp;
	temp = a;
	temp %= b;
	return temp;
}

BigInt &operator^=(BigInt& a, const BigInt& b) {
	BigInt Exponent, Base(a);
	Exponent = b;
	a = 1;
	while (!Null(Exponent)) {
		if (Exponent[0] & 1) a *= Base;
		Base *= Base;
		divide_by_2(Exponent);
	}
	return a;
}
BigInt operator^(BigInt& a, BigInt& b) {
	BigInt temp(a);
	temp ^= b;
	return temp;
}

void divide_by_2(BigInt & a) {
	int add = 0;
	for (int i = a.digits.size() - 1; i >= 0; i--) {
		int digit = (a.digits[i] >> 1) + add;
		add = ((a.digits[i] & 1) * 5);
		a.digits[i] = digit;
	}
	while (a.digits.size() > 1 && !a.digits.back()) {
		a.digits.pop_back();
	}
}

BigInt sqrt(BigInt& a) {
	BigInt left(1), right(a), v(1), mid, prod;
	divide_by_2(right);
	while (left <= right) {
		mid += left;
		mid += right;
		divide_by_2(mid);
		prod = (mid * mid);
		if (prod <= a) {
			v = mid;
			mid++;
			left = mid;
		}
		else{
			--mid;
			right = mid;
		}
		mid = BigInt();
	}
	return v;
}

BigInt NthCatalan(int n) {
	BigInt a(1), b;
	for (int i = 2; i <= n; i++) {
		a *= i;
	}
	b = a;
	for (int i = n + 1; i <= 2 * n; i++) {
		b *= i;
	}
	a *= a;
	a *= (n + 1);
	b /= a;
	return b;
}

BigInt NthFibonacci(int n) {
	BigInt a(1), b(1), c;
	if (!n) return c;
	n--;
	while (n-- > 0) {
		c = a + b;
		b = a;
		a = c;
	}
	return b;
}

BigInt Factorial(int n) {
	BigInt f(1);
	for (int i = 2; i <= n; i++) {
		f *= i;
	}
	return f;
}

// when the number of digits are not specified, a random value is used 
// for it, which is kept below the following:
const size_t MAX_RANDOM_LENGTH = 1000;

/*
    big_random (num_digits)
    -----------------------
    Returns a random BigInt with a specific number of digits.
*/

BigInt big_random(size_t num_digits = 0) {
    // true random number generator, if we do have a random device
    // std::random_device rand_generator;  

    // use the system entropy as random seed, not working properly
    std::random_device rd;  
    // Mersenne Twister Random Number Generator Algorithm,
    // std::mt19937_64 (64-bit), or std::mt19937 (32-bit)
    std::mt19937_64 rand_generator(clock()); // seeds: time(0), clock()

    if (num_digits == 0) {   // the number of digits were not specified           
        // use a random number for it:
        num_digits = 1 + rand_generator() % MAX_RANDOM_LENGTH;
    }

    BigInt big_rand;
    big_rand.digits = "";    // clear value to append digits

    // ensure that the first digit is non-zero
    big_rand.digits += std::to_string(1 + rand_generator() % 9);

    while (big_rand.digits.size() < num_digits) {
        big_rand.digits += std::to_string(rand_generator());
    }
    if (big_rand.digits.size() != num_digits) { 
        big_rand.digits.erase(num_digits);      // erase extra digits
    }
    return big_rand;
}

istream &operator>>(istream &in,BigInt&a) {
	string s;
	in >> s;
	int n = s.size();
	for (int i = n - 1; i >= 0; i--) {
		if (!isdigit(s[i])) throw("INVALID NUMBER");
		a.digits[n - i - 1] = s[i];
	}
	return in;
}

ostream &operator<<(ostream &out, const BigInt &a) {
	for (int i = a.digits.size() - 1; i >= 0; i--) {
		cout << (short)a.digits[i];
	}
	return cout;
}

//Driver code with some examples
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

	
	BigInt first("12345");
	std::cout << "The number of digits"
		<< " in first big integer = "
		<< Length(first) << '\n';
	BigInt second(12345);
	if (first == second) {
		std::cout << "first and second are equal!\n";
	}
	else cout << "Not equal!\n";
	
	BigInt third("10000");
	BigInt fourth("100000");
	if (third < fourth) {
		std::cout << "third is smaller than fourth!\n";
	}
	BigInt fifth("10000000");
	if (fifth > fourth) {
		std::cout << "fifth is larger than fourth!\n";
	}

	// Printing all the numbers
	std::cout << "first = " << first << '\n';
	std::cout << "second = " << second << '\n';
	std::cout << "third = " << third << '\n';
	std::cout << "fourth = " << fourth<< '\n';
	std::cout << "fifth = " << fifth<< '\n';

	// Incrementing the value of first
	first++;
	std::cout << "After incrementing the"
		<< " value of first is : ";
	std::cout << first << '\n';
	BigInt sum;
	sum = (fourth + fifth);
	std::cout << "Sum of fourth and fifth = "
		<< sum << '\n';
	BigInt product;
	product = second * third;
	std::cout << "Product of second and third = "
		<< product << '\n';

	// Print the fibonaccii number from 1 to 100
	std::cout << "-------------------------Fibonacci"
		<< "------------------------------\n";
	for (int i = 91; i <= 100; i++) {
		BigInt Fib;
		Fib = NthFibonacci(i);
		std::cout << "Fibonacci " << i << " = " << Fib<<'\n';
	}
	std::cout << "-------------------------Catalan"
		<< "------------------------------\n";
	for (int i = 91; i <= 100; i++) {
		BigInt Cat;
		Cat = NthCatalan(i);
		std::cout << "Catalan " << i << " = " << Cat<<'\n';
	}

	// Calculating factorial of from 1 to 100
	std::cout << "-------------------------Factorial"
		<< "------------------------------\n";
	for (int i = 91; i <= 100; i++) {
		BigInt fact;
		fact = Factorial(i);
		std::cout << "Factorial of "
			<< i << " = ";
		std::cout << fact << '\n';
	}

    return 0;
}


