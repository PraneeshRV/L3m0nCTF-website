# Test Challenges for L3m0nCTF

This directory contains test challenges to verify Docker functionality, dynamic flags, and anti-cheat features.

## 1. Basic TCP Challenge (`basic_tcp`)
Tests basic container deployment and TCP port mapping.
- **Type**: Docker (TCP)
- **Port**: 1337
- **Flag**: `L3m0n{basic_tcp_flag_is_working}`
- **How to use**:
    1. Build: `docker build -t basic_tcp ./basic_tcp`
    2. Run: `docker run -p 1337:1337 basic_tcp`
    3. Test: `nc localhost 1337`

## 2. Web Service Challenge (`web_service`)
Tests HTTP service deployment.
- **Type**: Docker (Web)
- **Port**: 8000
- **Flag**: `L3m0n{web_service_is_working}`
- **How to use**:
    1. Build: `docker build -t web_service ./web_service`
    2. Run: `docker run -p 8000:8000 web_service`
    3. Test: `curl http://localhost:8000`

## 3. Dynamic Flag Challenge (`dynamic_flag`)
Tests dynamic flag injection via environment variables.
- **Type**: Docker (Dynamic)
- **Port**: 1337
- **Flag**: Injected via `FLAG` environment variable.
- **How to use**:
    1. Build: `docker build -t dynamic_flag ./dynamic_flag`
    2. Run: `docker run -p 1337:1337 -e FLAG="L3m0n{dynamic_test}" dynamic_flag`
    3. Test: `nc localhost 1337` (Should return `L3m0n{dynamic_test}`)

## Testing Anti-Cheat Features
The Anti-Cheat plugin monitors user behavior. To test it:

1.  **Flag Sharing**:
    - Create two user accounts.
    - Have User A submit a flag.
    - Have User B submit the *same* flag (if it's a dynamic flag unique to User A, this triggers an alert).
    - If it's a static flag, the plugin might track if User B submits it immediately after User A from the same IP or similar patterns.

2.  **IP Sharing**:
    - Log in with User A.
    - Log in with User B from the *same* IP address (or use a proxy to simulate different IPs if testing the limit).
    - Check `/admin/anti_cheat` for alerts if the limit (default 3) is exceeded.

3.  **Brute Force**:
    - Try to submit incorrect flags rapidly (e.g., 10 times in 10 seconds).
    - Check if the IP gets banned or an alert is generated.
