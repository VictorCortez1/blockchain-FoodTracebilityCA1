#!/usr/bin/env bash

# Stop if an error occurs
set -e

# Navigate to the project directory
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_DIR"

echo "Starting Food Traceability project..."

# Activate the Python virtual environment
if [ -f "venv/Scripts/activate" ]; then
    source "venv/Scripts/activate"
elif [ -f "venv/bin/activate" ]; then
    source "venv/bin/activate"
else
    echo "Error: Python virtual environment not found."
    exit 1
fi

# Check required packages
echo "Checking project dependencies..."

if ! python -c "import notebook, web3" 2>/dev/null; then
    echo "Required packages are missing."
    echo "Please install notebook and web3."
    exit 1
fi

echo "Environment ready!"
echo "Launching Jupyter Notebook..."

# Start Jupyter Notebook
python -m notebook