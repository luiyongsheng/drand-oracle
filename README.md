# drand-oracle

On-chain oracle for verifying [drand](https://drand.love/) evmnet randomness beacons on any EVM chain.

Smart contracts can pull drand randomness immediately on-chain — no waiting for off-chain services to report back. Anyone can submit a drand round signature, and the contract verifies it using BLS signature verification over BN254 (via the EVM pairing precompile). Once verified, the derived randomness (`sha256` of the signature) is stored and available for any contract to read.

## Features

- **Trustless verification** — BLS signatures are verified on-chain against the drand evmnet public key. No off-chain trust assumptions.
- **Permissionless submission** — anyone can submit a valid drand round to advance the oracle.
- **Deterministic deployment** — deploys to the same address on every EVM chain via CREATE2.
- **Historical lookups** — randomness is stored per round, so contracts can query any previously verified round.

## Architecture

```
drand evmnet beacon
        │
        ▼
  ┌─────────────┐   signature + round   ┌────────────────┐
  │  Relayer    │ ───────────────────▶  │  DrandOracle   │
  │  (anyone)   │                       │  (on-chain)    │
  └─────────────┘                       └───────┬────────┘
                                                │
                                    BLS.verifySingle()
                                    (BN254 pairing precompile)
                                                │
                                                ▼
                                         roundRandomness[round]
                                         = sha256(signature)
```

## Deployments

DrandOracle is deployed via CREATE2 at the same address on every chain:

**`0x08366085a9fF9a5870F3cEbD9Fc2AF456572783C`**

**Mainnets**

| Network      | Chain ID | Explorer                                                                                                      |
| ------------ | -------- | ------------------------------------------------------------------------------------------------------------- |
| Optimism     | 10       | [optimistic.etherscan.io](https://optimistic.etherscan.io/address/0x08366085a9fF9a5870F3cEbD9Fc2AF456572783C) |
| Arbitrum One | 42161    | [arbiscan.io](https://arbiscan.io/address/0x08366085a9fF9a5870F3cEbD9Fc2AF456572783C)                         |
| Base         | 8453     | [basescan.org](https://basescan.org/address/0x08366085a9fF9a5870F3cEbD9Fc2AF456572783C)                       |
| Polygon      | 137      | [polygonscan.com](https://polygonscan.com/address/0x08366085a9fF9a5870F3cEbD9Fc2AF456572783C)                 |
| BNB Chain    | 56       | [bscscan.com](https://bscscan.com/address/0x08366085a9fF9a5870F3cEbD9Fc2AF456572783C)                         |
| MegaETH      | 4326     | [megaeth.blockscout.com](https://megaeth.blockscout.com/address/0x08366085a9fF9a5870F3cEbD9Fc2AF456572783C)   |

**Testnets**

| Network          | Chain ID | Explorer                                                                                                                       |
| ---------------- | -------- | ------------------------------------------------------------------------------------------------------------------------------ |
| Ethereum Sepolia | 11155111 | [sepolia.etherscan.io](https://sepolia.etherscan.io/address/0x08366085a9fF9a5870F3cEbD9Fc2AF456572783C)                        |
| Base Sepolia     | 84532    | [sepolia.basescan.org](https://sepolia.basescan.org/address/0x08366085a9fF9a5870F3cEbD9Fc2AF456572783C)                        |
| BNB Testnet      | 97       | [testnet.bscscan.com](https://testnet.bscscan.com/address/0x08366085a9fF9a5870F3cEbD9Fc2AF456572783C)                          |
| MegaETH Testnet  | 6343     | [megaeth-testnet-v2.blockscout.com](https://megaeth-testnet.blockscout.com/address/0x08366085a9fF9a5870F3cEbD9Fc2AF456572783C) |

> Deploying to a new chain? The same address is guaranteed — see [Deploy](#deploy).

## Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation)

## Getting Started

```bash
git clone --recurse-submodules https://github.com/luiyongsheng/drand-oracle.git
cd drand-oracle
forge build
```

## Usage

### Build

```bash
forge build
```

### Test

```bash
forge test -vvv
```

### Format

```bash
forge fmt
```

### Deploy

The deploy script uses CREATE2 with a fixed salt, producing the same contract address on every chain.

```bash
forge script script/Deploy.s.sol \
  --rpc-url <RPC_URL> \
  --broadcast
```

### Verify on Etherscan

```bash
forge verify-contract <DEPLOYED_ADDRESS> src/DrandOracle.sol:DrandOracle \
  --chain-id <CHAIN_ID> \
  --etherscan-api-key <API_KEY>
```

## Contract Interface

### `updateRound(uint64 round, bytes signature)`

Verifies a drand BLS signature and stores the derived randomness. Reverts if the round is not newer than the current latest, or if the signature is invalid.

### `getLatestRandomness() → (uint64 round, bytes32 randomness)`

Returns the most recently verified round and its randomness value.

### `roundRandomness(uint64 round) → bytes32`

Returns the randomness for any previously verified round (or `bytes32(0)` if not yet submitted).

## Dependencies

| Dependency                                               | Purpose                                              |
| -------------------------------------------------------- | ---------------------------------------------------- |
| [bls-solidity](https://github.com/randa-mu/bls-solidity) | BLS signature verification & hash-to-curve for BN254 |
| [forge-std](https://github.com/foundry-rs/forge-std)     | Foundry standard library                             |

## License

[MIT](LICENSE)
