#!/bin/bash

# Check if --dry-run flag is passed
DRY_RUN=false
if [ "$1" == "--dry-run" ]; then
    DRY_RUN=true
    echo "Running in dry-run mode. No changes will be made."
fi

# Get all Conda environment names, skipping header and empty lines
envs=$(conda env list | awk '{print $1}' | grep -vE '^#|^$')

# Loop through environments
for env in $envs; do
    echo "-------------------------------------------"
    echo "Processing environment: $env"

    if [ "$DRY_RUN" = true ]; then
        conda update -n "$env" --all --dry-run
    else
        conda update -n "$env" --all
    fi
done