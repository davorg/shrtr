#!/bin/bash
set -euo pipefail

# Extract version from Shrtr.pm
VERSION=$(perl -nE 'say $1 if /\$VERSION\s*=/ and /([\.0-9]+)/' Shrtr/lib/Shrtr.pm)

if [ -z "$VERSION" ]; then
  echo "❌ Could not extract version from Shrtr/lib/Shrtr.pm"
  exit 1
fi

echo "✅ Building and pushing version: $VERSION"

# Ensure buildx is installed and a builder is set up
if ! docker buildx inspect > /dev/null 2>&1; then
  echo "❌ docker buildx is not set up. Run: docker buildx create --use"
  exit 1
fi

# Build and push using buildx
docker buildx build \
  --push \
  -t davorg/shrtr:"$VERSION" \
  -t davorg/shrtr:latest \
  .

echo "✅ Successfully built and pushed:"
echo "   davorg/shrtr:$VERSION"
echo "   davorg/shrtr:latest"

