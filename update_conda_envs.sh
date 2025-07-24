#!/bin/bash

# Default flags
DRY_RUN=false
AUTO_Y=false

# Parse arguments
for arg in "$@"; do
    case $arg in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        -y)
            AUTO_Y=true
            shift
            ;;
        *)
            echo "Unknown option: $arg"
            echo "Usage: $0 [--dry-run] [-y]"
            exit 1
            ;;
    esac
done

# Build conda update command options
UPDATE_OPTIONS="--all"
if [ "$DRY_RUN" = true ]; then
    UPDATE_OPTIONS="$UPDATE_OPTIONS --dry-run"
fi
if [ "$AUTO_Y" = true ]; then
    UPDATE_OPTIONS="$UPDATE_OPTIONS -y"
fi

# Get environment names (exclude headers/empty lines)
envs=$(conda env list | awk '{print $1}' | grep -vE '^#|^$')

# Update each environment
for env in $envs; do
    echo "-------------------------------------------"
    echo "Updating environment: $env"
    
    # Determine environment location
    ENV_PATH=$(conda env list | awk -v env="$env" '$1 == env {print $NF}')
    PINNED_FILE="$ENV_PATH/conda-meta/pinned"

    # Check for pinned packages
    if [ -f "$PINNED_FILE" ]; then
        echo "WARNING: Environment '$env' has pinned packages:"
        cat "$PINNED_FILE"
        echo ""
    fi

    # Run the update
    conda update -n "$env" $UPDATE_OPTIONS
done