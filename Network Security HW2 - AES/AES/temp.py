def GF256_mult(a, b):
    product = 0
    for i in range(0, 8):
        if (b & 1) == 1: 
            product ^= a
        hi_bit_set = a & 0x80
        a = (a << 1) & 0xFF
        if hi_bit_set == 0x80:
            a ^= 0x1B
        b >>= 1
    return product

def GF256_inv(a):
    if a == 0:
        return 0
    for i in range(1, 255):
        mult = GF256_mult(a, i)
        print(mult)
        if mult == 1:
            return i  

