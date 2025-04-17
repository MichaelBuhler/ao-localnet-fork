#!/bin/bash

cd $(dirname $0)

if [ "" = "$1" ]; then
  npx --yes @permaweb/wallet
  exit 0
fi

case "$1" in
  ao | aos | aos-module-publisher | bundler | scheduler-location-publisher | turbo | user)
    WALLET_FILE="$1-wallet.json"
    ;;
  *)
    WALLET_FILE="$1"
    ;;
esac

if [ -f "$WALLET_FILE" ]; then
  echo "$WALLET_FILE already exists. Refusing to overwrite it."
  exit 1
fi

npx --yes @permaweb/wallet@0.1.0 > "$WALLET_FILE"

echo "created $WALLET_FILE..."
