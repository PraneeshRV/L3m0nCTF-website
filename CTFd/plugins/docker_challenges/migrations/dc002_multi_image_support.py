"""Docker challenges plugin multi-image support migration

Revision ID: dc002_multi_image_support
Revises: dc001_initial
Create Date: 2025-09-24 00:00:00.000000

"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import mysql, postgresql

# revision identifiers, used by Alembic
revision = 'dc002_multi_image_support'
down_revision = 'dc001_initial'
branch_labels = None
depends_on = None


def upgrade(op=None):
    # Add new columns to docker_challenge table
    try:
        op.add_column('docker_challenge', sa.Column('challenge_type', sa.String(32), default='single'))
        print("Added challenge_type column to docker_challenge table")
    except Exception as e:
        print(f"Column challenge_type creation failed: {e}")
        pass

    try:
        op.add_column('docker_challenge', sa.Column('docker_images', sa.JSON, nullable=True))
        print("Added docker_images column to docker_challenge table")
    except Exception as e:
        print(f"Column docker_images creation failed: {e}")
        pass

    try:
        op.add_column('docker_challenge', sa.Column('primary_service', sa.String(64), nullable=True))
        print("Added primary_service column to docker_challenge table")
    except Exception as e:
        print(f"Column primary_service creation failed: {e}")
        pass

    try:
        op.add_column('docker_challenge', sa.Column('connection_type', sa.String(32), default='tcp'))
        print("Added connection_type column to docker_challenge table")
    except Exception as e:
        print(f"Column connection_type creation failed: {e}")
        pass

    try:
        op.add_column('docker_challenge', sa.Column('instance_duration', sa.Integer, default=15))
        print("Added instance_duration column to docker_challenge table")
    except Exception as e:
        print(f"Column instance_duration creation failed: {e}")
        pass

    try:
        op.add_column('docker_challenge', sa.Column('custom_subdomain', sa.String(128), nullable=True))
        print("Added custom_subdomain column to docker_challenge table")
    except Exception as e:
        print(f"Column custom_subdomain creation failed: {e}")
        pass

    # Add new columns to docker_challenge_tracker table
    try:
        op.add_column('docker_challenge_tracker', sa.Column('stack_id', sa.String(128), nullable=True, index=True))
        print("Added stack_id column to docker_challenge_tracker table")
    except Exception as e:
        print(f"Column stack_id creation failed: {e}")
        pass

    try:
        op.add_column('docker_challenge_tracker', sa.Column('service_name', sa.String(64), nullable=True))
        print("Added service_name column to docker_challenge_tracker table")
    except Exception as e:
        print(f"Column service_name creation failed: {e}")
        pass

    try:
        op.add_column('docker_challenge_tracker', sa.Column('is_primary', sa.Boolean, default=False))
        print("Added is_primary column to docker_challenge_tracker table")
    except Exception as e:
        print(f"Column is_primary creation failed: {e}")
        pass

    try:
        op.add_column('docker_challenge_tracker', sa.Column('network_name', sa.String(128), nullable=True))
        print("Added network_name column to docker_challenge_tracker table")
    except Exception as e:
        print(f"Column network_name creation failed: {e}")
        pass

    print("Multi-image support migration completed successfully")


def downgrade(op=None):
    # Remove columns from docker_challenge_tracker table
    try:
        op.drop_column('docker_challenge_tracker', 'network_name')
        print("Dropped network_name column from docker_challenge_tracker table")
    except Exception as e:
        print(f"Error dropping network_name column: {e}")

    try:
        op.drop_column('docker_challenge_tracker', 'is_primary')
        print("Dropped is_primary column from docker_challenge_tracker table")
    except Exception as e:
        print(f"Error dropping is_primary column: {e}")

    try:
        op.drop_column('docker_challenge_tracker', 'service_name')
        print("Dropped service_name column from docker_challenge_tracker table")
    except Exception as e:
        print(f"Error dropping service_name column: {e}")

    try:
        op.drop_column('docker_challenge_tracker', 'stack_id')
        print("Dropped stack_id column from docker_challenge_tracker table")
    except Exception as e:
        print(f"Error dropping stack_id column: {e}")

    # Remove columns from docker_challenge table
    try:
        op.drop_column('docker_challenge', 'custom_subdomain')
        print("Dropped custom_subdomain column from docker_challenge table")
    except Exception as e:
        print(f"Error dropping custom_subdomain column: {e}")

    try:
        op.drop_column('docker_challenge', 'instance_duration')
        print("Dropped instance_duration column from docker_challenge table")
    except Exception as e:
        print(f"Error dropping instance_duration column: {e}")

    try:
        op.drop_column('docker_challenge', 'connection_type')
        print("Dropped connection_type column from docker_challenge table")
    except Exception as e:
        print(f"Error dropping connection_type column: {e}")

    try:
        op.drop_column('docker_challenge', 'primary_service')
        print("Dropped primary_service column from docker_challenge table")
    except Exception as e:
        print(f"Error dropping primary_service column: {e}")

    try:
        op.drop_column('docker_challenge', 'docker_images')
        print("Dropped docker_images column from docker_challenge table")
    except Exception as e:
        print(f"Error dropping docker_images column: {e}")

    try:
        op.drop_column('docker_challenge', 'challenge_type')
        print("Dropped challenge_type column from docker_challenge table")
    except Exception as e:
        print(f"Error dropping challenge_type column: {e}")

    print("Multi-image support migration rollback completed")