# L3m0n PWN Demo Challenge

A simple "pwn" style challenge that demonstrates:
- Dynamic flag injection via environment variable
- TCP connection via netcat (nc)
- Basic authentication vulnerability

## Challenge Details

- **Category**: PWN
- **Difficulty**: Easy
- **Points**: 100

## Description

> Welcome to the L3m0n Secure Vault™!
> 
> Our security team assures us this vault is completely unhackable.
> But between you and me, I heard the security guy loves lemons...
> 
> `nc <host> <port>`

## Solution

The password is: `l3m0n_h4ck3r`

1. Connect using netcat: `nc <host> <port>`
2. Enter the password when prompted
3. Get the flag!

## Hints for Players

- Hint 1: The password is related to our CTF theme...
- Hint 2: Think: lemon + hacker, but l33t speak!

## Building

```bash
docker build -t pwn_demo .
docker run -p 9000:9000 -e FLAG="L3m0nCTF{test_flag}" pwn_demo
```

## Testing

```bash
nc localhost 9000
```

## Dynamic Flag

The challenge reads the flag from the `FLAG` environment variable.
CTFd's docker_challenges plugin will automatically inject a unique flag
for each user/team instance.
