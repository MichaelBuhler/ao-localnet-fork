#!/bin/sh

NPM_SCRIPT=$1
shift 1

AO_LOCALNET_DIR=$(dirname $(realpath $0))
cd "$AO_LOCALNET_DIR" && npm run $NPM_SCRIPT -- "$@"
