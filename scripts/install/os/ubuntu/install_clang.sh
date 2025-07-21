#!/bin/bash

# Install necessary dependencies
sudo apt update -y
sudo apt upgrade -y

# Install clang-format
echo "Installing clang-format..."
sudo apt install -y clang-format

# Install clang-tidy
echo "Installing clang-tidy..."
sudo apt install -y clang-tidy

# Verify installed version
echo "clang-format version:"
clang-format --version

echo "clang-tidy version:"
clang-tidy --version
