#!/usr/bin/env python3
"""
L3m0n PWN Demo - Simple Buffer Overflow Challenge
This challenge demonstrates:
1. Dynamic flag injection via FLAG environment variable
2. Basic nc connectivity test
3. A simple "pwn" style interaction
"""

import os
import sys
import time

# ASCII Art Banner
BANNER = """
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║   🍋 L3m0nCTF - PWN Demo Challenge 🍋                        ║
║                                                               ║
║   Welcome to the L3m0n Secure Vault™                         ║
║   "Where your secrets are safe... or are they?"              ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
"""

def print_slow(text, delay=0.02):
    """Print text with a slight delay for effect"""
    for char in text:
        sys.stdout.write(char)
        sys.stdout.flush()
        time.sleep(delay)
    print()

def main():
    # Get the dynamic flag from environment variable
    # This is injected by the CTFd docker_challenges plugin
    FLAG = os.environ.get('FLAG', 'L3m0nCTF{default_flag_for_testing}')
    
    # Secret password (intentionally weak for the challenge)
    SECRET_PASSWORD = "l3m0n_h4ck3r"
    
    print(BANNER)
    print()
    
    print("[*] System Status: ONLINE")
    print("[*] Security Level: MAXIMUM")
    print("[*] Vault Status: LOCKED")
    print()
    
    try:
        # Authentication attempt
        print("╔════════════════════════════════════╗")
        print("║     AUTHENTICATION REQUIRED        ║")
        print("╚════════════════════════════════════╝")
        print()
        
        sys.stdout.write("[?] Enter access code: ")
        sys.stdout.flush()
        
        user_input = sys.stdin.readline().strip()
        
        if user_input == SECRET_PASSWORD:
            print()
            print("[+] ACCESS GRANTED!")
            print("[+] Welcome, L3m0n Hacker!")
            print()
            print("╔════════════════════════════════════════════════════════════╗")
            print("║               🏆 FLAG RETRIEVED! 🏆                        ║")
            print("╚════════════════════════════════════════════════════════════╝")
            print()
            print(f"[FLAG] {FLAG}")
            print()
            print("[*] This flag is unique to YOUR instance!")
            print("[*] Sharing flags is detected by our anti-cheat system.")
            print()
        elif user_input.lower() == "hint":
            print()
            print("[*] Hint: The password is related to our CTF theme...")
            print("[*] Think: lemon + hacker, but l33t speak!")
            print()
        elif user_input.lower() == "help":
            print()
            print("[*] Commands:")
            print("    - Enter the password to access the vault")
            print("    - Type 'hint' for a clue")
            print("    - Type 'help' for this message")
            print()
        else:
            print()
            print("[!] ACCESS DENIED!")
            print("[!] Invalid access code.")
            print("[!] Security alert has been logged.")
            print()
            print("[*] Try 'hint' for a clue or 'help' for commands.")
            print()
            
    except EOFError:
        print("\n[!] Connection terminated.")
    except KeyboardInterrupt:
        print("\n[!] Session interrupted.")
    
    print("[*] Connection closed. Goodbye!")

if __name__ == "__main__":
    main()
