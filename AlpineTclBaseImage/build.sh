#!/bin/bash
set -euo pipefail

DOCKER_USER="siqsuruq"
IMAGE_NAME="tcl"
DOCKERFILE="Dockerfile"     # one Dockerfile for both
DIST="alpine"

# ---- choose what to build ----
TCLVER="${TCLVER:-9.0.3}"	# e.g. 8.6.17 or 9.0.3
TCLMAJOR="${TCLMAJOR:-${TCLVER%%.*}}"

# derive tags
TAG="tcl${TCLMAJOR}-${DIST}"        # moving tag: tcl8-debian
VERSION="${TCLVER}-${DIST}"         # pinned tag: 8.6.17-debian

# derive install paths from major
TCL_HOME="/opt/tcl${TCLMAJOR}"
TCL_LIB_HOME="${TCL_HOME}/lib"
TCL_BIN_HOME="${TCL_HOME}/bin"
TCLSHORTVER="$(echo "$TCLVER" | awk -F. '{print $1"."$2}')"  # 8.6 or 9.0
TCLSH="tclsh${TCLSHORTVER}"                                 # tclsh8.6 / tclsh9.0

BUILD_DATE="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
VCS_REF="$(git rev-parse --short HEAD)"

echo "==> Building ${IMAGE_NAME}:${TAG} (Tcl ${TCLVER} on ${DIST})..."
docker build \
  --build-arg BUILD_DATE="${BUILD_DATE}" \
  --build-arg VCS_REF="${VCS_REF}" \
  --build-arg TCLVER="${TCLVER}" \
  --build-arg TCLSHORTVER="${TCLSHORTVER}" \
  --build-arg TCL_HOME="${TCL_HOME}" \
  --build-arg TCL_LIB_HOME="${TCL_LIB_HOME}" \
  --build-arg TCL_BIN_HOME="${TCL_BIN_HOME}" \
  --build-arg TCLSH="${TCLSH}" \
  --pull \
  --no-cache \
  -f "${DOCKERFILE}" \
  -t "${IMAGE_NAME}:${TAG}" \
  .

echo "==> Tagging..."
docker tag "${IMAGE_NAME}:${TAG}" "${DOCKER_USER}/${IMAGE_NAME}:${TAG}"
docker tag "${IMAGE_NAME}:${TAG}" "${DOCKER_USER}/${IMAGE_NAME}:${VERSION}"

echo "==> Pushing..."
docker push "${DOCKER_USER}/${IMAGE_NAME}:${TAG}"
docker push "${DOCKER_USER}/${IMAGE_NAME}:${VERSION}"

echo "==> Done: ${DOCKER_USER}/${IMAGE_NAME}:${TAG} and :${VERSION}"