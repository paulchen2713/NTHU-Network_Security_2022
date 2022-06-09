# -*- coding: utf-8 -*-
"""
Created on Wed Jun  8 17:26:49 2022

@author: Paul 
@file:   assign4.py
"""
# COM 5335 Network Security Assignment #4  陳劭珩 110064533

# EC-ElGamal cryptosystem

# Objective
# Implement the General Elliptic Curve Group over prime fields GF(p) and use it to implement the EC-ElGamal cryptosystem

# Description
# General elliptic curve group over a prime field GF(p) can be specified as E: y^2 = x^3 + ax + b with point G.
# The general elliptic curve group can be uniquely determined by the quintuple (p,a,b,G,n).
# In this assignment, we fix the following parameters.

# Parameters
p  = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7FFFFFFF   # p  = FFFFFFFF FFFFFFFF FFFFFFFF FFFFFFFF 7FFFFFFF, p % 4 == 3 
a  = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7FFFFFFC   # a  = FFFFFFFF FFFFFFFF FFFFFFFF FFFFFFFF 7FFFFFFC
b  = 0x1C97BEFC54BD7A8B65ACF89F81D4D4ADC565FA45   # b  = 1C97BEFC 54BD7A8B 65ACF89F 81D4D4AD C565FA45
Gx = 0x4A96B5688EF573284664698968C38BB913CBFC82   # Gx = 4A96B568 8EF57328 46646989 68C38BB9 13CBFC82
Gy = 0x23A628553168947D59DCC912042351377AC5FB32   # Gy = 23A62855 3168947D 59DCC912 04235137 7AC5FB32 
n  = 0x0100000000000000000001F4C8F927AED3CA752257 # n  = 01000000 00000000 000001F4 C8F927AE D3CA7522 57

