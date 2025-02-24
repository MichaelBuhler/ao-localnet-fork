#!/bin/sh

# TODO: need to find this module id programatically with a query to Arlocal
AOS_MODULE=JArYBF-D8q2OmZ4Mok00sD2Y_6SYEQ7Hjx-6VZ_jl3g
echo "!!!"
echo "!!!"
echo "!!!"
echo "!!!                      $AOS_MODULE"
echo "!!!"
echo "!!! downloading this aos ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
echo "!!! module from testnet"
echo "!!!"
echo "!!!"
echo "!!!"

curl -L https://arweave.net/$AOS_MODULE -o extras/aos.wasm
