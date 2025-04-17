# ao-localnet

Run a complete [AO Computer](http://ao.computer/) testbed, locally, with Docker Compose.

> [!CAUTION]
> **This is an experimental repo that is intended for power users.**
>
> Please join the Marshal [Discord server](https://discord.gg/KzSRvefPau) for help and support.

## Purpose

The repository may helpful if you are doing one or more of the following:

1. Contributing to [@permaweb/ao](https://github.com/permaweb/ao).
1. Compiling custom `ao` modules using the [AO Dev CLI](https://github.com/permaweb/dev-cli) or other [another build process](https://github.com/MichaelBuhler/custom-ao-modules).
   - And you want to avoid publishing each revision onto Arweave mainnet.
1. You are developing an `ao` component (e.g. a `cu`, `mu`, or `su`).
   - And you want to plug that into a working environment.
1. You are developing Lua code that will be loaded into `aos` processes.
   - And you want to avoid bricking your `aos` processes on `ao` testnet.

## Quick Start Guide (as Node.js module)

```shell
npm install https://github.com/MichaelBuhler/ao-localnet.git
npx ao-localnet configure       # generate wallets and download AOS module
npx ao-localnet start           # build and run all Docker containers
npx ao-localnet seed            # seed AOS and scheduler info into the localnet
npx ao-localnet spawn "name"    # spawn new AOS process with "name"
npx ao-localnet connect "name"  # connect to the new AOS process
npx ao-localnet stop            # tear down Docker containers (data is retained)
```

## Quick Start Guide (Run from source)

1. Clone this repo.
1. Setup the necessary Arweave wallets:
    1. `cd` into the `wallets` directory (at the root of this repo).
    1. Run `./generateAll.sh` to create new wallets for everything.
        - _See [wallets/README.md](./wallets/README.md) for more details._
1. Boot up the localnet:
    1. Run `docker compose up --detach`.
        - _You will need to have the Docker daemon running._
        - _This could take a while the first time you run it._
      - You will have many services now bound to ports in the 4000 range (all subject to change):
          - http://localhost:4000/ - ArLocal (Arweave gateway/mock)
          - http://localhost:4002/ - An `ao` messenger unit (`mu`).
          - http://localhost:4003/ - An `ao` schedule unit (`su`).
          - http://localhost:4004/ - An `ao` compute unit (`cu`).
          - http://localhost:4007/ - A simple Arweave bundler/uploader
1. Seed initial data onto the blockchain:
    1. `cd` into the `seed` directory (at the root of this repo).
    1. Run `./download-aos-module.sh` to fetch an AOS WASM binary from Arweave.
    1. Run `./seed-for-aos.sh` to grant AR tokens to the wallets and publish the AOS module.
1. Run `aos`:
    1. Run `./aos.sh`.

## Additional Services

> [!WARNING]
> These are very old, experimental features that are not well supported.

- ArDrive Web:
  - Run `docker compose --profile ardrive up`.
  - http://localhost:4001/
  - _Not fully functional. See below for more details._
- Turbo Upload Service (an Arweave uploader/bundlr):
  - Run `docker compose --profile turbo up`.
  - http://localhost:4005/
  - _Not fully functional. See below for more details._

## Development Status of this Repo

> [!WARNING]
> Much of this section is currently outdated. WIP.

- ✅ ArLocal instance mocking Arweave and acting as Arweave gateway.
  - ℹ️ There are some features missing from [the upstream](https://github.com/textury/arlocal)
    that tend to be used by block explorers, so we are using
    [this fork](https://github.com/MichaelBuhler/arlocal), which fixes:
    - ✅ Added `GET /tx/pending` to fetch pending transaction ids
    - ✅ Added `GET /raw/:txid` to download raw transaction data
    - ✅ Fix some bugs in chunk uploading/downloading
    - ⬜ Blocks don't include `block_size` ([#1](https://github.com/MichaelBuhler/arlocal/issues/1))
    - ⬜ Blocks don't include `reward_addr` ([#3](https://github.com/MichaelBuhler/arlocal/issues/3))
    - ⬜ Blocks don't include `weave_size` ([#2](https://github.com/MichaelBuhler/arlocal/issues/2))
- ✅ Arweave block explorer (web interface).
  - ✅ ScAR - A lightweight option from [here](https://github.com/renzholy/scar),
    forked [here](https://github.com/MichaelBuhler/scar), with improvements.
  - ⬜ ArweaveWebWallet - Another option from [here](https://github.com/jfbeats/ArweaveWebWallet)
    which powers https://arweave.app/.
- ✅ Fully functional `ao` computer, using the
  [reference implementations](https://github.com/permaweb/ao/servers).
  - ✅ `cu`
  - ✅ `mu`
  - ✅ `su`
- ✅ Successfully launching `aos` processes on the `ao` localnet.
- ⬜ Live reloading for `cu` and `mu` development.
  - _A cool [feature](https://docs.docker.com/compose/compose-file/develop/) of Docker Compose._
- ⬜ nginx reverse proxy, for hostname routing
  - Currently in testing. [This](https://hub.docker.com/r/nginxproxy/nginx-proxy) looks promising.
- ⬜ DNS routing
  - ✅ Routing `*.ao-localnet.xyz` to `127.0.0.1` and `::1`
  - ℹ️ All containers should be reachable via `*.ao-localnet.xyz` domain names.
- ⚠️ Fully functional ArDrive Web (web interface)
  - ⏳ Known issues:
    - ℹ️ Arweave gateway port [bug](https://github.com/ardriveapp/arweave-dart/issues/59):
      - ✅ Fixed in [arweave-dart@v3.8.4](https://github.com/ardriveapp/arweave-dart/releases/tag/v3.8.4).
      - 💻 Hacked together by `grep | sed` replacing the dependency in `ardrive-web@v2.37.2`
      - 🙏 Hopefully fixed in the next version of [ArDrive Web](https://github.com/ardriveapp/ardrive-web).
    - ⚠️ ArDrive Web is using so-called "sandboxed urls" where it contacts the gateway on a subdomain that is
      the base32 encoded transaction id of the Arweave transaction.
      - _This_ can _be resolved by adding `127.0.0.1 *.localhost` to your `/etc/hosts` file._
      - _Probably will be fixed with DNS routing, see above._
    - ⚠️ Cannot upload files due to missing Payment Service.
      - _ArDrive Web doesn't respect its own configuration file setting: `"useTurboPayment": false`_
      - _Probably because
      [this class member](https://github.com/ardriveapp/ardrive-web/blob/v2.37.2/lib/turbo/services/payment_service.dart#L13)
      is hard coded?_
