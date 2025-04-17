#!/bin/sh

AO_LOCALNET_DIR=$(dirname $(realpath $0))
process_name="$1"
shift 1

if [ -z "$WALLET_FILE" ]; then
  WALLET_FILE="$AO_LOCALNET_DIR/wallets/aos-wallet.json"
else
  WALLET_FILE=$(realpath "$WALLET_FILE")
fi
if [ ! -f "$WALLET_FILE" ]; then
  echo "wallet does not exist: \"$WALLET_FILE\""
  exit 1
fi

ao_authority=$($AO_LOCALNET_DIR/wallets/printWalletAddresses.mjs | grep ao-wallet | awk '{print $1}')

export WALLET_FILE
$AO_LOCALNET_DIR/aos.sh $process_name --tag-name Authority --tag-value "$ao_authority" "$@" --load - <<EOF
  return ao.id
EOF
