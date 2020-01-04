#!/bin/sh
set -x

TAG=${INPUT_TAG:-}
if [ -z "${TAG}" ]; then
  echo "Missing required variable TAG"
  exit 1
fi

DOCKER_IMAGE_TAG_MAJOR=$(echo "$TAG" | cut -d"." -f1 | sed -e 's/v//')
DOCKER_IMAGE_TAG_MINOR=$(echo "$TAG" | cut -d"." -f2 | sed -e 's/v//')
DOCKER_IMAGE_TAG_PATCH=$(echo "$TAG" | cut -d"." -f3 | cut -d"-" -f1 | sed -e 's/v//')
DOCKER_IMAGE_TAG_PATCH_WITH_SUFFIX=$(echo "$TAG" | cut -d"." -f3 | sed -e 's/v//')

DOCKER_IMAGE_GITHUB="docker.pkg.github.com/${INPUT_GITHUB_PACKAGE_NAME}:${TAG}"

echo "${GITHUB_TOKEN}" | docker login -u flownative --password-stdin docker.pkg.github.com
echo "${INPUT_TARGET_REGISTRY_PASSWORD}" | docker login -u "${INPUT_TARGET_REGISTRY_USERNAME}" --password-stdin "${INPUT_TARGET_REGISTRY_ENDPOINT}"

docker tag "${DOCKER_IMAGE_GITHUB}" "${INPUT_TARGET_IMAGE_NAME}:${DOCKER_IMAGE_TAG_MAJOR}"
docker push "${INPUT_TARGET_IMAGE_NAME}:${DOCKER_IMAGE_TAG_MAJOR}"
docker tag "${DOCKER_IMAGE_GITHUB}" "${INPUT_TARGET_IMAGE_NAME}/:${DOCKER_IMAGE_TAG_MAJOR}.${DOCKER_IMAGE_TAG_MINOR}"
docker push "${INPUT_TARGET_IMAGE_NAME}/:${DOCKER_IMAGE_TAG_MAJOR}.${DOCKER_IMAGE_TAG_MINOR}"
docker tag "${DOCKER_IMAGE_GITHUB}" "${INPUT_TARGET_IMAGE_NAME}:${DOCKER_IMAGE_TAG_MAJOR}.${DOCKER_IMAGE_TAG_MINOR}.${DOCKER_IMAGE_TAG_PATCH}"
docker push "${INPUT_TARGET_IMAGE_NAME}:${DOCKER_IMAGE_TAG_MAJOR}.${DOCKER_IMAGE_TAG_MINOR}.${DOCKER_IMAGE_TAG_PATCH}"
docker tag "${DOCKER_IMAGE_GITHUB}" "${INPUT_TARGET_IMAGE_NAME}:${DOCKER_IMAGE_TAG_MAJOR}.${DOCKER_IMAGE_TAG_MINOR}.${DOCKER_IMAGE_TAG_PATCH_WITH_SUFFIX}"
docker push "${INPUT_TARGET_IMAGE_NAME}:${DOCKER_IMAGE_TAG_MAJOR}.${DOCKER_IMAGE_TAG_MINOR}.${DOCKER_IMAGE_TAG_PATCH_WITH_SUFFIX}"

docker tag "${DOCKER_IMAGE_GITHUB}" "${INPUT_TARGET_IMAGE_NAME}:latest"
docker push "${INPUT_TARGET_IMAGE_NAME}:latest"
