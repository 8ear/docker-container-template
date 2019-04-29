#!/bin/sh
set -e

STARTMSG="[PULL]"

[ -z "$1" ] && echo "$STARTMSG No parameter with the version. Exit now." && exit 1
VERSION="$1"
TAG="$(echo "$VERSION" | cut -d : -f 2)"

# Docker Repo e.g. dcso/misp-dockerized-proxy
[ -z "$(git remote get-url origin|grep git@)" ] || GIT_REPO="$(git remote get-url origin|sed 's,.*:,,'|sed 's,....$,,')"
[ -z "$(git remote get-url origin|grep http)" ] || GIT_REPO="$(git remote get-url origin|sed 's,.*github.com/,,'|sed 's,....$,,')"
[ -z "$GITLAB_HOST" ] || [ -z "$(echo "$GIT_REPO"|grep "$GITLAB_HOST")" ] ||  GIT_REPO="$(git remote get-url origin|sed 's,.*'${GITLAB_HOST}'/'${GITLAB_GROUP}'/,,'|sed 's,....$,,')"
# Set Container Name
CONTAINER_NAME="$(echo "$GIT_REPO"|cut -d / -f 2|tr '[:upper:]' '[:lower:]')"


# Downloading container
echo "docker pull $VERSION" && docker pull "$VERSION"
# Retag container to our default "not2push"
echo "docker tag $VERSION not2push/$CONTAINER_NAME:$TAG" && docker tag "$VERSION" "not2push/$CONTAINER_NAME:$TAG"
