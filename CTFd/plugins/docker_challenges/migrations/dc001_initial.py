"""Docker challenges plugin initial migration

Revision ID: dc001_initial
Revises: 
Create Date: 2025-09-17 00:00:00.000000

"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import mysql, postgresql

# revision identifiers, used by Alembic
revision = 'dc001_initial'
down_revision = None
branch_labels = None
depends_on = None


def upgrade(op=None):
    # Create docker_config table
    try:
        op.create_table(
            'docker_config',
            sa.Column('id', sa.Integer, primary_key=True),
            sa.Column('name', sa.String(128), nullable=False, index=True),
            sa.Column('hostname', sa.String(128), index=True),
            sa.Column('domain', sa.String(256), nullable=True, index=True),
            sa.Column('tls_enabled', sa.Boolean, default=False, index=True),
            sa.Column('ca_cert', sa.String(2200), index=True),
            sa.Column('client_cert', sa.String(2000), index=True),
            sa.Column('client_key', sa.String(3300), index=True),
            sa.Column('repositories', sa.String(1024), index=True),
            sa.Column('is_active', sa.Boolean, default=True, index=True),
            sa.Column('created_at', sa.DateTime, default=sa.func.now()),
            sa.Column('last_status_check', sa.DateTime, nullable=True),
            sa.Column('status', sa.String(32), default='unknown'),
            sa.Column('status_message', sa.String(512), nullable=True)
        )
        print("Created docker_config table")
    except Exception as e:
        print(f"Table docker_config creation failed: {e}")
        # Table might already exist
        pass

    # Create docker_challenge_tracker table
    try:
        op.create_table(
            'docker_challenge_tracker',
            sa.Column('id', sa.Integer, primary_key=True),
            sa.Column('team_id', sa.String(64), index=True),
            sa.Column('user_id', sa.String(64), index=True),
            sa.Column('docker_image', sa.String(64), index=True),
            sa.Column('timestamp', sa.Integer, index=True),
            sa.Column('revert_time', sa.Integer, index=True),
            sa.Column('instance_id', sa.String(128), index=True),
            sa.Column('ports', sa.String(128), index=True),
            sa.Column('host', sa.String(128), index=True),
            sa.Column('challenge', sa.String(256), index=True),
            sa.Column('docker_config_id', sa.Integer, sa.ForeignKey('docker_config.id'), index=True)
        )
        print("Created docker_challenge_tracker table")
    except Exception as e:
        print(f"Table docker_challenge_tracker creation failed: {e}")
        # Table might already exist
        pass

    # Create docker_challenge table (extends challenges)
    try:
        op.create_table(
            'docker_challenge',
            sa.Column('id', sa.Integer, sa.ForeignKey('challenges.id', ondelete='CASCADE'), primary_key=True),
            sa.Column('docker_image', sa.String(128), index=True),
            sa.Column('docker_config_id', sa.Integer, sa.ForeignKey('docker_config.id'), index=True)
        )
        print("Created docker_challenge table")
    except Exception as e:
        print(f"Table docker_challenge creation failed: {e}")
        # Table might already exist
        pass


def downgrade(op=None):
    try:
        op.drop_table('docker_challenge')
        print("Dropped docker_challenge table")
    except Exception as e:
        print(f"Error dropping docker_challenge: {e}")
    
    try:
        op.drop_table('docker_challenge_tracker')
        print("Dropped docker_challenge_tracker table")
    except Exception as e:
        print(f"Error dropping docker_challenge_tracker: {e}")
    
    try:
        op.drop_table('docker_config')
        print("Dropped docker_config table")
    except Exception as e:
        print(f"Error dropping docker_config: {e}")