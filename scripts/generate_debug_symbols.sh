#!/bin/bash

# Script to generate and upload debug symbols for Google Play Console
# This script should be run after building the release AAB

echo "🔍 Generating debug symbols for Google Play Console..."

# Set paths
PROJECT_ROOT="$(dirname "$0")/.."
FLUTTER_BUILD_DIR="$PROJECT_ROOT/build/app/intermediates"
SYMBOLS_DIR="$PROJECT_ROOT/symbols"

# Create symbols directory
mkdir -p "$SYMBOLS_DIR"

echo "📁 Created symbols directory: $SYMBOLS_DIR"

# Find and copy native debug symbols
echo "🔎 Looking for native debug symbols..."

# Copy ARM64 symbols
if [ -d "$FLUTTER_BUILD_DIR/merged_native_libs/release/out/lib/arm64-v8a" ]; then
    mkdir -p "$SYMBOLS_DIR/arm64-v8a"
    find "$FLUTTER_BUILD_DIR" -name "*.so" -path "*/arm64-v8a/*" -exec cp {} "$SYMBOLS_DIR/arm64-v8a/" \;
    echo "✅ Copied ARM64 symbols"
fi

# Copy ARMv7 symbols
if [ -d "$FLUTTER_BUILD_DIR/merged_native_libs/release/out/lib/armeabi-v7a" ]; then
    mkdir -p "$SYMBOLS_DIR/armeabi-v7a"
    find "$FLUTTER_BUILD_DIR" -name "*.so" -path "*/armeabi-v7a/*" -exec cp {} "$SYMBOLS_DIR/armeabi-v7a/" \;
    echo "✅ Copied ARMv7 symbols"
fi

# Copy x86_64 symbols
if [ -d "$FLUTTER_BUILD_DIR/merged_native_libs/release/out/lib/x86_64" ]; then
    mkdir -p "$SYMBOLS_DIR/x86_64"
    find "$FLUTTER_BUILD_DIR" -name "*.so" -path "*/x86_64/*" -exec cp {} "$SYMBOLS_DIR/x86_64/" \;
    echo "✅ Copied x86_64 symbols"
fi

# Copy x86 symbols
if [ -d "$FLUTTER_BUILD_DIR/merged_native_libs/release/out/lib/x86" ]; then
    mkdir -p "$SYMBOLS_DIR/x86"
    find "$FLUTTER_BUILD_DIR" -name "*.so" -path "*/x86/*" -exec cp {} "$SYMBOLS_DIR/x86/" \;
    echo "✅ Copied x86 symbols"
fi

# Create symbols zip file
cd "$SYMBOLS_DIR"
if [ "$(find . -name "*.so" | wc -l)" -gt 0 ]; then
    zip -r "../native-debug-symbols.zip" .
    echo "📦 Created native-debug-symbols.zip"
    echo ""
    echo "🎉 Debug symbols generated successfully!"
    echo ""
    echo "📋 Next steps:"
    echo "1. Upload the AAB file to Google Play Console"
    echo "2. In the Play Console, go to the specific release"
    echo "3. Download the generated native-debug-symbols.zip"
    echo "4. Upload it in the 'Native debug symbols' section"
    echo ""
    echo "📁 Symbols file location: $PROJECT_ROOT/native-debug-symbols.zip"
else
    echo "⚠️  No native libraries found. This might be normal if your app doesn't use native code."
fi

cd "$PROJECT_ROOT"
