#!/bin/bash
set -euo pipefail

IMAGE_NAME="${IMAGE_NAME:-joaoeudes7/vllm-turboquant-lmcache}"
IMAGE_TAG="${IMAGE_TAG:-latest}"

docker push "${IMAGE_NAME}:${IMAGE_TAG}"
