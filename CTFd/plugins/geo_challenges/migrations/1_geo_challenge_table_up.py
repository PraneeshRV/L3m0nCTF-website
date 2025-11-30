"""Initial geo challenges migration

Revision ID: 1a5e83bf7e42
Revises: 
Create Date: 2024-01-07 14:30:00.000000

"""
from alembic import op
import sqlalchemy as sa

# revision identifiers
revision = '1a5e83bf7e42'
down_revision = None
branch_labels = None
depends_on = None


def upgrade(op=None):
    # Create geo_challenge table if it doesn't exist
    try:
        op.create_table(
            'geo_challenge',
            sa.Column('id', sa.Integer, sa.ForeignKey('challenges.id', ondelete='CASCADE'), primary_key=True),
            sa.Column('latitude', sa.Numeric(12, 10), default=0),
            sa.Column('longitude', sa.Numeric(13, 10), default=0),
            sa.Column('tolerance_radius', sa.Numeric(10, 2), default=10),
            # Dynamic scoring columns (optional)
            sa.Column('initial', sa.Integer, default=None),
            sa.Column('minimum', sa.Integer, default=None),
            sa.Column('decay', sa.Integer, default=None)
        )
    except Exception as e:
        print(f"Table creation error (might already exist): {str(e)}")
        
    # If table already exists, try to add the new columns
    try:
        op.add_column('geo_challenge', sa.Column('initial', sa.Integer, default=None))
        op.add_column('geo_challenge', sa.Column('minimum', sa.Integer, default=None))
        op.add_column('geo_challenge', sa.Column('decay', sa.Integer, default=None))
    except Exception as e:
        print(f"Column addition error (might already exist): {str(e)}")


def downgrade(op=None):
    bind = op.get_bind()
    url = str(bind.engine.url)

    # Drop the new columns first
    try:
        op.drop_column('geo_challenge', 'decay')
        op.drop_column('geo_challenge', 'minimum')
        op.drop_column('geo_challenge', 'initial')
    except Exception as e:
        print(f"Column drop error: {str(e)}")

    # Drop foreign key constraint first
    try:
        if url.startswith("mysql"):
            op.drop_constraint(
                'geo_challenge_ibfk_1', 'geo_challenge', type_='foreignkey'
            )
        elif url.startswith("postgres"):
            op.drop_constraint(
                'geo_challenge_id_fkey', 'geo_challenge', type_='foreignkey'
            )
    except Exception as e:
        print(f"Constraint drop error: {str(e)}")

    # Then drop the table
    try:
        op.drop_table('geo_challenge')
    except Exception as e:
        print(f"Table drop error: {str(e)}")