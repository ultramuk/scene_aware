#!/usr/bin/env python3

import os
import argparse
import subprocess
import onnx

def is_static_onnx(onnx_path):
    """
    Check if ONNX model has fully static input shapes.
    Returns True if all input dimensions are fixed integers.
    """
    model = onnx.load(onnx_path)
    for input_tensor in model.graph.input:
        shape = input_tensor.type.tensor_type.shape
        for dim in shape.dim:
            if dim.dim_param or dim.dim_value == 0:
                return False
    return True

def build_tensorrt_engine(onnx_path, output_dir='exports', imgsz=640, use_fp16=True, workspace=2048):
    assert os.path.exists(onnx_path), f"ONNX model not found: {onnx_path}"
    os.makedirs(output_dir, exist_ok=True)

    engine_name = os.path.splitext(os.path.basename(onnx_path))[0] + '.engine'
    engine_path = os.path.join(output_dir, engine_name)

    is_static = is_static_onnx(onnx_path)

    print(f"\n🚀 Building TensorRT engine:")
    print(f"  ONNX model     : {onnx_path}")
    print(f"  Output engine  : {engine_path}")
    print(f"  Mode           : {'STATIC' if is_static else 'DYNAMIC'}")
    print(f"  Precision      : {'FP16' if use_fp16 else 'FP32'}")
    print(f"  Workspace      : {workspace} MiB\n")

    # Base command
    command = [
        'trtexec',
        f'--onnx={onnx_path}',
        f'--saveEngine={engine_path}',
        f'--memPoolSize=workspace:{workspace}',
    ]

    # Only add --optShapes if model is dynamic
    if not is_static:
        command += [
            f'--minShapes=images:1x3x{imgsz}x{imgsz}',
            f'--optShapes=images:1x3x{imgsz}x{imgsz}',
            f'--maxShapes=images:1x3x{imgsz}x{imgsz}',
        ]

    if use_fp16:
        command.append('--fp16')

    print(f"[CMD] {' '.join(command)}\n")

    try:
        subprocess.run(command, check=True)
        print(f"Engine successfully built and saved to: {engine_path}")
    except subprocess.CalledProcessError as e:
        print("Failed to build engine with trtexec.")
        print(f"Return code: {e.returncode}")
        exit(1)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="CrashNet: Build TensorRT Engine from ONNX")
    parser.add_argument('--onnx', type=str, required=True, help='Path to ONNX model file')
    parser.add_argument('--output', type=str, default='exports', help='Directory to save TensorRT engine')
    parser.add_argument('--imgsz', type=int, default=640, help='Input image size (square)')
    parser.add_argument('--fp32', action='store_true', help='Use FP32 instead of FP16')
    parser.add_argument('--workspace', type=int, default=2048, help='GPU memory workspace size in MB')

    args = parser.parse_args()

    build_tensorrt_engine(
        onnx_path=args.onnx,
        output_dir=args.output,
        imgsz=args.imgsz,
        use_fp16=not args.fp32,
        workspace=args.workspace
    )
