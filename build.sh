#!/bin/bash

# Exit immediately if any command exits with a non-zero status
set -e

# Clone or update Flutter SDK
if [ -d "flutter" ]; then
  echo "==> Flutter SDK directory exists. Updating..."
  cd flutter
  git pull
  cd ..
else
  echo "==> Cloning Flutter SDK (version 3.41.6)..."
  git clone https://github.com/flutter/flutter.git --depth 1 -b 3.41.6
fi

# Configure and build the Flutter Web project
echo "==> Configuring Flutter Web support..."
flutter/bin/flutter config --enable-web

echo "==> Getting project dependencies..."
flutter/bin/flutter pub get

echo "==> Building web application..."
flutter/bin/flutter build web --release
