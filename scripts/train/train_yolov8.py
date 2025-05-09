#!/usr/bin/env python3

import os
import shutil
import argparse
from ultralytics import YOLO

def train_yolov8(data_yaml, model_size='n', epochs=50, imgsz=640, batch=16):
    """
    YOLOv8 traning script using Ultralytics library.
    :param data_yaml: path to data.yaml file
    :param model_size: YOLOv3 model variant (n, s, m, l x)
    :param epochs: number of traning epochs
    :param imgsz: image size (square)
    :param batch: batch size
    """
    assert os.path.exists(data_yaml), f"data.yaml not found at: {data_yaml}"

    print(f"Training YOLOv8{model_size} with:")
    print(f"  data   = {data_yaml}")
    print(f"  epochs = {epochs}, imgsz = {imgsz}, batch = {batch}")

    model = YOLO(f'yolov8{model_size}.pt') # Use pretrained weights (n = nano, s = small, etc.)

    model.train(
        data=data_yaml,
        epochs=epochs,
        imgsz=imgsz,
        batch=batch,
        project='runs/train',
        name=f'yolov8{model_size}_accident',
        exist_ok=True
    )

    # Post-process: copy best.pt → models/yolov8{model_size}_accident.pt
    save_dir = model.trainer.save_dir  # e.g., runs/train/yolov8n_accident
    src = os.path.join(save_dir, 'weights', 'best.pt')
    dst_dir = 'models'
    os.makedirs(dst_dir, exist_ok=True)
    dst = os.path.join(dst_dir, f'yolov8{model_size}_accident.pt')
    shutil.copy2(src, dst)

    print(f"\n✅ Training completed.")
    print(f"📦 Best model copied to: {dst}")

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="CrashNet: YOLOv8 Accident Detection Training Script")
    parser.add_argument('--data', type=str, default='datasets/roboflow_accident/data.yaml', help='Path to data.yaml')
    parser.add_argument('--model', type=str, default='n', help='YOLOv8 model size: n / s / m / l / x')
    parser.add_argument('--epochs', type=int, default=50, help='Number of epochs')
    parser.add_argument('--imgsz', type=int, default=640, help='Image size')
    parser.add_argument('--batch', type=int, default=16, help='Batch size')

    args = parser.parse_args()

    train_yolov8(
        data_yaml=args.data,
        model_size=args.model,
        epochs=args.epochs,
        imgsz=args.imgsz,
        batch=args.batch
    )
