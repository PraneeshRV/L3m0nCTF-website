"""Add flag column to docker_challenge_tracker table

Revision ID: dc004_add_dynamic_flag
Revises: dc003_add_environment_vars
Create Date: 2025-11-30

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic
revision = 'dc004_add_dynamic_flag'
down_revision = 'dc003_add_environment_vars'
branch_labels = None
depends_on = None


def upgrade(op=None):
    # Add flag column to docker_challenge_tracker table
    try:
        op.add_column('docker_challenge_tracker', sa.Column('flag', sa.String(128), nullable=True))
        print("Added flag column to docker_challenge_tracker table")
    except Exception as e:
        # Column might already exist, that's okay
        print(f"Note: Could not add flag column (may already exist): {e}")


def downgrade(op=None):
    # Remove flag column
    try:
        op.drop_column('docker_challenge_tracker', 'flag')
        print("Removed flag column from docker_challenge_tracker table")
    except Exception as e:
        print(f"Note: Could not remove flag column: {e}")
