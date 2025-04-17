#!/bin/sh

AO_LOCALNET_DIR=$(dirname $(realpath $0))

if [ -z "$WALLET_FILE" ]; then
  WALLET_FILE="$AO_LOCALNET_DIR/wallets/aos-wallet.json"
else
  WALLET_FILE=$(realpath "$WALLET_FILE")
fi
if [ ! -f "$WALLET_FILE" ]; then
  echo "wallet does not exist: \"$WALLET_FILE\""
  exit 1
fi

export ARWEAVE_GRAPHQL=http://localhost:4000/graphql
export CU_URL=http://localhost:4004
export GATEWAY_URL=http://localhost:4000
export MU_URL=http://localhost:4002

# Graphql query to Arlocal to automatically discover the AOS module tx id
export AOS_MODULE=$(
node --input-type=module <<EOF
const query = \`query {
  transactions (
    tags: [
      { name: "Data-Protocol", values: ["ao"] },
      { name: "Type", values: ["Module"] },
      { name: "Content-Type", values: ["application/wasm"] },
    ],
    sort: HEIGHT_DESC, first: 1
  ) {
    edges { node { id } }
  }
}\`
const body = JSON.stringify({ query })
const res = await fetch('$ARWEAVE_GRAPHQL', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body,
})
console.log((await res.json()).data.transactions.edges[0].node.id)
EOF
)

# The SCHEDULER env var should be set to the wallet address that published a tx with a 'Scheduler-Location' tag
SCHEDULER_LOCATION_PUBLISHER_WALLET_FILE="$AO_LOCALNET_DIR/wallets/scheduler-location-publisher-wallet.json"
if [ ! -f "$SCHEDULER_LOCATION_PUBLISHER_WALLET_FILE" ]; then
  echo "wallet does not exist: \"$SCHEDULER_LOCATION_PUBLISHER_WALLET_FILE\""
  exit 1
fi
export SCHEDULER=$(
cd "$AO_LOCALNET_DIR" && node --input-type=module <<EOF
  import { readFile } from 'node:fs/promises'
  import Arweave from 'arweave'
  const arweave = new Arweave({
    protocol: 'http',
    host: 'localhost',
    port: 4000,
  })
  const walletJson = await readFile('$SCHEDULER_LOCATION_PUBLISHER_WALLET_FILE', 'utf8')
  const wallet = JSON.parse(walletJson)
  const address = await arweave.wallets.getAddress(wallet)
  console.log(address)
EOF
)

# set env var AO_LOCALNET_NO_SPLASH to any value to surpress this splashed info
if [ -z "$AO_LOCALNET_NO_SPLASH" ]; then
  echo "export GATEWAY_URL     = $GATEWAY_URL"
  echo "export MU_URL          = $MU_URL"
  echo "export CU_URL          = $CU_URL"
  echo "export ARWEAVE_GRAPHQL = $ARWEAVE_GRAPHQL"
  echo "export AOS_MODULE      = $AOS_MODULE"
  echo "export SCHEDULER       = $SCHEDULER"
  echo "using  wallet          = $WALLET_FILE"
  echo "using  args            = $@"
fi

AOS_BIN=$(realpath "$AO_LOCALNET_DIR/node_modules/.bin/aos")
$AOS_BIN --wallet "$WALLET_FILE" "$@"
