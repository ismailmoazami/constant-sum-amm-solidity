
# Constant Sum Automated Market Maker (CSAMM)

This project implements a Constant Sum Automated Market Maker (CSAMM) smart contract in Solidity. The CSAMM is a type of decentralized exchange that maintains a constant sum of token reserves, offering a different approach to liquidity provision compared to traditional Constant Product AMMs like Uniswap.

## Features

- Swap tokens with a 0.3% fee
- Add liquidity to the pool
- Remove liquidity from the pool
- Supports any two ERC20 tokens

## Smart Contracts

- `ConstantSumAMM.sol`: The main contract implementing the CSAMM logic
- `Deploy.s.sol`: A deployment script for easy contract deployment

## Getting Started

### Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation.html)

### Installation

1. Clone the repository:
   ```
   git clone https://github.com/your-username/constant-sum-amm.git
   cd constant-sum-amm
   ```

2. Install dependencies:
   ```
   forge install
   ```

### Deployment

To deploy the contract:

1. Set up your environment variables:
   ```
   cp .env.example .env
   ```
   Edit `.env` and add your private key and RPC URL.

2. Run the deployment script:
   ```
   forge script script/Deploy.s.sol:Deploy --rpc-url $RPC_URL --broadcast --verify
   ```

## Usage

After deployment, you can interact with the contract using tools like `cast` or by writing your own scripts.

Example of swapping tokens:
```
cast send $CONTRACT_ADDRESS "swap(address,uint256)" $TOKEN_ADDRESS $AMOUNT
```

## License

This project is licensed under the MIT License.

