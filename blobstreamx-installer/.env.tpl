# Ethereum config
PRIVATE_KEY=<<PRIVATE_KEY>>
RPC_URL=<<RPC_URL>>

# Tendermint config. Accepts comma separated list of RPC URLs for failover.
TENDERMINT_RPC_URL=<<TENDERMINT_RPC_URL>>

# Operator script config
SUCCINCT_RPC_URL=local
SUCCINCT_API_KEY=
CHAIN_ID=<<CHAINID>>
CONTRACT_ADDRESS=<<CONTRACT_ADDRESS>>
NEXT_HEADER_FUNCTION_ID=<<0xNEXT_HEADER_FUNCTION_ID>>
HEADER_RANGE_FUNCTION_ID=<<0xHEADER_RANGE_FUNCTION_ID>>

# Optional from here on. Only add to `.env` if you want to do local proving.
# Set both to true if you want to do local proving and relaying.
LOCAL_PROVE_MODE=true
LOCAL_RELAY_MODE=true
# Add the path to each binary (ex. PROVE_BINARY_0x6d...=blobstream-artifacts/header_range)
PROVE_BINARY_<<0xNEXT_HEADER_FUNCTION_ID>>="<<PROVE_BINARY_NEXT_HEADER>>"
PROVE_BINARY_<<0xHEADER_RANGE_FUNCTION_ID>>="<<PROVE_BINARY_HEADER_RANGE>>"
# actually a folder to the binary
WRAPPER_BINARY="<<WRAPPER_BINARY>>"