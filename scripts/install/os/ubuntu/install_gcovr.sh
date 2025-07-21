#!/bin/bash

# Install necessary dependencies
sudo apt update -y
sudo apt upgrade -y

# Install gcovr
echo "Installing gcovr..."
sudo apt install -y gcovr
sudo apt install -y graphviz

# Verify installed version
echo "gcovr version:"
gcovr --version
echo "graphviz version:"
graphviz --version
