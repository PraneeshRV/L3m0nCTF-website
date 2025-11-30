### Anti-Cheat

Behavioral analysis and cheat detection for CTFd. Real-time monitoring with automated response.

`CTFd v3.8.0` Tested
 
#### Features

IP sharing detection
Flag sharing analysis  
Brute force protection
Time-based anomaly detection
Real-time alerts with admin dashboard
Automated response system

#### Setup

```
docker compose up --build
```

Plugin loads automatically. Configure via `/admin/anti_cheat`

#### Configuration

Basic setup:
- Flag sharing threshold: 0.85
- Brute force window: 300 seconds  
- IP sharing limit: 3 users per IP
- Auto-actions: configurable

#### Database Tables

`anti_cheat_config` - Detection settings
`anti_cheat_alerts` - Security alerts  

#### Admin Endpoints

- `/admin/anti_cheat` - Dashboard
- `/admin/anti_cheat/config` - Settings
- `/api/v1/anticheat/alerts` - Alert API

```
Author: Abu
```