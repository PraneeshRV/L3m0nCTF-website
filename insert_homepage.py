#!/usr/bin/env python3
"""Script to insert the L3m0n CTF homepage into the CTFd database."""

import os
import sys

# Read the homepage HTML
homepage_path = os.path.join(os.path.dirname(__file__), 'homepage.html')
with open(homepage_path, 'r') as f:
    homepage_content = f.read()

# Escape single quotes for SQL
homepage_content_escaped = homepage_content.replace("'", "''")

# Generate SQL
sql = f"""
INSERT INTO pages (title, route, content, draft, hidden, auth_required, format)
VALUES ('L3m0n CTF 2025', 'index', '{homepage_content_escaped}', 0, 0, 0, 'html');
"""

print(sql)
