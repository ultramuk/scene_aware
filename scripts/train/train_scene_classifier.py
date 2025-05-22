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

# -------------------------------
# 2. 데이터 전처리 및 로딩
# -------------------------------

# transforms: 이미지 resize, tensor 변환, normalize 수행
transform_train = transforms.Compose([
    transforms.Resize((224, 224)),
    transforms.RandomHorizontalFlip(),
    transforms.ColorJitter(brightness=0.2, contrast=0.2),
    transforms.ToTensor(),
    transforms.Normalize([0.485, 0.456, 0.406],     # ImageNet 평균값
                         [0.229, 0.224, 0.225])     # ImageNet 표준편차
])

transform_val = transforms.Compose([
    transforms.Resize((224, 224)),
    transforms.ToTensor(),
    transforms.Normalize([0.485, 0.456, 0.406],
                         [0.229, 0.224, 0.225])
])

# ImageFolder: 폴더명 기준으로 자동 클래스 인식
train_dataset = datasets.ImageFolder(args.train_dir, transform=transform_train)
val_dataset = datasets.ImageFolder(args.val_dir, transform=transform_val)

train_loader = DataLoader(train_dataset, batch_size=args.batch_size,
                          shuffle=True, num_workers=args.num_workers)
val_loader = DataLoader(val_dataset, batch_size=args.batch_size,
                        shuffle=False, num_workers=args.num_workser)

# 클래스 수 자동 추출
num_classes = len(train_dataset.classes)
print(f"Detected {num_classes} classes: {train_dataset.classes}")
