#!/bin/bash

# Configuration
SRUN_DIR="./srun"
RESULTS_DIR="./results"

# Ensure results directory exists
mkdir -p "$RESULTS_DIR"

echo "Scanning $SRUN_DIR for LAMMPS scripts..."

# 1. grep -l "lmp": finds files containing "lmp"
# 2. sort -V: sorts them naturally (1, 2, 10 instead of 1, 10, 2)
FILES=$(ls "$SRUN_DIR")

# Check if we found anything
if [ -z "$FILES" ]; then
    echo "No scripts containing 'lmp' were found."
    exit 0
fi

for script in $FILES; do
    
    # Get the filename without the path and without the extension
    base_name=$(basename "$script" .sh)
    log_file="${RESULTS_DIR}/${base_name}.out"

    echo "============================================================"
    echo "EXECUTING: $base_name"
    echo "START:     $(date '+%Y-%m-%d %H:%M:%S')"
    echo "============================================================"

    # Execute the script and capture everything
    bash "srun/$script" 2>&1 | tee "$log_file"

    echo -e "\n============================================================"
    echo "FINISHED:  $base_name"
    echo "END:       $(date '+%Y-%m-%d %H:%M:%S')"
    echo "============================================================"
    echo ""
done

echo "All amg benchmarks complete. Results are in $RESULTS_DIR"
