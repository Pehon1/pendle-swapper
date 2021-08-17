# Pendle Swapper

## Purpose

The purpose of this contract is to simplify the process of converting USDC to Pendle.Finance's OT-YTs

## Disclaimer

The project is unaudited, and very much in beta. No warranties. Use at your own risk. 

## Fees

The contract is set up to charge a small **0.1%** fee. I'll adjust this fee based on feedback. So please send feedback to me!

## Contract 

Mainnet deployment can be found at [0xb6B32CE1E0aCD9045C722bE3377Df15bc0611F51](https://etherscan.io/address/0xb6B32CE1E0aCD9045C722bE3377Df15bc0611F51)

## Contribute

Thanks for offering to help. You are welcomed to fork this repo, make your changes and submit a pull request. 

If you like to send some tokens, please send them to 0x220d867A4B85F5B2dA0A816F4B2eC5A41E712Ade

## Roadmap

- [x] Deployment to testnet 
- [x] Web3 front end
- [x] Deployment to mainnet
- [ ] DAI to OT and YT
- [ ] USDC to OT and YT Farms
- [ ] DAI to OT and YT Farms
- [ ] USDC to (OT and YT) to (OT and USDC) to (OT and OT)
- [ ] DAI to (OT and YT) to (OT and USDC) to (OT and OT)

## Gas comparisons

A typical swap from USDC all the way to OT and YT would typically take

46,108 GAS (Approval USDC) + 251,993 (Deposit to AAVE) + 48,897 (Approval aUSDC) + 382,690 (Tokenize at Pendle) = 729,688 GAS ~0.0364844ETH ~ USD110

A typical swap on this contract would only take

46,108 GAS (Approval USDC) + 424,746 (Tokenize at Pendle) = 470,854 GAS ~ 0.0235427ETH ~ USD70

**Using this contract to swap USDC into OT YT saves you >30% in gas fees.**

We assumed 50GWEI and ETH at USD$3,000 for the above comparisons. 

## Beta deployment

Predeployment on Kova can be found here.
[pre-release](https://kovan.etherscan.io/address/0x9F6cec1B7bdD7B4fB2fe13637175aF2331Fc8020)

