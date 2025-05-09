#!/bin/bash

# CrashNet: Shell script to split YOLOv8-style dataset into train/valid
# Target directory: datasets/roboflow_accident/train/
# Will move 20% of images + labels into valid/

BASE_DIR="datasets/roboflow_accident"
TRAIN_DIR="$BASE_DIR/train"
VALID_DIR="$BASE_DIR/valid"
SPLIT_RATIO=0.2

# Create valid directories if not exist
mkdir -p "$VALID_DIR/images"
mkdir -p "$VALID_DIR/labels"

# Get all image filenames (no extension)
mapfile -t IMAGE_FILES < <(find "$TRAIN_DIR/images" -type f \( -iname '*.jpg' -o -iname '*.png' \) -printf "%f\n")

TOTAL=${#IMAGE_FILES[@]}
NUM_VALID=$(printf "%.0f" "$(echo "$TOTAL * $SPLIT_RATIO" | bc)")

echo "Total images: $TOTAL"
echo "Moving $NUM_VALID images to validation set..."

# Shuffle and select subset
SELECTED=($(printf "%s\n" "${IMAGE_FILES[@]}" | shuf -n $NUM_VALID))

for IMAGE in "${SELECTED[@]}"; do
    BASENAME="${IMAGE%.*}"
    EXT="${IMAGE##*.}"

    IMG_PATH="$TRAIN_DIR/images/$BASENAME.$EXT"
    LABEL_PATH="$TRAIN_DIR/labels/$BASENAME.txt"

    if [[ -f "$IMG_PATH" && -f "$LABEL_PATH" ]]; then
        mv "$IMG_PATH" "$VALID_DIR/images/"
        mv "$LABEL_PATH" "$VALID_DIR/labels/"
    else
        echo "⚠️ Missing pair for $BASENAME — skipping."
    fi
done

echo "Validation split complete."
