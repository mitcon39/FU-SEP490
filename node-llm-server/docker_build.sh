#!/bin/bash

IMAGE_NAME=lnguyennb/node-llm-server
TAG=$(date +%Y%m%d%H%M%S)
PLATFORMS="linux/amd64,linux/arm64/v8"
REGISTRY_TOKEN_PATH=.token

echo "Building image $IMAGE_NAME:$TAG"
# Build and push the Docker image
docker buildx build --platform="$PLATFORMS" -t "$IMAGE_NAME:$TAG" --build-arg REGISTRY_TOKEN="$(cat "$REGISTRY_TOKEN_PATH")" . --push || exit 1
docker buildx build --platform="$PLATFORMS" -t "$IMAGE_NAME:latest" --build-arg REGISTRY_TOKEN="$(cat "$REGISTRY_TOKEN_PATH")" . --push || exit 1
