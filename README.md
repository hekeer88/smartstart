# New Year Resolution Contracts

## Overview
This repository contains two Solidity smart contracts, `MakePromise` and `NewYearPromise`, designed for creating, managing, and participating in New Year promises.

## Contracts

### MakePromise
- **Purpose**: Allows users to create new promises with specific parameters such as name, description, participation amount, and maximum allowed mistakes.
- **Key Features**:
  - Creation of new promises.
  - Mapping of promises to their creators.
  - Validation and distribution functions, restricted to the contract owner.

### NewYearPromise
- **Purpose**: Manages individual promises, including participant management and balance tracking.
- **Key Features**:
  - Joining promises with a required participation amount.
  - Participant validation and removal mechanisms.
  - Distribution of promise cash, with conditions for eligibility and even distribution among participants.

## How to Use
1. **Clone the Repository**: Use Git to clone this repository to your local machine.
2. **Deploy Contracts**: Deploy these contracts on a Solidity supported blockchain (like Ethereum).
3. **Interact with Contracts**: Interact with the contracts through a blockchain interface or a custom frontend.

## Requirements
- Solidity ^0.8.0
- Blockchain environment for deployment (like Ethereum Mainnet or Testnet)

## License
- The project is licensed under the MIT License.
