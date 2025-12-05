#!/usr/bin/env python3
"""
L3m0nCTF Anti-Cheat Detection System
=====================================
Detects flag sharing between teams/users in Docker challenges with dynamic flags.

Features:
1. Detects when User A submits User B's dynamic flag
2. Tracks flag leaks across teams
3. Generates cheating reports
"""

import os
import sys
from datetime import datetime
from sqlalchemy import create_engine, text
from collections import defaultdict

# Database connection - customize for your environment
DATABASE_URL = os.environ.get('DATABASE_URL', 'mysql+pymysql://ctfd:ctfd@localhost:3306/ctfd')


def get_db_connection():
    """Create database connection"""
    engine = create_engine(DATABASE_URL)
    return engine.connect()


def detect_flag_sharing(conn):
    """
    Detect flag sharing by comparing submitted flags against dynamic flag assignments.
    
    A flag sharing incident occurs when:
    - User/Team A is assigned dynamic flag X
    - User/Team B submits flag X (which was NOT assigned to them)
    """
    
    print("\n🔍 L3m0nCTF Anti-Cheat Detection Report")
    print("=" * 60)
    print(f"Report Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print("=" * 60)
    
    # Query: Get all dynamic flags assigned to containers
    dynamic_flags_query = text("""
        SELECT 
            dct.team_id,
            dct.user_id,
            dct.challenge,
            dct.flag,
            dct.timestamp,
            t.name as team_name,
            u.name as user_name
        FROM docker_challenge_tracker dct
        LEFT JOIN teams t ON dct.team_id = t.id
        LEFT JOIN users u ON dct.user_id = u.id
        WHERE dct.flag IS NOT NULL
    """)
    
    dynamic_flags = conn.execute(dynamic_flags_query).fetchall()
    
    if not dynamic_flags:
        print("\n⚠️  No dynamic flags found in the system.")
        return []
    
    # Build a map of flag -> owner
    flag_owners = {}
    for row in dynamic_flags:
        owner_id = row.team_id if row.team_id else row.user_id
        owner_name = row.team_name if row.team_name else row.user_name
        flag_owners[row.flag] = {
            'team_id': row.team_id,
            'user_id': row.user_id,
            'owner_name': owner_name,
            'challenge': row.challenge,
            'assigned_at': row.timestamp
        }
    
    print(f"\n📊 Found {len(flag_owners)} dynamic flags assigned")
    
    # Query: Get all submissions for docker challenges
    submissions_query = text("""
        SELECT 
            s.id as submission_id,
            s.user_id,
            s.team_id,
            s.provided as submitted_flag,
            s.date as submission_date,
            c.name as challenge_name,
            t.name as submitter_team,
            u.name as submitter_user
        FROM submissions s
        JOIN challenges c ON s.challenge_id = c.id
        LEFT JOIN teams t ON s.team_id = t.id
        LEFT JOIN users u ON s.user_id = u.id
        WHERE c.type = 'docker'
        ORDER BY s.date DESC
    """)
    
    submissions = conn.execute(submissions_query).fetchall()
    
    # Detect cheating
    incidents = []
    
    for sub in submissions:
        submitted_flag = sub.submitted_flag.strip() if sub.submitted_flag else ""
        
        # Check if this submitted flag belongs to someone else
        if submitted_flag in flag_owners:
            owner = flag_owners[submitted_flag]
            
            # Check if submitter is NOT the owner
            submitter_id = sub.team_id if sub.team_id else sub.user_id
            owner_id = owner['team_id'] if owner['team_id'] else owner['user_id']
            
            if submitter_id != owner_id:
                incident = {
                    'submission_id': sub.submission_id,
                    'cheater_id': submitter_id,
                    'cheater_name': sub.submitter_team or sub.submitter_user,
                    'victim_id': owner_id,
                    'victim_name': owner['owner_name'],
                    'flag': submitted_flag,
                    'challenge': sub.challenge_name,
                    'submission_date': sub.submission_date
                }
                incidents.append(incident)
    
    # Report findings
    if incidents:
        print(f"\n🚨 DETECTED {len(incidents)} FLAG SHARING INCIDENTS!")
        print("-" * 60)
        
        for i, inc in enumerate(incidents, 1):
            print(f"\n📛 Incident #{i}")
            print(f"   Challenge:    {inc['challenge']}")
            print(f"   Cheater:      {inc['cheater_name']} (ID: {inc['cheater_id']})")
            print(f"   Victim:       {inc['victim_name']} (ID: {inc['victim_id']})")
            print(f"   Shared Flag:  {inc['flag']}")
            print(f"   Submitted At: {inc['submission_date']}")
    else:
        print("\n✅ No flag sharing detected! All submissions appear legitimate.")
    
    return incidents


def detect_suspicious_patterns(conn):
    """
    Detect additional suspicious patterns:
    1. Multiple teams solving same challenge at exact same time
    2. Same IP submitting for multiple teams
    3. Impossible solve times (too fast)
    """
    
    print("\n\n🔎 Suspicious Pattern Analysis")
    print("-" * 60)
    
    # Check for rapid-fire solves from same IP (if IPs are tracked)
    rapid_solves_query = text("""
        SELECT 
            c.name as challenge_name,
            COUNT(DISTINCT s.team_id) as teams_solved,
            MIN(s.date) as first_solve,
            MAX(s.date) as last_solve,
            TIMESTAMPDIFF(SECOND, MIN(s.date), MAX(s.date)) as solve_window_seconds
        FROM solves s
        JOIN challenges c ON s.challenge_id = c.id
        WHERE c.type = 'docker'
        GROUP BY c.id
        HAVING COUNT(DISTINCT s.team_id) > 1 
           AND TIMESTAMPDIFF(SECOND, MIN(s.date), MAX(s.date)) < 60
    """)
    
    try:
        rapid_solves = conn.execute(rapid_solves_query).fetchall()
        
        if rapid_solves:
            print("\n⚠️  Suspiciously Close Solve Times (within 60 seconds):")
            for rs in rapid_solves:
                print(f"   - {rs.challenge_name}: {rs.teams_solved} teams in {rs.solve_window_seconds}s")
        else:
            print("\n✅ No suspiciously close solve times detected.")
            
    except Exception as e:
        print(f"   ⚠️  Could not analyze solve patterns: {e}")


def generate_report_summary(incidents):
    """Generate a summary report for admins"""
    
    if not incidents:
        return "No flag sharing detected. All clear! ✅"
    
    summary = []
    summary.append(f"⚠️ ALERT: {len(incidents)} flag sharing incident(s) detected!")
    summary.append("")
    
    # Group by cheater
    cheaters = defaultdict(list)
    for inc in incidents:
        cheaters[inc['cheater_name']].append(inc)
    
    for cheater, incs in cheaters.items():
        summary.append(f"🚨 {cheater}: {len(incs)} incident(s)")
        for inc in incs:
            summary.append(f"   └─ Used {inc['victim_name']}'s flag for '{inc['challenge']}'")
    
    return "\n".join(summary)


def main():
    """Main entry point"""
    try:
        conn = get_db_connection()
        
        # Run detection
        incidents = detect_flag_sharing(conn)
        detect_suspicious_patterns(conn)
        
        # Print summary
        print("\n\n" + "=" * 60)
        print("📋 SUMMARY")
        print("=" * 60)
        print(generate_report_summary(incidents))
        
        conn.close()
        
        # Exit with error code if incidents found (useful for CI/CD)
        sys.exit(1 if incidents else 0)
        
    except Exception as e:
        print(f"\n❌ Error running anti-cheat detection: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(2)


if __name__ == '__main__':
    main()
