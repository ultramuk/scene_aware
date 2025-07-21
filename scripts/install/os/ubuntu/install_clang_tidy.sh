#!/bin/bash

# Install necessary dependencies
sudo apt update -y
sudo apt upgrade -y

# Install clang-tidy
echo "Installing clang-tidy..."
sudo apt install -y clang-tidy

# Verify installed version
echo "clang-tidy version:"
clang-tidy --version
