# Pendle Swapper

## Purpose

The purpose of this contract is to simplify the process of converting USDC to Pendle.Finance's OT-YTs

## Disclaimer

The project is unaudited, and very much in beta. No warranties. Use at your own risk. 

## Roadmap

- [x] Deployment to testnet 
- [ ] Web3 front end
- [ ] Deployment to mainnet
- [ ] USDC to OT and YT Farms
- [ ] USDC to (OT and YT) to (OT and USDC) to (OT and OT)

## Gas studies

A typical swap from USDC all the way to OT and YT would typically take

46,108 GAS (Approval AAVE) + 187,493 (Deposit to AAVE) + 48,897 (Approval aUSDC) + 382,690 (Tokenize at Pendle) = 665,188 GAS

A typical swap on this contract would only take

46,108 GAS (approval) + 424,746 (transaction) = 470,854 GAS

**Using this contract to swap USDC into OT YT saves you ~30% in gas fees.**

## Beta deployment

Beta contracts has deployed on Kovan for the following gas studies. The second variant won. 

This version requires message senders to help this contract get approval from spenders to spend.
Construction - 1,363,051 GAS
Gas used for swap - 438,334 GAS
[initial](https://kovan.etherscan.io/address/0xb101a17cb148290d45a05185ee43dc4f1363f434). 

This contract gets approval for unlimited amounts at contract contruction, to save on gas fees
Construction - 1,347,666 GAS
Gas used for swap - 427,827
[approval at construction](https://kovan.etherscan.io/address/0x4a20e823fb481664fed9927ac3025910efb1ebe4)

Predeployment contract has been doloyed here on Kovan
[pre-release](https://kovan.etherscan.io/address/0x9F6cec1B7bdD7B4fB2fe13637175aF2331Fc8020)

