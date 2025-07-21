#!/usr/bin/env python3

import os
import argparse
import subprocess
import onnx


def extract_input_info(onnx_path):
    """
    Return input tensor name, shape, and whether it is dynamic.
    """
    model = onnx.load(onnx_path)
    input_tensor = model.graph.input[0]
    name = input_tensor.name
    shape_proto = input_tensor.type.tensor_type.shape

    shape = []
    is_dynamic = False
    for dim in shape_proto.dim:
        if dim.dim_param or dim.dim_value == 0:
            shape.append(-1)  # dynamic
            is_dynamic = True
        else:
            shape.append(dim.dim_value)
    return name, shape, is_dynamic


def build_tensorrt_engine(onnx_path, output_dir='exports', use_fp16=True, workspace=2048):
    assert os.path.exists(onnx_path), f"ONNX model not found: {onnx_path}"
    os.makedirs(output_dir, exist_ok=True)

    engine_name = os.path.splitext(os.path.basename(onnx_path))[0] + '.engine'
    engine_path = os.path.join(output_dir, engine_name)

    input_name, input_shape, is_dynamic = extract_input_info(onnx_path)

    print(f"Building TensorRT engine:")
    print(f"  ONNX model     : {onnx_path}")
    print(f"  Input tensor   : {input_name} ({'x'.join(map(str, input_shape))})")
    print(f"  Output engine  : {engine_path}")
    print(f"  Mode           : {'DYNAMIC' if is_dynamic else 'STATIC'}")
    print(f"  Precision      : {'FP16' if use_fp16 else 'FP32'}")
    print(f"  Workspace      : {workspace} MiB\n")

    command = [
        'trtexec',
        f'--skipInference',
        f'--onnx={onnx_path}',
        f'--saveEngine={engine_path}',
        f'--memPoolSize=workspace:{workspace}',
    ]

    # If dynamic, add min/opt/max shapes
    if is_dynamic:
        shape_str = 'x'.join([str(dim if dim != -1 else 1) for dim in input_shape])
        command += [
            f'--minShapes={input_name}:{shape_str}',
            f'--optShapes={input_name}:{shape_str}',
            f'--maxShapes={input_name}:{shape_str}',
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
    parser = argparse.ArgumentParser(description="Generic: Build TensorRT Engine from ONNX")
    parser.add_argument('--onnx', type=str, required=True, help='Path to ONNX model file')
    parser.add_argument('--output', type=str, default='exports', help='Directory to save TensorRT engine')
    parser.add_argument('--fp32', action='store_true', help='Use FP32 instead of FP16')
    parser.add_argument('--workspace', type=int, default=2048, help='GPU memory workspace size in MB')

    args = parser.parse_args()

    build_tensorrt_engine(
        onnx_path=args.onnx,
        output_dir=args.output,
        use_fp16=not args.fp32,
        workspace=args.workspace
    )

### ResNet ###
# python scripts/train/build_tensorrt_engine.py \
#   --onnx model/scene_classifier.onnx \
#   --output model \
#   --fp32 \
#   --workspace 4096
