#!/usr/bin/env python3
"""
Script to update the CTFd homepage with the new button layout.
Reads from homepage.html and updates the database.
"""

import os
import sys

# Add the CTFd directory to path
sys.path.insert(0, '/home/crimson/Praneesh/L3m0nCTF-website')

from CTFd import create_app
from CTFd.models import Pages, db

def update_homepage():
    app = create_app()
    
    with app.app_context():
        # Read the homepage HTML file
        with open('/opt/CTFd/homepage.html', 'r') as f:
            new_content = f.read()
        
        # Find the index page
        page = Pages.query.filter_by(route='index').first()
        
        if page:
            page.content = new_content
            db.session.commit()
            print("✅ Homepage updated successfully!")
            print(f"   Route: {page.route}")
            print(f"   Title: {page.title}")
        else:
            print("❌ No 'index' page found in database")
            print("   Available pages:")
            for p in Pages.query.all():
                print(f"   - {p.route}: {p.title}")

if __name__ == '__main__':
    update_homepage()
