#!/usr/bin/env python3
"""Restore sponsors page from backup."""
import json
import pymysql

# Load sponsors content from backup
with open('/home/crimson/Praneesh/L3m0nCTF-website/L3m0nCTF.2025-12-05_12_23_31/db/pages.json', 'r') as f:
    data = json.load(f)

sponsors_content = None
for page in data['results']:
    if page['route'] == 'sponsors':
        sponsors_content = page['content']
        break

if not sponsors_content:
    print("ERROR: Sponsors page not found in backup!")
    exit(1)

print(f"Found sponsors page content ({len(sponsors_content)} chars)")

# Connect to database
conn = pymysql.connect(
    host='127.0.0.1',
    port=3306,
    user='ctfd',
    password='ctfd',
    database='ctfd',
    charset='utf8mb4'
)

cursor = conn.cursor()

# Check if sponsors page exists
cursor.execute("SELECT id FROM pages WHERE route = 'sponsors'")
result = cursor.fetchone()

if result:
    # Update existing page
    cursor.execute(
        "UPDATE pages SET content = %s WHERE route = 'sponsors'",
        (sponsors_content,)
    )
    print(f"Updated existing sponsors page (id: {result[0]})")
else:
    # Insert new page
    cursor.execute(
        """INSERT INTO pages (title, route, content, draft, hidden, auth_required, format) 
           VALUES ('Sponsors', 'sponsors', %s, 0, 0, 0, 'html')""",
        (sponsors_content,)
    )
    print(f"Inserted new sponsors page (id: {cursor.lastrowid})")

conn.commit()
cursor.close()
conn.close()

print("Done! Sponsors page restored successfully.")
