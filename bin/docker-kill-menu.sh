#!/bin/bash

dir=$(dirname "$0")

# shellcheck disable=SC1091
source "$dir/../default-options.sh"

docker kill "$(docker ps | "$BASH_TOYS_INTERACTIVE_FILTER" | awk '{print $1}')"
