#!/bin/bash

# SceneAware: Shell script to split ImageFolder-style dataset into train/valid
# Input directory: datasets/train/
# Output directory: datasets/sceneaware_small/
# Will copy 20% of images in each class folder to val/

SRC_DIR="datasets/train"
DEST_DIR="datasets/sceneaware_small"
VAL_RATIO=0.2

echo "Source: $SRC_DIR"
echo "Target: $DEST_DIR"

for class in "$SRC_DIR"/*; do
    if [[ -d "$class" ]]; then
        class_name=$(basename "$class")
        echo "Processing class: $class_name"

        mkdir -p "$DEST_DIR/train/$class_name"
        mkdir -p "$DEST_DIR/val/$class_name"

        # Get list of all image files in the class directory
        mapfile -t images < <(find "$class" -type f -iname '*.jpg')

        total=${#images[@]}
        num_val=$(printf "%.0f" "$(echo "$total * $VAL_RATIO" | bc)")

        echo "   Total images: $total, Moving to val: $num_val"

        selected=($(printf "%s\n" "${images[@]}" | shuf -n $num_val))

        for image in "${images[@]}"; do
            filename=$(basename "$image")
            if printf '%s\n' "${selected[@]}" | grep -q "$filename"; then
                cp "$image" "$DEST_DIR/val/$class_name/$filename"
            else
                cp "$image" "$DEST_DIR/train/$class_name/$filename"
            fi
        done
    fi
done

echo "Validation split complete."
