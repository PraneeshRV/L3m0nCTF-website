#!/bin/bash
# =============================================================================
# L3m0nCTF Restore Script
# Restores from a backup archive
# =============================================================================

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
BACKUP_DIR="${PROJECT_DIR}/backups"
DATA_DIR="${PROJECT_DIR}/.data"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Check if backup file is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <backup_file.tar.gz>"
    echo ""
    echo "Available backups:"
    ls -lh "${BACKUP_DIR}"/*.tar.gz 2>/dev/null || echo "  No backups found in ${BACKUP_DIR}"
    exit 1
fi

BACKUP_FILE="$1"

# If just filename provided, look in backup directory
if [ ! -f "$BACKUP_FILE" ]; then
    BACKUP_FILE="${BACKUP_DIR}/$1"
fi

if [ ! -f "$BACKUP_FILE" ]; then
    log_error "Backup file not found: $1"
    exit 1
fi

log_warning "This will OVERWRITE your current data!"
echo -n "Are you sure you want to restore from $(basename "$BACKUP_FILE")? [y/N] "
read -r confirm

if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
    log_info "Restore cancelled"
    exit 0
fi

# Stop containers
log_info "Stopping containers..."
docker compose -f "${PROJECT_DIR}/docker-compose.yml" down

# Extract backup
log_info "Extracting backup..."
TEMP_DIR=$(mktemp -d)
tar -xzf "$BACKUP_FILE" -C "$TEMP_DIR"
BACKUP_NAME=$(ls "$TEMP_DIR")

# Restore MySQL
if [ -f "${TEMP_DIR}/${BACKUP_NAME}/mysql_dump.sql" ]; then
    log_info "Restoring MySQL from SQL dump..."
    
    # Start only the database container
    docker compose -f "${PROJECT_DIR}/docker-compose.yml" up -d db
    sleep 10  # Wait for DB to be ready
    
    docker compose -f "${PROJECT_DIR}/docker-compose.yml" exec -T db \
        mysql -u ctfd -pctfd ctfd < "${TEMP_DIR}/${BACKUP_NAME}/mysql_dump.sql"
    
    log_success "MySQL restored from SQL dump"
elif [ -d "${TEMP_DIR}/${BACKUP_NAME}/mysql_data" ]; then
    log_info "Restoring MySQL from data files..."
    rm -rf "${DATA_DIR}/mysql"
    cp -r "${TEMP_DIR}/${BACKUP_NAME}/mysql_data" "${DATA_DIR}/mysql"
    log_success "MySQL data files restored"
fi

# Restore Redis
if [ -d "${TEMP_DIR}/${BACKUP_NAME}/redis_data" ]; then
    log_info "Restoring Redis data..."
    rm -rf "${DATA_DIR}/redis"
    cp -r "${TEMP_DIR}/${BACKUP_NAME}/redis_data" "${DATA_DIR}/redis"
    log_success "Redis restored"
fi

# Restore Uploads
if [ -d "${TEMP_DIR}/${BACKUP_NAME}/uploads" ]; then
    log_info "Restoring uploads..."
    rm -rf "${DATA_DIR}/CTFd/uploads"
    mkdir -p "${DATA_DIR}/CTFd"
    cp -r "${TEMP_DIR}/${BACKUP_NAME}/uploads" "${DATA_DIR}/CTFd/uploads"
    log_success "Uploads restored"
fi

# Cleanup
rm -rf "$TEMP_DIR"

# Start all containers
log_info "Starting containers..."
docker compose -f "${PROJECT_DIR}/docker-compose.yml" up -d

echo ""
log_success "Restore completed! Containers are starting..."
echo "Run 'docker compose logs -f' to monitor startup"
