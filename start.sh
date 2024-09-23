#!/bin/bash

ENV_NAME=gpt2_env
MINIFORGE_SCRIPT="Miniforge3-$(uname)-$(uname -m).sh"

# Check if conda is installed
if ! command -v conda &> /dev/null
then
    echo "Conda is not installed. Installing Miniforge..."
    # Download and install Miniforge
    if command -v curl &> /dev/null; then
        curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/${MINIFORGE_SCRIPT}"
    elif command -v wget &> /dev/null; then
        wget "https://github.com/conda-forge/miniforge/releases/latest/download/${MINIFORGE_SCRIPT}"
    else
        echo "Neither curl nor wget is installed. Please install one of them to proceed."
        exit 1
    fi

    bash $MINIFORGE_SCRIPT -b -p $HOME/miniforge3
    export PATH="$HOME/miniforge3/bin:$PATH"

    echo "Miniforge installation complete. Please log out and log back in, then re-run this script."
    exit 0
fi

# Create or activate conda environment
if conda info --envs | grep -q $ENV_NAME; then
    echo "Environment $ENV_NAME already exists. Activating it."
    conda activate $ENV_NAME
else
    echo "Creating a new environment: $ENV_NAME with Python 3.11"
    conda create --name $ENV_NAME python=3.11 -y
    conda activate $ENV_NAME
    echo "Installing dependencies from requirements.txt"
    pip install -r requirements.txt
fi

# Navigate to app directory and install dependencies
cd app

# Install dependencies
pip install -r requirements.txt

# Run the FastAPI app using Uvicorn
uvicorn fast_api:app --host 0.0.0.0 --port 8000
