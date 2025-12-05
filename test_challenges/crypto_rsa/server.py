#!/usr/bin/env python3
"""
L3m0n CTF - Weak RSA Challenge
The vulnerability: Using small prime numbers (Fermat factorization)
"""

from flask import Flask, render_template_string, jsonify
from Crypto.Util.number import bytes_to_long, long_to_bytes, getPrime, GCD
import random
import os

app = Flask(__name__)

# Read the flag
FLAG = open('flag.txt', 'r').read().strip()

def generate_weak_rsa():
    """
    Generate RSA with close primes (vulnerable to Fermat factorization)
    """
    # Generate base prime
    base = getPrime(256)
    
    # Generate p and q close together (WEAKNESS!)
    # In secure RSA, p and q should be far apart
    p = base
    q = base + random.randint(2, 1000) * 2  # Close to p
    
    # Ensure q is prime
    while not is_prime(q):
        q += 2
    
    n = p * q
    phi = (p - 1) * (q - 1)
    
    # Standard public exponent
    e = 65537
    
    # Calculate private key
    d = pow(e, -1, phi)
    
    return n, e, d, p, q

def is_prime(n, k=10):
    """Miller-Rabin primality test"""
    if n < 2:
        return False
    if n == 2 or n == 3:
        return True
    if n % 2 == 0:
        return False
    
    r, d = 0, n - 1
    while d % 2 == 0:
        r += 1
        d //= 2
    
    for _ in range(k):
        a = random.randrange(2, n - 1)
        x = pow(a, d, n)
        if x == 1 or x == n - 1:
            continue
        for _ in range(r - 1):
            x = pow(x, 2, n)
            if x == n - 1:
                break
        else:
            return False
    return True

# Generate challenge on startup
N, E, D, P, Q = generate_weak_rsa()
FLAG_INT = bytes_to_long(FLAG.encode())
CIPHERTEXT = pow(FLAG_INT, E, N)

HTML_TEMPLATE = """
<!DOCTYPE html>
<html>
<head>
    <title>🍋 L3m0n Crypto - Weak RSA</title>
    <style>
        body {
            background: linear-gradient(135deg, #1a1a2e, #16213e);
            color: #e0e0e0;
            font-family: 'Courier New', monospace;
            min-height: 100vh;
            padding: 40px;
        }
        .container {
            max-width: 900px;
            margin: 0 auto;
            background: rgba(0,0,0,0.3);
            padding: 30px;
            border-radius: 15px;
            border: 1px solid rgba(247, 220, 111, 0.3);
        }
        h1 { color: #f7dc6f; text-align: center; }
        .param {
            background: #0f0f23;
            padding: 15px;
            border-radius: 8px;
            margin: 10px 0;
            overflow-x: auto;
            word-break: break-all;
        }
        .label {
            color: #f7dc6f;
            font-weight: bold;
        }
        .hint {
            color: #888;
            font-style: italic;
            margin-top: 20px;
            padding: 15px;
            background: rgba(247, 220, 111, 0.1);
            border-radius: 8px;
        }
        code { color: #2ecc71; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🍋 L3m0n CTF - Weak RSA Challenge 🍋</h1>
        
        <p>I encrypted the flag with RSA! Good luck decrypting it...</p>
        
        <div class="param">
            <span class="label">N (modulus):</span><br>
            {{ n }}
        </div>
        
        <div class="param">
            <span class="label">e (public exponent):</span><br>
            {{ e }}
        </div>
        
        <div class="param">
            <span class="label">c (ciphertext):</span><br>
            {{ c }}
        </div>
        
        <div class="hint">
            <strong>💡 Hint:</strong> Maybe the primes aren't as random as they should be...<br>
            Think about what makes RSA weak. What if <code>p</code> and <code>q</code> are too close?
        </div>
        
        <div class="hint">
            <strong>📚 Learn:</strong> Research "Fermat's factorization method" for RSA.
        </div>
    </div>
</body>
</html>
"""

@app.route('/')
def index():
    return render_template_string(HTML_TEMPLATE, n=N, e=E, c=CIPHERTEXT)

@app.route('/api/params')
def params():
    """Return parameters as JSON for scripting"""
    return jsonify({
        'n': str(N),
        'e': E,
        'c': str(CIPHERTEXT)
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
