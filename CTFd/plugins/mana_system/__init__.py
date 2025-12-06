"""
Mana System Plugin for CTFd
===========================

A toggleable resource management system for Docker challenges.
Limits the number of concurrent container instances per team/user.

IMPORTANT: Mana is CALCULATED from active containers, not stored.
This prevents desync bugs when containers disappear unexpectedly.

Based on ctfer.io challenge-manager mana system concept.
"""

import logging
from datetime import datetime
from flask import Blueprint, render_template, request, jsonify, current_app, redirect, url_for
from flask_restx import Namespace, Resource
from CTFd.models import db, Teams, Users
from CTFd.utils.decorators import admins_only, authed_only
from CTFd.utils.config import is_teams_mode
from CTFd.utils.user import get_current_team, get_current_user
from CTFd.plugins import register_plugin_assets_directory, register_admin_plugin_menu_bar, register_user_page_menu_bar, bypass_csrf_protection


# =============================================================================
# Models
# =============================================================================

class ManaSettings(db.Model):
    """
    Mana system settings stored in database.
    Controls whether mana system is enabled and default values.
    """
    __tablename__ = 'mana_settings'
    
    id = db.Column(db.Integer, primary_key=True)
    key = db.Column(db.String(64), unique=True, nullable=False, index=True)
    value = db.Column(db.String(256), nullable=True)
    
    @staticmethod
    def get(key, default=None):
        """Get a setting value by key."""
        try:
            setting = ManaSettings.query.filter_by(key=key).first()
            if setting:
                return setting.value
        except Exception:
            pass
        return default
    
    @staticmethod
    def set(key, value):
        """Set a setting value."""
        setting = ManaSettings.query.filter_by(key=key).first()
        if setting:
            setting.value = str(value)
        else:
            setting = ManaSettings(key=key, value=str(value))
            db.session.add(setting)
        db.session.commit()


class SourceMana(db.Model):
    """
    Max mana configuration per source (team/user).
    NOTE: current_mana is NOT stored here - it's calculated from active containers.
    """
    __tablename__ = 'source_mana'
    
    id = db.Column(db.Integer, primary_key=True)
    team_id = db.Column(db.Integer, unique=True, nullable=True, index=True)
    user_id = db.Column(db.Integer, unique=True, nullable=True, index=True)
    max_mana = db.Column(db.Integer, default=100)
    
    @staticmethod
    def get_or_create(team_id=None, user_id=None):
        """Get existing max mana record or create new one with default."""
        default_max = get_default_mana()
        
        if team_id:
            record = SourceMana.query.filter_by(team_id=team_id).first()
            if not record:
                record = SourceMana(team_id=team_id, max_mana=default_max)
                db.session.add(record)
                db.session.commit()
            return record
        elif user_id:
            record = SourceMana.query.filter_by(user_id=user_id).first()
            if not record:
                record = SourceMana(user_id=user_id, max_mana=default_max)
                db.session.add(record)
                db.session.commit()
            return record
        return None


# Keep TeamMana as an alias for backwards compatibility
TeamMana = SourceMana


# =============================================================================
# Utility Functions (exported for docker_challenges plugin)
# =============================================================================

def is_mana_enabled():
    """Check if mana system is enabled."""
    try:
        enabled = ManaSettings.get('enabled', 'true')
        return enabled.lower() in ('true', '1', 'yes', 'on')
    except Exception:
        return True


def get_default_mana():
    """Get default max mana value for new teams/users."""
    try:
        return int(ManaSettings.get('default_mana', 100))
    except (ValueError, TypeError):
        return 100


def get_default_mana_cost():
    """Get default mana cost per challenge."""
    try:
        return int(ManaSettings.get('default_cost', 25))
    except (ValueError, TypeError):
        return 25


def _get_docker_tracker_model():
    """Lazy import DockerChallengeTracker to avoid circular imports."""
    try:
        from CTFd.plugins.docker_challenges import DockerChallengeTracker
        return DockerChallengeTracker
    except ImportError:
        return None


def calculate_mana_used(team_id=None, user_id=None):
    """
    Calculate mana used from active Docker containers.
    This is the core function that prevents mana desync.
    """
    DockerChallengeTracker = _get_docker_tracker_model()
    if not DockerChallengeTracker:
        return 0
    
    try:
        query = DockerChallengeTracker.query
        if team_id:
            query = query.filter_by(team_id=str(team_id))
        elif user_id:
            query = query.filter_by(user_id=str(user_id))
        else:
            return 0
        
        containers = query.all()
        total_mana = sum(c.mana_cost or 0 for c in containers)
        return total_mana
    except Exception as e:
        current_app.logger.error(f"Error calculating mana used: {str(e)}")
        return 0