# Find SQROOT in Zp where p = 3 mod 4
def sqrt_p_3_mod_4(a: int, p: int) -> int:
    """
    :type:  a: int
    :type:  p: int
    :rtype: r: int
    """
    if (p % 2) == 0: 
        raise ValueError('p must be an odd prime')
    # square root of a mod p
    r = pow(a, (p + 1) // 4, p) # r = a^((p + 1) / 4) mod p
    return r

# check if Mx is on the curve
def isOnCurve(Mx: int) -> bool:
    """
    :type:  Mx: int
    :rtype: bool
    """
    # y^2 = x^3 + ax + b over p
    value = (Mx**3 + a*Mx + b) % p
    r = sqrt_p_3_mod_4(value, p)
    if pow(r, 2, p) == value: 
        return True
    else: 
        return False

# data embedding
def data_embedding(M: int):
    """
    :type:  M: int
    :rtype: Mx, My: int, int
    """
    # Input: (m-8)-bit binary data M
    # Output: Point (Mx, My) on the elliptic curve

    Mx = M << 8 # Mx = append(d, 00)
    # while (Mx not on curve)
    while not isOnCurve(Mx):
        Mx += 1 # increment Mx
    
    # compute My (s.t. My % 2 == 1)
    value = (Mx ** 3 + a * Mx + b) % p
    My = sqrt_p_3_mod_4(value, p)
    if My % 2 == 1:
        return Mx, My
    elif My % 2 != 1:
        return Mx, p - My

# the point on the curve 
class Point:
    # constructor
    def __init__(self, x: int, y: int):
        self.x = x
        self.y = y

    # point inverse
    def point_inverse(self):
        self.y = p - self.y

    # point addition
    def point_addition(self, point2):
        """
        :type:  point2: Point
        :rtype: result: Point
        """
        result = Point(0, 0)
        denominator = (point2.x - self.x) % p
        numerator = (point2.y - self.y) % p
        lamb = (pow(denominator, p - 2, p) * numerator) % p
        result.x = (lamb ** 2 - self.x - point2.x) % p
        result.y = (p - self.y + lamb * ((self.x - result.x) % p)) % p
        return result

    # point doubling
    def point_doubling(self):
        """
        :rtype: result: Point
        """
        result = Point(0, 0)
        denominator = (2 * self.y) % p
        numerator = (3 * (self.x ** 2) + a) % p
        lamb = (pow(denominator, p - 2, p) * numerator) % p
        result.x = (lamb ** 2 - 2 * self.x) % p
        result.y = (p - self.y + lamb * ((self.x - result.x) % p)) % p
        return result

    def point_mult_k(self, k: int):
        """
        :type:  k: int
        :rtype: result: Point
        """
        result = Point(-1, -1)
        bin_str = bin(k)[2:]
        #
        for i in bin_str:
            if result.x != -1: 
                result = result.point_doubling()
            elif result.x == -1: 
                result = Point(-1, -1)
            if int(i) == 1 and result.x == -1:
                result = self
            elif int(i) == 1 and result.x != -1:
                result = result.point_addition(self)
        return result

def find_point(P_x, a, b, p):
    """
    :type:  P_x: int
    :type:  a: Literal
    :type:  b: Literal
    :type:  p: Literal
    :rtype: result: Point
    """
    # select even or odd
    mask = 0x10000000000000000000000000000000000000000
    select = P_x // mask # P_x = 2 or 3
    P_x = P_x % mask
    P_y = 0

    # find point P_y
    val = (P_x**3 + a*P_x + b) % p
    r = sqrt_p_3_mod_4(val, p)
    if   select == 2 and r % 2 == 0: P_y = r
    elif select == 2 and r % 2 == 1: P_y = p - r
    elif select == 3 and r % 2 == 0: P_y = p - r
    elif select == 3 and r % 2 == 1: P_y = r
    result = Point(P_x, P_y)
    return result

def show_encryption():
    # Encryption
    print("\n----------------------------------------- <EC-ElGamal Encryption> -----------------------------------------------")
    # NOTE: no space allowed in the input field
    # given sample inputs of M, Pa_x, and nk, compute the corresponding Mx, My and Cm = {Pk, Pb}
    M_str    = ['110BA66CC954BE963A7831D9D9A3D1D39B8EC3',     '8E6F2C1DC3987AFECCC6F7DDFF75EDFC324DF6',     '668E9E1D01A306A1AB76C9949A973248E3AB53']
    Pa_x_str = ['027AB13D6D69847A9CCE9A84E5DB1BDDD87F11F38C', '039994C5C16070EE878F89A6143CE865AC2EC7EC5D', '027AB13D6D69847A9CCE9A84E5DB1BDDD87F11F38C']
    nk_str   = ['8E07EB4265F1200D0745BCB3E47EDD2D23FBF571',   '5487CF3D6F9E4F1C3DAEF5C3CF7D6FC33C675DC6',   '8E07EB4265F1200D0745BCB3E47ADD2D23FBF573']
    for i in range(0, len(M_str)):
        # sample inputs of M, Pa_x, and nk
        print(f"Plaintext M = {M_str[i]}")
        print(f"Pa_x = {Pa_x_str[i]}")
        print(f"nk = {nk_str[i]}")

        # convert input data from hex into int
        M    = int(M_str[i], 16)
        Pa_x = int(Pa_x_str[i], 16)
        nk   = int(nk_str[i], 16)

        # compute the corresponding Mx, My and Cm = {Pk, Pb}
        Mx, My = data_embedding(M)
        Pm = Point(Mx, My)
        
        Mx_str, My_str = format(Mx, 'x').upper(), format(My, 'x').upper()
        print(f'Mx = {Mx_str}') 
        print(f'My = {My_str}')
        
        G = Point(Gx, Gy)     # G(Gx, Gy) is the given point
        Pk = G.point_mult_k(nk) 
        Pa = find_point(Pa_x, a, b, p) # find Pa
        Pb = Pm.point_addition(Pa.point_mult_k(nk))

        Pk_str, Pb_str = format(Pk.x, 'x').upper(), format(Pb.x, 'x').upper()
        print(f'Cm = {{Pk, Pb}} = {{{Pk_str}, {Pb_str}}}\n')

def show_decryption():
    # Decryption
    print("\n----------------------------------------- <EC-ElGamal Decryption> -----------------------------------------------")
    # NOTE: no space allowed in the input field
    # given sample inputs of Pk, Pb and na compute the corresponding Plaintext M
    Pk_str = ['023D5A5C8A80799494624E741A0119804FF707A2AB', '03EFE1AC151C68EDAF3AA85E8D5589FCE27D4C405B', '03BDC5D14A5BA16F6787A050C6CD2F4C4C72AD2671']
    Pb_str = ['023C83F7C52185D5ACBE56171880995F591DFE5C3C', '038970C8F5C2BB301E5EC4D31DDB22524294FDACED', '02A9FC4BBA3F7B3D53D3CEF8D0D9F0165882541CE2']
    na_str = ['3C870C3E99245E0D1C06B747DEB3124DC843BB8B',   '3C870C3E99245E0D1C06B747DEB3124DC843BB8B',   '246FF426810C46F504EE9F2FC69BFA35B02BA373']
    for i in range(0, len(Pk_str)):
        # sample inputs of Pk, Pb and na
        print(f"Pk = {Pk_str[i]}")
        print(f"Pb = {Pb_str[i]}")
        print(f"na = {na_str[i]}")
        
        # convert input data from hex into int
        Pk = int(Pk_str[i], 16)
        Pb = int(Pb_str[i], 16)
        na = int(na_str[i], 16)

        # compute the corresponding Plaintext M
        Pk = find_point(Pk, a, b, p) # choose Pk_y through find_point() process
        Pb = find_point(Pb, a, b, p) # choose Pb_y through find_point() process

        Pk = Pk.point_mult_k(na)
        Pk.point_inverse() # Pk.y = p - Pk.y
        Pm = Pb.point_addition(Pk)

        Plaintext = format(Pm.x, 'x')[:-2].upper()
        print(f'Plaintext = {Plaintext}\n')


# main()
if __name__ == '__main__':
    show_encryption()
    show_decryption()
