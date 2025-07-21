#!/bin/bash

# Install gcovr
echo "Installing gcovr..."
brew install gcovr

# Verify installed version
echo "gcovr version:"
gcovr --version