def get_active_instances(team_id=None, user_id=None):
    """Get all active container instances for a team/user."""
    DockerChallengeTracker = _get_docker_tracker_model()
    if not DockerChallengeTracker:
        return []
    
    try:
        query = DockerChallengeTracker.query
        if team_id:
            query = query.filter_by(team_id=str(team_id))
        elif user_id:
            query = query.filter_by(user_id=str(user_id))
        else:
            return []
        
        return query.all()
    except Exception as e:
        current_app.logger.error(f"Error getting active instances: {str(e)}")
        return []


def get_mana_for_session():
    """Get mana info for current session (team or user)."""
    if not is_mana_enabled():
        return None
    
    try:
        if is_teams_mode():
            team = get_current_team()
            if team:
                return SourceMana.get_or_create(team_id=team.id)
        else:
            user = get_current_user()
            if user:
                return SourceMana.get_or_create(user_id=user.id)
    except Exception as e:
        current_app.logger.error(f"Error getting mana for session: {str(e)}")
    return None


def get_session_mana_info():
    """Get complete mana info for current session."""
    if not is_mana_enabled():
        return {'enabled': False, 'current': 0, 'max': 0, 'used': 0}
    
    try:
        if is_teams_mode():
            team = get_current_team()
            if team:
                mana_record = SourceMana.get_or_create(team_id=team.id)
                mana_used = calculate_mana_used(team_id=team.id)
                mana_remaining = max(0, mana_record.max_mana - mana_used)
                return {
                    'enabled': True,
                    'current': mana_remaining,
                    'max': mana_record.max_mana,
                    'used': mana_used
                }
        else:
            user = get_current_user()
            if user:
                mana_record = SourceMana.get_or_create(user_id=user.id)
                mana_used = calculate_mana_used(user_id=user.id)
                mana_remaining = max(0, mana_record.max_mana - mana_used)
                return {
                    'enabled': True,
                    'current': mana_remaining,
                    'max': mana_record.max_mana,
                    'used': mana_used
                }
    except Exception as e:
        current_app.logger.error(f"Error getting session mana info: {str(e)}")
    
    default_mana = get_default_mana()
    return {'enabled': True, 'current': default_mana, 'max': default_mana, 'used': 0}


def check_mana(cost):
    """
    Check if current session can afford the mana cost.
    Returns (can_afford, mana_info, error_message)
    """
    if not is_mana_enabled():
        return True, None, None
    
    mana_info = get_session_mana_info()
    if not mana_info['enabled']:
        return True, mana_info, None
    
    if mana_info['current'] < cost:
        return False, mana_info, f"Insufficient mana! You need {cost} mana but only have {mana_info['current']}/{mana_info['max']}. Stop an existing instance to reclaim mana."
    
    return True, mana_info, None


# Legacy functions for backwards compatibility (now no-ops since mana is calculated)
def deduct_mana(cost, mana_record=None):
    """Legacy: No-op since mana is now calculated from containers."""
    return True

def refund_mana(cost, mana_record=None):
    """Legacy: No-op since mana is now calculated from containers."""
    pass


def get_mana_info():
    """Get mana info for API responses."""
    return get_session_mana_info()


# =============================================================================
# Admin Blueprint
# =============================================================================

