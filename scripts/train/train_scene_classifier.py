import os
import argparse
from pathlib import Path

import torch
import torch.nn as nn
from torch.utils.data import DataLoader
from torchvision import datasets, transforms, models

from tqdm import tqdm

# -------------------------------
# 1. 하이퍼파라미터 및 경로 설정
# -------------------------------
parser = argparse.ArgumentParser(description="Train scene classifier")
parser.add_argument('--train_dir', type=str, default='datasets/sceneaware_small/train')
parser.add_argument('--val_dir', type=str, default='datasets/sceneaware_small/val')
parser.add_argument('--epochs', type=int, default=10)
parser.add_argument('--batch_size', type=int, default=16)
parser.add_argument('--lr', type=float, default=1e-4)
parser.add_argument('--num_workers', type=int, default=4)
parser.add_argument('--output', type=str, default='scene_classifier.pt')
args = parser.parse_args()


