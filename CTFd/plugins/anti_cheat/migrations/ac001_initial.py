"""Anti-cheat plugin initial migration

Revision ID: ac001_initial
Revises: 
Create Date: 2025-09-17 00:00:00.000000

"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import mysql, postgresql

# revision identifiers, used by Alembic
revision = 'ac001_initial'
down_revision = None
branch_labels = None
depends_on = None


def upgrade(op=None):
    # Create anti_cheat_config table
    try:
        op.create_table(
            'anti_cheat_config',
            sa.Column('id', sa.Integer, primary_key=True),
            sa.Column('duplicate_flag_threshold', sa.Integer, default=1),
            sa.Column('brute_force_threshold', sa.Integer, default=10),
            sa.Column('brute_force_window', sa.Integer, default=60),
            sa.Column('ip_sharing_threshold', sa.Integer, default=3),
            sa.Column('sequence_similarity_threshold', sa.Float, default=0.8),
            sa.Column('time_delta_threshold', sa.Integer, default=30),
            sa.Column('auto_ban_enabled', sa.Boolean, default=False),
            sa.Column('notification_enabled', sa.Boolean, default=True),
            sa.Column('created_at', sa.DateTime, default=sa.func.now()),
            sa.Column('updated_at', sa.DateTime, default=sa.func.now(), onupdate=sa.func.now())
        )
        print("Created anti_cheat_config table")
    except Exception as e:
        print(f"Table anti_cheat_config creation failed: {e}")
        # Table might already exist
        pass

    # Create anti_cheat_alerts table
    try:
        op.create_table(
            'anti_cheat_alerts',
            sa.Column('id', sa.Integer, primary_key=True),
            sa.Column('alert_type', sa.String(50), nullable=False),
            sa.Column('severity', sa.String(20), default='medium'),
            sa.Column('team_id', sa.Integer, sa.ForeignKey('teams.id'), nullable=True),
            sa.Column('user_id', sa.Integer, sa.ForeignKey('users.id'), nullable=True),
            sa.Column('challenge_id', sa.Integer, sa.ForeignKey('challenges.id'), nullable=True),
            sa.Column('description', sa.Text, nullable=False),
            sa.Column('evidence', sa.JSON),
            sa.Column('ip_address', sa.String(45)),
            sa.Column('status', sa.String(20), default='open'),
            sa.Column('created_at', sa.DateTime, default=sa.func.now()),
            sa.Column('resolved_at', sa.DateTime, nullable=True),
            sa.Column('resolved_by', sa.Integer, sa.ForeignKey('users.id'), nullable=True)
        )
        print("Created anti_cheat_alerts table")
    except Exception as e:
        print(f"Table anti_cheat_alerts creation failed: {e}")
        # Table might already exist
        pass


def downgrade(op=None):
    try:
        op.drop_table('anti_cheat_alerts')
        print("Dropped anti_cheat_alerts table")
    except Exception as e:
        print(f"Error dropping anti_cheat_alerts: {e}")
    
    try:
        op.drop_table('anti_cheat_config')
        print("Dropped anti_cheat_config table")
    except Exception as e:
        print(f"Error dropping anti_cheat_config: {e}")