def define_mana_admin(app):
    admin_mana = Blueprint('admin_mana', __name__, template_folder='templates', static_folder='assets')
    
    @admin_mana.route("/admin/mana_settings", methods=["GET", "POST"])
    @admins_only
    @bypass_csrf_protection
    def mana_settings():
        """Admin page for mana system settings."""
        if request.method == "POST":
            try:
                # Get form data
                enabled = request.form.get('enabled', 'off') == 'on'
                default_mana = int(request.form.get('default_mana', 100))
                default_cost = int(request.form.get('default_cost', 25))
                
                # Save settings
                ManaSettings.set('enabled', 'true' if enabled else 'false')
                ManaSettings.set('default_mana', str(default_mana))
                ManaSettings.set('default_cost', str(default_cost))
                
                # Handle reset all max mana if requested
                if request.form.get('reset_all') == 'true':
                    SourceMana.query.update({SourceMana.max_mana: default_mana})
                    db.session.commit()
                
                return jsonify({'success': True, 'message': 'Settings saved successfully'})
            except Exception as e:
                current_app.logger.error(f"Error saving mana settings: {str(e)}")
                return jsonify({'success': False, 'message': str(e)}), 500
        
        # GET request - render settings page
        settings = {
            'enabled': ManaSettings.get('enabled', 'true').lower() in ('true', '1', 'yes', 'on'),
            'default_mana': int(ManaSettings.get('default_mana', 100) or 100),
            'default_cost': int(ManaSettings.get('default_cost', 25) or 25)
        }
        
        # Get stats - calculate from active containers
        DockerChallengeTracker = _get_docker_tracker_model()
        total_sources = SourceMana.query.count()
        total_active_instances = 0
        total_mana_used = 0
        
        if DockerChallengeTracker:
            total_active_instances = DockerChallengeTracker.query.count()
            try:
                all_containers = DockerChallengeTracker.query.all()
                total_mana_used = sum(c.mana_cost or 0 for c in all_containers)
            except Exception:
                pass
        
        return render_template("mana_settings.html", 
                             settings=settings, 
                             total_sources=total_sources,
                             total_active_instances=total_active_instances,
                             total_mana_used=total_mana_used)
    
    @admin_mana.route("/admin/mana_sources", methods=["GET"])
    @admins_only
    def mana_sources():
        """Admin page showing all sources and their mana usage."""
        DockerChallengeTracker = _get_docker_tracker_model()
        sources = []
        
        if DockerChallengeTracker:
            # Get unique sources from active containers
            all_containers = DockerChallengeTracker.query.all()
            source_data = {}
            
            for container in all_containers:
                source_key = container.team_id or container.user_id
                if source_key not in source_data:
                    source_data[source_key] = {
                        'source_id': source_key,
                        'is_team': bool(container.team_id),
                        'instances': [],
                        'mana_used': 0
                    }
                source_data[source_key]['instances'].append(container)
                source_data[source_key]['mana_used'] += container.mana_cost or 0
            
            # Enrich with team/user names and max mana
            for source_key, data in source_data.items():
                if data['is_team'] and is_teams_mode():
                    team = Teams.query.get(int(source_key))
                    data['name'] = team.name if team else f"Team {source_key}"
                    mana_record = SourceMana.query.filter_by(team_id=int(source_key)).first()
                else:
                    user = Users.query.get(int(source_key))
                    data['name'] = user.name if user else f"User {source_key}"
                    mana_record = SourceMana.query.filter_by(user_id=int(source_key)).first()
                
                data['max_mana'] = mana_record.max_mana if mana_record else get_default_mana()
                data['mana_remaining'] = max(0, data['max_mana'] - data['mana_used'])
                data['instance_count'] = len(data['instances'])
                sources.append(data)
        
        return render_template("mana_sources.html", sources=sources, is_teams_mode=is_teams_mode())
    
    app.register_blueprint(admin_mana)


# =============================================================================
# User Instances Page
# =============================================================================

def define_instances_page(app):
    instances_bp = Blueprint('user_instances', __name__, template_folder='templates', static_folder='assets')
    
    @instances_bp.route("/instances", methods=["GET"])
    @authed_only
    def instances_page():
        """User-facing page showing all active instances and mana status."""
        # Handle team mode without team
        if is_teams_mode():
            team = get_current_team()
            if not team:
                return redirect(url_for('teams.private', next=request.full_path))
        
        # Get mana info
        mana_info = get_session_mana_info()
        
        # Get active instances
        instances = []
        DockerChallengeTracker = _get_docker_tracker_model()
        
        if DockerChallengeTracker:
            if is_teams_mode():
                team = get_current_team()
                if team:
                    raw_instances = get_active_instances(team_id=team.id)
            else:
                user = get_current_user()
                if user:
                    raw_instances = get_active_instances(user_id=user.id)
                else:
                    raw_instances = []
            
            # Enrich instance data with challenge info
            from CTFd.models import Challenges
            
            for container in raw_instances:
                # Get challenge info
                challenge_name = container.challenge or "Unknown"
                challenge_category = "Unknown"
                
                # Try to find the challenge record
                try:
                    from CTFd.plugins.docker_challenges import DockerChallenge
                    chall = DockerChallenge.query.filter_by(name=container.challenge).first()
                    if chall:
                        challenge_category = chall.category or "Unknown"
                except Exception:
                    pass
                
                # Calculate time remaining if there's a revert_time
                time_remaining = None
                if container.revert_time:
                    remaining_seconds = container.revert_time - int(datetime.utcnow().timestamp())
                    if remaining_seconds > 0:
                        mins, secs = divmod(remaining_seconds, 60)
                        time_remaining = f"{mins}m {secs}s"
                    else:
                        time_remaining = "Expired"
                
                # Build connection info
                connection_info = ""
                if container.host and container.ports:
                    # Check if there's a domain configured
                    if container.docker_config and container.docker_config.domain:
                        domain = container.docker_config.domain
                        # For domain, use port mapping
                        connection_info = f"{domain}:{container.ports.split(':')[-1] if ':' in container.ports else container.ports}"
                    else:
                        connection_info = f"{container.host}:{container.ports}"
                
                instances.append({
                    'id': container.id,
                    'instance_id': container.instance_id,
                    'challenge_name': challenge_name,
                    'challenge_category': challenge_category,
                    'docker_image': container.docker_image,
                    'connection_info': connection_info,
                    'mana_cost': container.mana_cost or 0,
                    'time_remaining': time_remaining,
                    'created_at': datetime.fromtimestamp(container.timestamp) if container.timestamp else None,
                    'stack_id': container.stack_id,
                    'is_primary': container.is_primary
                })
        
        # Group by stack_id for multi-image challenges
        stacks = {}
        single_instances = []
        
        for instance in instances:
            if instance['stack_id']:
                if instance['stack_id'] not in stacks:
                    stacks[instance['stack_id']] = {
                        'instances': [],
                        'primary': None
                    }
                stacks[instance['stack_id']]['instances'].append(instance)
                if instance['is_primary']:
                    stacks[instance['stack_id']]['primary'] = instance
            else:
                single_instances.append(instance)
        
        # Create display list
        display_instances = []
        
        for stack_id, stack_data in stacks.items():
            primary = stack_data['primary'] or stack_data['instances'][0]
            primary['is_stack'] = True
            primary['stack_count'] = len(stack_data['instances'])
            primary['total_mana_cost'] = sum(i['mana_cost'] for i in stack_data['instances'])
            display_instances.append(primary)
        
        for instance in single_instances:
            instance['is_stack'] = False
            instance['stack_count'] = 1
            instance['total_mana_cost'] = instance['mana_cost']
            display_instances.append(instance)
        
        return render_template("instances.html",
                             mana_info=mana_info,
                             instances=display_instances,
                             default_cost=get_default_mana_cost())
    
    app.register_blueprint(instances_bp)


