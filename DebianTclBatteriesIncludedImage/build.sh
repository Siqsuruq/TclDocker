#!/bin/bash
set -euo pipefail

# -------- CONFIG --------
DOCKER_USER="siqsuruq"
IMAGE_NAME="tcl"
TAG="tcl9bi-debian"
VERSION="9.0.3-bi-debian"
DOCKERFILE="DockerfileTcl9BI"

BUILD_DATE="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

echo "==> Building BI image..."
docker build \
  --build-arg BUILD_DATE="${BUILD_DATE}" \
  --pull \
  --no-cache \
  -f "${DOCKERFILE}" \
  -t "${IMAGE_NAME}:${TAG}" \
  .

echo "==> Tagging image..."
docker tag "${IMAGE_NAME}:${TAG}" "${DOCKER_USER}/${IMAGE_NAME}:${TAG}"
docker tag "${IMAGE_NAME}:${TAG}" "${DOCKER_USER}/${IMAGE_NAME}:${VERSION}"

echo "==> Pushing to Docker Hub..."
docker push "${DOCKER_USER}/${IMAGE_NAME}:${TAG}"
docker push "${DOCKER_USER}/${IMAGE_NAME}:${VERSION}"

echo "==> Done."
