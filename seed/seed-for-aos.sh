#!/bin/sh

cd $(dirname $0)

#########################################################################################
# Helpers

get_address_for_wallet () {
  WALLET_FILE=../wallets/$1-wallet.json
  WALLET_ADDRESS=$(
node --input-type=module <<EOF
  import { readFile } from 'node:fs/promises'
  import Arweave from 'arweave'
  const arweave = new Arweave({
    protocol: 'http',
    host: 'localhost',
    port: 4000,
  })
  const walletJson = await readFile('$WALLET_FILE', 'utf8')
  const wallet = JSON.parse(walletJson)
  const address = await arweave.wallets.getAddress(wallet)
  console.log(address)
EOF
  )
  echo $WALLET_ADDRESS
}

#########################################################################################
# Mint/grant tokens

# Give the Scheduler Location Publisher 1 AR
curl -q http://localhost:4000/mint/`get_address_for_wallet "scheduler-location-publisher"`/1000000000000
echo
# Give the `aos` Module Publisher 1 AR
curl -q http://localhost:4000/mint/`get_address_for_wallet "aos-module-publisher"`/1000000000000
echo
# Give the bundler service 1 AR
curl -q http://localhost:4000/mint/`get_address_for_wallet "bundler"`/1000000000000
echo
# Give the `ao` units 1 AR
curl -q http://localhost:4000/mint/`get_address_for_wallet "ao"`/1000000000000
echo

#########################################################################################
# Publish the 'Scheduler-Location' record

./publish-scheduler-location.mjs
./mine.mjs

#########################################################################################
# Publish the `aos` Module

./publish-aos-module.mjs
./mine.mjs
