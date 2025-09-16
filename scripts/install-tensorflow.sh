#!/usr/bin/env bash
set -euo pipefail

# Default values
VERSION="2.15.0"
INSTALL_PATH="/usr/local"

usage() {
  echo "Usage: $0 [--version=VERSION] [--path=INSTALL_PATH]"
  echo
  echo "Example:"
  echo "  $0 --version=2.15.0 --path=./my-custom-path/"
  exit 1
}

# Parse arguments
for arg in "$@"; do
  case $arg in
    --version=*)
      VERSION="${arg#*=}"
      shift
      ;;
    --path=*)
      INSTALL_PATH="${arg#*=}"
      shift
      ;;
    -h|--help)
      usage
      ;;
    *)
      echo "Unknown parameter: $arg"
      usage
      ;;
  esac
done

echo "📦 Installing TensorFlow C library version $VERSION into $INSTALL_PATH"

TMP_TAR="libtensorflow.tar.gz"
URL="https://storage.googleapis.com/tensorflow/libtensorflow/libtensorflow-cpu-linux-x86_64-${VERSION}.tar.gz"

# Download
curl -L -o "$TMP_TAR" "$URL"

# Extract
tar -C "$INSTALL_PATH" -xzf "$TMP_TAR"

# Clean up
rm -f "$TMP_TAR"

echo "✅ Installation completed at $INSTALL_PATH."