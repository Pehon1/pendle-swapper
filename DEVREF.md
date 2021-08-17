
        Production contracts
        AUSDC YT Dec 2020 ERC20 https://etherscan.io/token/0xcdb5b940e95c8632decdc806b90dd3fc44e699fe?a=0x220d867a4b85f5b2da0a816f4b2ec5a41e712ade#readContract
        Pendle compound forge https://etherscan.io/address/0xc02aC197a4D32D93D473779Fbea2DCA1fb313eD5#code
        aave deposit contract https://etherscan.io/address/0x7d2768dE32b0b80b7a3454c06BdAc94A69DDc7A9#code


Deployment arguements
0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, 0xBcca60bB61934080951369a648Fb03DF4F96263C,0xB53C1a33016B2DC2fF3653530bfF1848a515c8c5,0x1b6d3E5Da9004668E14Ca39d1553E9a46Fe842B3,100
        

        Kovan
        aave addresses https://docs.aave.com/developers/deployed-contracts/deployed-contracts
        aave pool address 0xE0fBa4Fc209b4948668006B2bE61711b7f465bAe
        pool address provider 0x88757f2f99175387aB4C6a4b3067c77A695b0349
        usdc  0xe22da380ee6B445bb8273C81944ADEB6E8450422
        ausdc 0xe12AFeC5aa12Cf614678f9bFeeB98cA9Bb95b5B0
        https://docs.aave.com/developers/the-core-protocol/lendingpool
        PendleRouter 0x85dB6E6eDb8EC6DFeC222B80A54Cc7b42F59671e
        Forge Id is simply byte32 of https://github.com/pendle-finance/pendle-core/blob/38e040b93113a5a8d3814ec814e4188627d92b9a/deployments/kovan.json#L105


        Kovan Deployment contract arugments
        0xe22da380ee6B445bb8273C81944ADEB6E8450422, 0xe12AFeC5aa12Cf614678f9bFeeB98cA9Bb95b5B0, 0x88757f2f99175387aB4C6a4b3067c77A695b0349, 0x85dB6E6eDb8EC6DFeC222B80A54Cc7b42F59671e, 100


        Ropsten 
        USDC 0x07865c6e87b9f70255377e024ace6630c1eaa37f 
        ausdc 0x8d939db4c106713600d5e66100ae4156418981a2
        Pool address provider 0x1c8756FD2B28e9426CDBDcC7E3c4d64fa9A54728

        byte32 https://web3-type-converter.onbrn.com/


        No commission Kovan contract deployed at 0x5e267046E94a4572081d66813dF664928c69023F

        commissioned contract is here
        0x9eC7660E23e7E691390c370A7E5510a992CEbEbE


        Gas cost at 40gwei is 0.0168552eth or $52
    This version requires message senders to help this contract get approval from spenders to spend.
Construction - 1,363,051 GAS
Gas used for swap - 438,334 GAS
[initial](https://kovan.etherscan.io/address/0xb101a17cb148290d45a05185ee43dc4f1363f434). 

This contract gets approval for unlimited amounts at contract contruction, to save on gas fees
Construction - 1,347,666 GAS
Gas used for swap - 427,827
[approval at construction](https://kovan.etherscan.io/address/0x4a20e823fb481664fed9927ac3025910efb1ebe4)