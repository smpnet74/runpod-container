#!/bin/bash
# Setup script for qwen3-vllm local environment

# Create the Conda environment
echo "Creating Conda environment 'qwen3-vllm'..."
conda env create -f environment.yml

# Activate the environment
echo "To activate the environment, run:"
echo "conda activate qwen3-vllm"

echo "Then to run the server:"
echo "python qwen3_vllm_local.py"
