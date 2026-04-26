#!/bin/bash

SRUN_DIR="./srun"
CSV_FILE="validation_results.csv"

# Check if directory exists
if [ ! -d "$SRUN_DIR" ]; then
    echo "Error: Directory $SRUN_DIR not found."
    exit 1
fi

# Initialize CSV file with headers
echo "ID,Result,Reason" > "$CSV_FILE"

echo -e "ID \t\t\t\t RESULT \t REASON/DETAILS"
echo "--------------------------------------------------------------------------------"

# Find scripts
FILES=$(ls "$SRUN_DIR")

for script in $FILES; do
    # Get identifier (e.g., flux-to-slurm-command-18)
    identifier=$(basename "$script" .sh)
    
    # Extract the srun command line(s)
    # Using the path relative to the script's execution point
    raw_cmd=$(sed -e ':a' -e 'N' -e '$!ba' -e 's/\\\n//g' "$SRUN_DIR/$script" | grep "srun")

    if [ -z "$raw_cmd" ]; then
        result="SKIPPED"
        reason="No srun command found in script"
        printf "%-40s \033[33m%s\033[0m \t %s\n" "$identifier" "$result" "$reason"
        echo "$identifier,$result,\"$reason\"" >> "$CSV_FILE"
        continue
    fi

    # Inject --test-only into the command
    test_cmd=$(echo "$raw_cmd" | sed 's/srun/srun --test-only/')

    # Execute the test and capture output
    output=$(eval "$test_cmd" 2>&1)
    exit_code=$?

    if [ $exit_code -eq 0 ]; then
        result="VALID"
        # Strip internal quotes from output to keep CSV clean
        reason=$(echo "$output" | tr -d '"')
        printf "%-40s \033[32m%s\033[0m \t %s\n" "$identifier" "$result" "$reason"
    else
        result="INVALID"
        # Clean up the output: remove prefix and strip quotes
        reason=$(echo "$output" | sed 's/srun: error: //g' | tr -d '"')
        printf "%-40s \033[31m%s\033[0m \t %s\n" "$identifier" "$result" "$reason"
    fi

    # Append row to CSV
    echo "$identifier,$result,\"$reason\"" >> "$CSV_FILE"
done

echo "--------------------------------------------------------------------------------"
echo "Done. Results saved to: $CSV_FILE"