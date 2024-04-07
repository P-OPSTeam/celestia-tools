# P-OPS BlobstreamX installer

Thanks to the succinct team to help out with the blobstream installation, here is the blobstreamx installer script.

# Prereq

Tested and installed with the below

## Hardware

AWS instance r6x.8xlarge (or 32vcpu	256GiB Ram) + 150 GB ebs gp2

## OS

ubuntu 22

## Software

docker, rust

## Relay
your relayer address will need to be whitelisted

# Install steps

# Info gathering

## Succinct Explorer Release ID
Get the explorer release ID of both header range/next header release by looking at the URL column in the the table there : https://hackmd.io/@succinctlabs/HJE7XRrup#Download-Blobstream-X-Plonky2x-Circuits

> ie 33 in https://alpha.succinct.xyz/celestia/blobstreamx/releases/33

## Verifier build
Confirm the verifier build tar.gz https://hackmd.io/@succinctlabs/HJE7XRrup#Download-Verifier-Groth16-Wrapper-Circuit

> ie verifier-build13.tar.gz

## Install

### Clone repo

```bash
git clone https://github.com/P-OPSTeam/celestia-tools.git
cd celestia-tools/blobstreamx-installer
```

### Copy and edit .env.local

```bash
cp .env.local.example .env.local
```
use your favorite editor to edit .env.local

> .env.local variable will be sourced by the script

### Install docker

```bash
bash install-docker.sh
```

logout, login back to your instance and come back to the installer directory

```bash
cd celestia-tools/blobstreamx-installer
```

### Install blobstreamx

```bash
bash install.sh <verfier-buildXX.tar.gz> <HEADER_RANGE_EXPLORER_RELEASE_ID> <NEXT_HEADER_EXPLORER_RELEASE_ID>
```

> as of April 7: bash install.sh verifier-build13.tar.gz 36 35

### check your ~/blobstreamx/.env is good

you should have something similar to the below for the arbitrum sepolia

```
# Relayer private key
PRIVATE_KEY=<YOUR PRIVATE KEY>
# Chainid of the chain the proof are supposed to be submitted to
CHAINID=421614
RPC_URL=https://arbitrum-sepolia.blockpi.network/v1/rpc/public
TENDERMINT_RPC_URL=https://rpc-mocha.pops.one
CONTRACT_ADDRESS=0xc3e209eb245Fd59c8586777b499d6A665DF3ABD2

# update the below accorindgly to the expected binary downloaded from the release
#PROVE_BINARY_NEXT_HEADER="./artifacts/next-header-mocha/next_header_mocha"
#PROVE_BINARY_HEADER_RANGE="./artifacts/header-range-mocha/header_range_mocha"
WRAPPER_BINARY="./artifacts/verifier-build"
```

### run the prover/relayer

```bash
cargo run --bin blobstreamx --release
```