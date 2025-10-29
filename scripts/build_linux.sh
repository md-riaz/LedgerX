#!/bin/bash

echo "Building LedgerX for Linux..."
echo ""

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "Flutter is not installed or not in PATH."
    echo "Please install Flutter from https://flutter.dev"
    exit 1
fi

# Get dependencies
echo "Installing dependencies..."
flutter pub get
if [ $? -ne 0 ]; then
    echo "Failed to get dependencies"
    exit 1
fi

# Build for Linux
echo "Building Linux application..."
flutter build linux --release
if [ $? -ne 0 ]; then
    echo "Build failed"
    exit 1
fi

echo ""
echo "Build completed successfully!"
echo "Executable location: build/linux/x64/release/bundle/ledgerx"
echo ""
