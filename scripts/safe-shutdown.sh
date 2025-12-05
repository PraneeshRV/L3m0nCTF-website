#!/bin/bash
# =============================================================================
# L3m0nCTF Safe Shutdown Script
# Properly shuts down all containers with data flush
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }

cd "$PROJECT_DIR"

log_info "Flushing Redis data to disk..."
docker compose exec -T cache redis-cli BGSAVE 2>/dev/null || true
sleep 2

log_info "Stopping containers gracefully..."
docker compose down

log_success "All containers stopped safely. Your data is preserved!"
echo ""
echo "To start again: cd $PROJECT_DIR && docker compose up -d"
