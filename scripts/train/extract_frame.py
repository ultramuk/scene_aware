import cv2
import os
import glob
from pathlib import Path

def extract_frame(input_root, output_root, frame_interval=15):
    input_root = Path(input_root)
    output_root = Path(output_root)
    total_saved = 0

    for class_dir in input_root.iterdir():
        if not class_dir.is_dir():
            continue
        class_name = class_dir.name
        print(f"\n[INFO] Processing class: {class_name}")

        class_output_dir = output_root / class_name
        class_output_dir.mkdir(parents=True, exist_ok=True)

        video_paths = glob.glob(str(class_dir / "*.h264"))
        saved_idx = 0

        for video_path in video_paths:
            cap = cv2.VideoCapture(video_path)
            if not cap.isOpened():
                print(f"[WARN] Cannot open video: {video_path}")
                continue

            frame_count = 0
            while cap.isOpened():
                ret, frame = cap.read()
                if not ret:
                    break

                if frame_count % frame_interval == 0:
                    ouptut_filename = f"{class_name}-{saved_idx:04d}.jpg"
                    output_path = class_output_dir / ouptut_filename
                    cv2.imwrite(str(output_path), frame)
                    saved_idx += 1
                    total_saved += 1

                frame_count += 1

            cap.release()

        print(f"[OK] Saved {saved_idx} frames to {class_output_dir}")

    print(f"\n[✔] Done. Total frames saved: {total_saved}")


if __name__ == "__main__":
    extract_frame(
        input_root="./datasets/raw_videos",
        output_root="./datasets/train",
        frame_interval=15
    )
