#!/bin/bash

# PostgreSQL Database Utility Scripts Runner
# This script executes all analysis scripts and generates reports

set -e

# Configuration
DATABASE_NAME=${1:-"postgres"}
OUTPUT_DIR="reports"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Create output directory
mkdir -p "$OUTPUT_DIR"

echo -e "${BLUE}PostgreSQL Database Utility Scripts${NC}"
echo -e "${BLUE}====================================${NC}"
echo "Database: $DATABASE_NAME"
echo "Timestamp: $TIMESTAMP"
echo "Output Directory: $OUTPUT_DIR"
echo

# Function to run a script and generate report
run_script() {
    local script_name=$1
    local description=$2
    local output_file="$OUTPUT_DIR/${script_name%.sql}_${TIMESTAMP}.txt"
    
    echo -e "${YELLOW}Running $script_name...${NC}"
    echo "Description: $description"
    
    if psql -f "$script_name" -d "$DATABASE_NAME" > "$output_file" 2>&1; then
        echo -e "${GREEN}✓ Success${NC} - Report saved to $output_file"
    else
        echo -e "${RED}✗ Failed${NC} - Check $output_file for errors"
    fi
    echo
}

# Check if database exists
if ! psql -lqt | cut -d \| -f 1 | grep -qw "$DATABASE_NAME"; then
    echo -e "${RED}Error: Database '$DATABASE_NAME' does not exist${NC}"
    exit 1
fi

# Run all scripts
echo -e "${BLUE}Starting analysis...${NC}"
echo

run_script "vacuum_analyzer.sql" "Vacuum analysis and recommendations"
run_script "performance_analyzer.sql" "Performance analysis and optimization"
run_script "replication_monitor.sql" "Replication monitoring and lag analysis"
run_script "migration_assistant.sql" "Migration assessment and planning"
run_script "compliance_checker.sql" "Data privacy compliance check"

echo -e "${GREEN}All scripts completed!${NC}"
echo "Reports are available in the '$OUTPUT_DIR' directory"
echo
echo "Usage examples:"
echo "  ./run_all_scripts.sh mydb"
echo "  ./run_all_scripts.sh production_db"
