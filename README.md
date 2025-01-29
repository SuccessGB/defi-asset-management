# DeFi Asset Management Platform

A robust smart contract platform built on Stacks blockchain for managing digital assets, tracking token prices, and handling secure transfers.

## Features

- Token Management
  - Mint new tokens with customizable properties
  - Track token prices with historical data
  - Set maximum supply limits
  - Categorize tokens for better organization

- Asset Transfer System
  - Direct token transfers between addresses
  - Delegated transfer support (authorize others to spend)
  - Balance tracking for all token holders
  - Built-in allowance management

- Security Features
  - Administrative controls
  - Comprehensive error handling
  - Input validation
  - Secure price update mechanism

## Smart Contract Functions

### Administrative Functions

- `mint-token`: Create new tokens with specified properties
- `update-token-price`: Update token prices with historical tracking
- `set-contract-admin`: Transfer administrative rights

### User Functions

- `transfer`: Direct token transfer between addresses
- `authorize-spending`: Delegate spending rights to other addresses
- `transfer-as-authorized`: Transfer tokens as an authorized spender

### Read-Only Functions

- `get-token-details`: Retrieve token information
- `get-holder-balance`: Check token balance for any address
- `get-price-at-time`: Get historical price data
- `get-authorized-amount`: Check spending allowances

## Error Handling

The contract includes comprehensive error handling for all operations:

- Authentication errors
- Token validation errors
- Balance/allowance checks
- Input validation errors
- Transfer restrictions

## Getting Started

1. Deploy the contract to the Stacks blockchain
2. Initialize the contract with an admin address
3. Begin minting tokens and managing assets

## Security Considerations

- Only the contract admin can mint tokens and update prices
- Transfer functions include balance validation
- Authorized spending requires explicit permission
- Price history is immutably stored on-chain

## Development

Built using Clarity, the smart contract language for the Stacks blockchain. Ensure you have the following:

- Stacks blockchain environment
- Clarity CLI tools
- Testing framework for Clarity contracts

