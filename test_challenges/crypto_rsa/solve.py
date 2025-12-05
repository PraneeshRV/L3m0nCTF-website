#!/usr/bin/env python3
"""
Solve script for L3m0n CTF Weak RSA Challenge
Uses Fermat's factorization method to factor N when p and q are close.
"""

import requests
import math

def isqrt(n):
    """Integer square root using Newton's method"""
    if n < 0:
        raise ValueError("Square root not defined for negative numbers")
    if n == 0:
        return 0
    x = n
    y = (x + 1) // 2
    while y < x:
        x = y
        y = (x + n // x) // 2
    return x

def fermat_factor(n):
    """
    Fermat's factorization method.
    Works when p and q are close together.
    
    n = p * q = a^2 - b^2 = (a+b)(a-b)
    where a = (p+q)/2 and b = (p-q)/2
    
    Start with a = ceil(sqrt(n)) and check if a^2 - n is a perfect square.
    """
    a = isqrt(n)
    if a * a == n:
        return a, a  # n is a perfect square
    
    # Start searching
    a += 1
    b2 = a * a - n
    
    # Limit iterations
    max_iter = 1000000
    for _ in range(max_iter):
        b = isqrt(b2)
        if b * b == b2:
            # Found factors!
            p = a + b
            q = a - b
            return p, q
        
        # Try next a
        a += 1
        b2 = a * a - n
    
    return None, None

def solve(url='http://localhost:5000'):
    """Solve the challenge by fetching params and factoring N"""
    
    print("🍋 L3m0n CTF - Weak RSA Solver")
    print("=" * 40)
    
    # Fetch parameters
    print("\n[*] Fetching RSA parameters...")
    try:
        r = requests.get(f"{url}/api/params")
        data = r.json()
        n = int(data['n'])
        e = int(data['e'])
        c = int(data['c'])
    except Exception as ex:
        print(f"[-] Error fetching params: {ex}")
        return
    
    print(f"[+] N = {n}")
    print(f"[+] e = {e}")
    print(f"[+] c = {c}")
    
    # Factor N using Fermat's method
    print("\n[*] Attempting Fermat's factorization...")
    p, q = fermat_factor(n)
    
    if p is None:
        print("[-] Fermat's factorization failed!")
        return
    
    print(f"[+] Found p = {p}")
    print(f"[+] Found q = {q}")
    print(f"[+] Verified: p * q = n? {p * q == n}")
    
    # Calculate private key
    print("\n[*] Calculating private key...")
    phi = (p - 1) * (q - 1)
    d = pow(e, -1, phi)
    print(f"[+] d = {d}")
    
    # Decrypt the flag
    print("\n[*] Decrypting ciphertext...")
    m = pow(c, d, n)
    
    # Convert to bytes
    flag_bytes = m.to_bytes((m.bit_length() + 7) // 8, 'big')
    flag = flag_bytes.decode('utf-8')
    
    print(f"\n🏆 FLAG: {flag}")
    return flag

if __name__ == '__main__':
    import sys
    if len(sys.argv) >= 2:
        solve(sys.argv[1])
    else:
        solve()
