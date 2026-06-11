#!/bin/bash

# Exit immediately if any command exits with a non-zero status
set -e

FLUTTER_VERSION="3.44.1"
FLUTTER_DIR="flutter"

# Clone Flutter SDK if not already present
if [ -d "$FLUTTER_DIR/.git" ]; then
  echo "==> Flutter SDK directory exists. Skipping clone."
else
  echo "==> Cloning Flutter SDK (version $FLUTTER_VERSION)..."
  git clone https://github.com/flutter/flutter.git --depth 1 -b "$FLUTTER_VERSION" "$FLUTTER_DIR"
fi

# Add Flutter to PATH for this script
export PATH="$PWD/$FLUTTER_DIR/bin:$PATH"

# Configure Flutter Web support
echo "==> Configuring Flutter Web support..."
flutter config --enable-web

# Get project dependencies
echo "==> Getting project dependencies..."
flutter pub get

# Build the web application
echo "==> Building web application..."
flutter build web --release --no-tree-shake-icons
