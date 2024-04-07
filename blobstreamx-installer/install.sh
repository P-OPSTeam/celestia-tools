#! /bin/bash

# script to install blobstreamX prover/relayer

if [[ -z $1 || -z $2 || -z $3 ]]; then
    echo "./install.sh VERIFIER_BUILD HEADER_RANGE_EXPLORER_RELEASE_ID NEXT_HEADER_EXPLORER_RELEASE_ID"
    exit 1
fi

# ie verifier-build13.tar.gz
VERIFIER_BUILD=$1
# ie 33 in https://alpha.succinct.xyz/celestia/blobstreamx/releases/33
HEADER_RANGE_EXPLORER_RELEASE_ID=$2
NEXT_HEADER_EXPLORER_RELEASE_ID=$3

source $HOME/celestia-tools/blobstreamx-installer/.env.local

echo "Update apt and make sure required packages are installed"
sudo apt update
sudo apt install -y aria2 jq tree git build-essential libssl-dev pkg-config

echo
echo "Get HEADER_RANGE info from succinct explorer https://alpha.succinct.xyz/celestia/blobstreamx/releases/$HEADER_RANGE_EXPLORER_RELEASE_ID"
header_info_json=$(curl -s https://alpha.succinct.xyz/api/projects/celestia/blobstreamx/releases/$HEADER_RANGE_EXPLORER_RELEASE_ID)

hr_release_id=$(echo $header_info_json | jq -r .id)
hr_most_recent_function_id=$(echo "$header_info_json" | jq -r --arg CHAINID "$CHAINID" '.edges.deployments | map(select(.chain_id == ($CHAINID | tonumber))) | max_by(.updated_at) | .function_id')

echo
echo "Get NEXT_HEADER info from succinct explorer https://alpha.succinct.xyz/celestia/blobstreamx/releases/$NEXT_HEADER_EXPLORER_RELEASE_ID"
next_header_json=$(curl -s https://alpha.succinct.xyz/api/projects/celestia/blobstreamx/releases/$NEXT_HEADER_EXPLORER_RELEASE_ID)

nh_release_id=$(echo $next_header_json | jq -r .id)
nh_most_recent_function_id=$(echo "$next_header_json" | jq -r --arg CHAINID "$CHAINID" '.edges.deployments | map(select(.chain_id == ($CHAINID | tonumber))) | max_by(.updated_at) | .function_id')

echo "info obtained from succinct explorer:"
echo "- header range release id  : $hr_release_id"
echo "- header range function id : $hr_most_recent_function_id"
echo "- next header release id   : $nh_release_id"
echo "- next header function id  : $nh_most_recent_function_id"

if [[ -z $hr_release_id || -z $hr_most_recent_function_id || -z $nh_release_id || -z $nh_most_recent_function_id ]]; then
    echo "none of the 4 information above should be empty"
    exit 1
fi

echo
echo "clone blobstream project"
cd $HOME
git clone https://github.com/succinctlabs/blobstreamx
cd blobstreamx; mkdir artifacts; cd artifacts;

echo
echo "Download Verifier : $VERIFIER_BUILD"
aria2c -s14 -x14 -k100M https://public-circuits.s3.amazonaws.com/$VERIFIER_BUILD
echo
echo "Install Verifier : $VERIFIER_BUILD"
tar xzf $VERIFIER_BUILD

echo
echo "Download header range circuits files from $hr_release_id"
aria2c -s14 -x14 -k100M https://public-blobstreamx-circuits.s3.amazonaws.com/${hr_release_id}.tar.gz
echo
echo "Install header range"
tar xzf ${hr_release_id}.tar.gz
echo
echo "Determine header range folder and binary name"
hr_folder_name=$(find . -maxdepth 1 -type d \( -name "*range*" \))
hr_binary_name=$(basename $(find "$hr_folder_name" -type f \( -name "*range*" \) ! -name "._*"))
chmod +x ${hr_folder_name}/${hr_binary_name}

echo
echo "Download next header circuits files from $nh_release_id"
aria2c -s14 -x14 -k100M https://public-blobstreamx-circuits.s3.amazonaws.com/${nh_release_id}.tar.gz
echo
echo "Install next header"
tar xzf ${nh_release_id}.tar.gz
echo
echo "Determine next header folder and binary name"
nh_folder_name=$(find . -maxdepth 1 -type d \( -name "*next*" \))
nh_binary_name=$(basename $(find "$nh_folder_name" -type f \( -name "*next*" \) ! -name "._*"))
chmod +x ${nh_folder_name}/${nh_binary_name}

echo
echo "Update .env file"

cp $HOME/celestia-tools/blobstreamx-installer/.env.tpl $HOME/blobstreamx/.env

sed -i "s|<<PRIVATE_KEY>>|${PRIVATE_KEY}|g" $HOME/blobstreamx/.env
sed -i "s|<<RPC_URL>>|${RPC_URL}|g" $HOME/blobstreamx/.env
sed -i "s|<<TENDERMINT_RPC_URL>>|${TENDERMINT_RPC_URL}|g" $HOME/blobstreamx/.env
sed -i "s|<<CHAINID>>|${CHAINID}|g" $HOME/blobstreamx/.env
sed -i "s|<<CONTRACT_ADDRESS>>|${CONTRACT_ADDRESS}|g" $HOME/blobstreamx/.env
sed -i "s|<<0xNEXT_HEADER_FUNCTION_ID>>|${nh_most_recent_function_id}|g" $HOME/blobstreamx/.env
sed -i "s|<<0xHEADER_RANGE_FUNCTION_ID>>|${hr_most_recent_function_id}|g" $HOME/blobstreamx/.env
sed -i "s|<<PROVE_BINARY_NEXT_HEADER>>|\./artifacts/${nh_folder_name}/${nh_binary_name}|g" $HOME/blobstreamx/.env
sed -i "s|<<PROVE_BINARY_HEADER_RANGE>>|\./artifacts/${hr_folder_name}/${hr_binary_name}|g" $HOME/blobstreamx/.env
sed -i "s|<<WRAPPER_BINARY>>|${WRAPPER_BINARY}|g" $HOME/blobstreamx/.env

# docker needs to be installed before hand bash install-docker.sh
echo
echo "pull latest succinct-local-prover image"
docker pull succinctlabs/succinct-local-prover

echo
echo "Install rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y


source ~/.profile

echo "check $HOME/blobstreamx/.env see if all ok"
echo "then start proving and/or relaying with cargo run --bin blobstreamx --release"