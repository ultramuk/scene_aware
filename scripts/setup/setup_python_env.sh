#!/bin/bash

set -e

python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
pip install ultralytics opencv-python

# CUDA 11.4 (안정적)
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu114
# CPU-only (GPU 없이)
#pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu

pip install onnx

# pip freeze > requirements.txt
