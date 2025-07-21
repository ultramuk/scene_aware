#!/usr/bin/env python3

import torch
import argparse
import os
from torchvision import models

def export_resnet_to_onnx(pt_path, output_path="model/scene_classifier.onnx", input_size=(1, 3, 244, 244)):
    assert os.path.exists(pt_path), f"Model not found: {pt_path}"
    os.makedirs(os.path.dirname(output_path), exist_ok=True)

    # 1. state_dict 로드
    state_dict = torch.load(pt_path, map_location="cpu")

    # 2. fc.weight.shape[0]을 이용해 클래스 수 추론
    if "fc.weight" in state_dict:
        num_classes = state_dict["fc.weight"].shape[0]
    else:
        raise ValueError("Cannot determine number of classes from state_dict")

    # 3. 모델 생성 및 weight 로딩
    model = models.resnet18()
    model.fc = torch.nn.Linear(model.fc.in_features, num_classes)
    model.load_state_dict(state_dict)
    model.eval()

    dummy_input = torch.randn(*input_size)

    print(f"Exporting model to ONNX: {output_path} (num_classes={num_classes})")
    torch.onnx.export(
        model, dummy_input, output_path,
        input_names=["input"], output_names=["output"],
        dynamic_axes={"input": {0: "batch_size"}, "output": {0: "batch_size"}},
        opset_version=12,
        do_constant_folding=True
    )
    print("Export complete.")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--pt', type=str, required=True, help='Path to .pt model')
    parser.add_argument('--output', type=str, default="model/scene_classifier.onnx")
    parser.add_argument('--imgsz', type=int, default=224)
    args = parser.parse_args()

    export_resnet_to_onnx(
        pt_path=args.pt,
        output_path=args.output,
        input_size=(1, 3, args.imgsz, args.imgsz)
    )