# =============================================================================
# API Namespace
# =============================================================================

mana_namespace = Namespace("mana", description='Mana system API endpoints')


@mana_namespace.route("", methods=['GET'])
class ManaAPI(Resource):
    """Get current mana status for authenticated user/team."""
    
    @authed_only
    def get(self):
        return get_mana_info()


@mana_namespace.route("/status", methods=['GET'])
class ManaStatusAPI(Resource):
    """Get mana system status (enabled/disabled)."""
    
    def get(self):
        return {
            'enabled': is_mana_enabled(),
            'default_cost': get_default_mana_cost() if is_mana_enabled() else 0
        }


@mana_namespace.route("/instances", methods=['GET'])
class ManaInstancesAPI(Resource):
    """Get active instances for current user/team."""
    
    @authed_only
    def get(self):
        mana_info = get_session_mana_info()
        
        instances = []
        if is_teams_mode():
            team = get_current_team()
            if team:
                containers = get_active_instances(team_id=team.id)
                for c in containers:
                    instances.append({
                        'instance_id': c.instance_id,
                        'challenge': c.challenge,
                        'mana_cost': c.mana_cost or 0,
                        'connection': f"{c.host}:{c.ports}" if c.host and c.ports else None
                    })
        else:
            user = get_current_user()
            if user:
                containers = get_active_instances(user_id=user.id)
                for c in containers:
                    instances.append({
                        'instance_id': c.instance_id,
                        'challenge': c.challenge,
                        'mana_cost': c.mana_cost or 0,
                        'connection': f"{c.host}:{c.ports}" if c.host and c.ports else None
                    })
        
        return {
            'mana': mana_info,
            'instances': instances
        }


# =============================================================================
# Plugin Load
# =============================================================================

def load(app):
    """Load the mana system plugin."""
    # Create tables if they don't exist
    try:
        app.db.create_all()
        current_app.logger.info("Mana system tables created/verified successfully")
    except Exception as e:
        current_app.logger.error(f"Error creating mana system tables: {str(e)}")
    
    # Initialize default settings if not exist
    try:
        if ManaSettings.get('enabled') is None:
            ManaSettings.set('enabled', 'true')
        if ManaSettings.get('default_mana') is None:
            ManaSettings.set('default_mana', '100')
        if ManaSettings.get('default_cost') is None:
            ManaSettings.set('default_cost', '25')
    except Exception as e:
        current_app.logger.error(f"Error initializing mana settings: {str(e)}")
    
    # Register admin pages
    define_mana_admin(app)
    
    # Register user instances page
    define_instances_page(app)
    
    # Register API
    from CTFd.api import CTFd_API_v1
    CTFd_API_v1.add_namespace(mana_namespace, '/mana')
    
    # Register assets
    register_plugin_assets_directory(app, base_path='/plugins/mana_system/assets')
    
    # Register menu items
    register_admin_plugin_menu_bar(title='🍋 Juice Settings', route='/admin/mana_settings')
    register_user_page_menu_bar(title='🧃 Instances', route='/instances')
    
    current_app.logger.info("Mana system plugin loaded successfully (calculate-on-demand mode)")
