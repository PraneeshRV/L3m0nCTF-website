# New Test Challenges

This directory contains test challenges for verifying CTFd Docker plugins.

## Challenge 1: Basic TCP
- **Path**: `challenge_1_tcp`
- **Type**: Docker (TCP)
- **Flag**: `L3m0n{tcp_challenge_working}`
- **Build**: `docker build -t challenge_1_tcp ./challenge_1_tcp`

## Challenge 2: Web Service
- **Path**: `challenge_2_web`
- **Type**: Docker (Web)
- **Flag**: `L3m0n{web_challenge_working}`
- **Build**: `docker build -t challenge_2_web ./challenge_2_web`

## Challenge 3: Dynamic Flag
- **Path**: `challenge_3_dynamic`
- **Type**: Docker (TCP) with Dynamic Flag
- **Flag**: Dynamic (set by CTFd)
- **Build**: `docker build -t challenge_3_dynamic ./challenge_3_dynamic`
- **Note**: Ensure the challenge in CTFd is configured with `FLAG=DYNAMIC` in environment variables.
