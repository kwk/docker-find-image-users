#!/bin/bash

################################################################################
#
# Find tags in a Docker Registry that reference a given image ID.
#
# Usage: Simply call program without arguments to get help.
#
# Source: https://github.com/kwk/docker-find-image-users
#
################################################################################

set -e

PROG_BASENAME=$(basename $0)
DEFAULT_REGISTRY_HOST=www.YOUR_DEFAULT_REGISTRY_HOST.com

if [ $# -lt 1 ]; then
  echo "Usage: $PROG_BASENAME IMAGE_ID [REGISTRY_HOST_WITH_PORT [REPO [REPO ...]]]]"
  echo ""
  echo "This program searches the given Docker registry in either all"
  echo "repos or the ones that are given that to find the tags that"
  echo "reference the given IMAGE_ID."
  echo ""
  echo "If no registry host is given $DEFAULT_REGISTRY_HOST is used."
  echo ""
  echo "By default informational output is output to stderr. If you don't"
  echo "want to see it, simply append 2>/dev/null to your call and only the"
  echo "tags that reference the given IMAGE_ID will be printed."
  echo ""
  echo "NOTE: Currently this program only works with Docker Registry API v1."
  exit 1
fi

IMAGE_ID=$1
REGISTRY_HOST=${2:-$DEFAULT_REGISTRY_HOST}
REGISTRY_URL=http://${REGISTRY_HOST}/v1

echo "- Using registry URL: $REGISTRY_URL" 1>&2

# How it is done:
#
# Search for all avaiable repositories and find all tags for each repo that
# reference the given image ID.

if [ $# -lt 3 ]; then
  # No repo is explicitly given, so we search in all repos
  REPOS=$(curl -s $REGISTRY_URL/search \
    | jq '.results | .[].name' \
    | tr -d '"')
else
  REPOS="${@:3}"
fi

echo "- Searching in repositories: $(echo $REPOS | tr -d "\n")" 1>&2;

for repo in $REPOS; do
  echo "- Searching in $repo ..." 1>&2
  tags=$(curl -s $REGISTRY_URL/repositories/$repo/tags \
    | jq ". as \$object | keys[] | select(\$object[.]==\"$IMAGE_ID\")" \
    | tr -d '"')
  for tag in $tags; do
    echo "$repo:$tag"
  done
done
