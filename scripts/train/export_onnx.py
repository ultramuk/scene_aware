#!/usr/bin/env python3

import os
import shutil
import argparse
from ultralytics import YOLO

def export_to_onnx(pt_path, output_dir='exports', imgsz=640, dynamic=True):
    """
    Export YOLOv8 model from .pt to .onnx
    :param pt_path: Path to .pt model
    :param output_dir: Directory to save .onnx
    :param imgsz: Input image size (square)
    :param dynamic: Whether to export with dynamic axes
    """
    assert os.path.exists(pt_path), f"Model not found at: {pt_path}"
    os.makedirs(output_dir, exist_ok=True)

    print(f"Exporting {pt_path} -> ONNX (imgs={imgsz}, dynamic={dynamic})")

    model = YOLO(pt_path)

    # Export to ONNX
    onnx_path = model.export(
        format='onnx',
        imgsz=imgsz,
        dynamic=dynamic,
        simplify=True,
        opset=12 # Recommended for compatibility
    )

    # Move exported ONNX to output_dir
    onnx_filename = os.path.basename(onnx_path)
    dst_path = os.path.join(output_dir, onnx_filename)
    shutil.move(onnx_path, dst_path)

    print(f"Export complete! ONNX model saved to:\n  {dst_path}")

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="CrashNet: Export YOLOv8 model to ONNX format")
    parser.add_argument('--pt', type=str, required=True, help='Path to YOLOv8 .pt file')
    parser.add_argument('--imgsz', type=int, default=640, help='Input image size')
    parser.add_argument('--output', type=str, default='exports', help='Output directory')
    parser.add_argument('--static', action='store_true', help='Export with static input shape (default: dynamic)')

    args = parser.parse_args()

    export_to_onnx(
        pt_path=args.pt,
        output_dir=args.output,
        imgsz=args.imgsz,
        dynamic=not args.static
    )

