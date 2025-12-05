#!/bin/bash
# =============================================================================
# L3m0nCTF Automated Backup Script
# Creates timestamped backups of MySQL database, Redis data, and uploads
# Automatically rotates old backups (keeps last 7 by default)
# =============================================================================

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
BACKUP_DIR="${PROJECT_DIR}/backups"
DATA_DIR="${PROJECT_DIR}/.data"
MAX_BACKUPS=7  # Number of backups to keep
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_NAME="l3monctf_backup_${TIMESTAMP}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Create backup directory if it doesn't exist
mkdir -p "${BACKUP_DIR}"

log_info "Starting L3m0nCTF backup..."
log_info "Backup name: ${BACKUP_NAME}"

# Create temporary directory for this backup
TEMP_BACKUP_DIR="${BACKUP_DIR}/${BACKUP_NAME}"
mkdir -p "${TEMP_BACKUP_DIR}"

# -----------------------------------------------------------------------------
# 1. Backup MySQL Database
# -----------------------------------------------------------------------------
log_info "Backing up MySQL database..."

# Check if the db container is running
if docker compose -f "${PROJECT_DIR}/docker-compose.yml" ps db | grep -q "Up"; then
    docker compose -f "${PROJECT_DIR}/docker-compose.yml" exec -T db \
        mysqldump -u ctfd -pctfd --single-transaction --routines --triggers ctfd \
        > "${TEMP_BACKUP_DIR}/mysql_dump.sql" 2>/dev/null
    
    if [ -s "${TEMP_BACKUP_DIR}/mysql_dump.sql" ]; then
        log_success "MySQL backup completed ($(du -h "${TEMP_BACKUP_DIR}/mysql_dump.sql" | cut -f1))"
    else
        log_warning "MySQL dump is empty, copying raw data files instead..."
        cp -r "${DATA_DIR}/mysql" "${TEMP_BACKUP_DIR}/mysql_data" 2>/dev/null || true
    fi
else
    log_warning "MySQL container not running, backing up raw data files..."
    if [ -d "${DATA_DIR}/mysql" ]; then
        cp -r "${DATA_DIR}/mysql" "${TEMP_BACKUP_DIR}/mysql_data"
        log_success "MySQL data files copied"
    else
        log_error "No MySQL data found!"
    fi
fi

# -----------------------------------------------------------------------------
# 2. Backup Redis Data
# -----------------------------------------------------------------------------
log_info "Backing up Redis data..."

# Trigger Redis BGSAVE before backup
if docker compose -f "${PROJECT_DIR}/docker-compose.yml" ps cache | grep -q "Up"; then
    docker compose -f "${PROJECT_DIR}/docker-compose.yml" exec -T cache redis-cli BGSAVE > /dev/null 2>&1 || true
    sleep 2  # Wait for BGSAVE to complete
fi

if [ -d "${DATA_DIR}/redis" ]; then
    cp -r "${DATA_DIR}/redis" "${TEMP_BACKUP_DIR}/redis_data"
    log_success "Redis backup completed"
else
    log_warning "No Redis data directory found"
fi

# -----------------------------------------------------------------------------
# 3. Backup Uploads
# -----------------------------------------------------------------------------
log_info "Backing up uploads..."

if [ -d "${DATA_DIR}/CTFd/uploads" ]; then
    cp -r "${DATA_DIR}/CTFd/uploads" "${TEMP_BACKUP_DIR}/uploads"
    log_success "Uploads backup completed"
else
    log_warning "No uploads directory found"
fi

# -----------------------------------------------------------------------------
# 4. Backup CTFd Logs
# -----------------------------------------------------------------------------
log_info "Backing up logs..."

if [ -d "${DATA_DIR}/CTFd/logs" ]; then
    cp -r "${DATA_DIR}/CTFd/logs" "${TEMP_BACKUP_DIR}/logs"
    log_success "Logs backup completed"
else
    log_warning "No logs directory found"
fi

# -----------------------------------------------------------------------------
# 5. Create compressed archive
# -----------------------------------------------------------------------------
log_info "Creating compressed archive..."

cd "${BACKUP_DIR}"
tar -czf "${BACKUP_NAME}.tar.gz" "${BACKUP_NAME}"
rm -rf "${TEMP_BACKUP_DIR}"

FINAL_SIZE=$(du -h "${BACKUP_DIR}/${BACKUP_NAME}.tar.gz" | cut -f1)
log_success "Backup archive created: ${BACKUP_NAME}.tar.gz (${FINAL_SIZE})"

# -----------------------------------------------------------------------------
# 6. Rotate old backups (keep only MAX_BACKUPS)
# -----------------------------------------------------------------------------
log_info "Rotating old backups (keeping last ${MAX_BACKUPS})..."

BACKUP_COUNT=$(ls -1 "${BACKUP_DIR}"/*.tar.gz 2>/dev/null | wc -l)

if [ "$BACKUP_COUNT" -gt "$MAX_BACKUPS" ]; then
    BACKUPS_TO_DELETE=$((BACKUP_COUNT - MAX_BACKUPS))
    ls -1t "${BACKUP_DIR}"/*.tar.gz | tail -n "$BACKUPS_TO_DELETE" | while read -r old_backup; do
        log_info "Deleting old backup: $(basename "$old_backup")"
        rm -f "$old_backup"
    done
    log_success "Deleted ${BACKUPS_TO_DELETE} old backup(s)"
else
    log_info "No old backups to delete (${BACKUP_COUNT}/${MAX_BACKUPS})"
fi

# -----------------------------------------------------------------------------
# Summary
# -----------------------------------------------------------------------------
echo ""
echo "=============================================="
log_success "Backup completed successfully!"
echo "=============================================="
echo "  Location: ${BACKUP_DIR}/${BACKUP_NAME}.tar.gz"
echo "  Size: ${FINAL_SIZE}"
echo "  Backups retained: $(ls -1 "${BACKUP_DIR}"/*.tar.gz 2>/dev/null | wc -l)/${MAX_BACKUPS}"
echo "=============================================="
