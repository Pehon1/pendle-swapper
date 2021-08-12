// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./ILendingPoolAddressesProvider.sol";
import "./ILendingPool.sol";
import "@pendle/core/contracts/interfaces/IPendleRouter.sol";

contract PendleZapper {

    /**
        Production contracts
        AUSDC YT Dec 2020 ERC20 https://etherscan.io/token/0xcdb5b940e95c8632decdc806b90dd3fc44e699fe?a=0x220d867a4b85f5b2da0a816f4b2ec5a41e712ade#readContract
        Pendle compound forge https://etherscan.io/address/0xc02aC197a4D32D93D473779Fbea2DCA1fb313eD5#code
        aave deposit contract https://etherscan.io/address/0x7d2768dE32b0b80b7a3454c06BdAc94A69DDc7A9#code

        Kovan
        aave addresses https://docs.aave.com/developers/deployed-contracts/deployed-contracts
        aave pool address 0xE0fBa4Fc209b4948668006B2bE61711b7f465bAe
        pool address provider 0x88757f2f99175387aB4C6a4b3067c77A695b0349
        usdc  0xe22da380ee6B445bb8273C81944ADEB6E8450422
        ausdc 0xe12AFeC5aa12Cf614678f9bFeeB98cA9Bb95b5B0
        https://docs.aave.com/developers/the-core-protocol/lendingpool
        PendleRouter 0x85dB6E6eDb8EC6DFeC222B80A54Cc7b42F59671e
        Forge Id is simply byte32 of https://github.com/pendle-finance/pendle-core/blob/38e040b93113a5a8d3814ec814e4188627d92b9a/deployments/kovan.json#L105

        Ropsten 
        USDC 0x07865c6e87b9f70255377e024ace6630c1eaa37f 
        ausdc 0x8d939db4c106713600d5e66100ae4156418981a2
        Pool address provider 0x1c8756FD2B28e9426CDBDcC7E3c4d64fa9A54728

        byte32 https://web3-type-converter.onbrn.com/


        Kovan contract deployed at 0xD859076DA1FA48393f3a21680A902FEFC39802c6

        Gas cost at 40gwei is 0.0168552eth or $52
     */

    IERC20 public usdc = IERC20(address(0xe22da380ee6B445bb8273C81944ADEB6E8450422));
    IERC20 public ausdc = IERC20(address(0xe12AFeC5aa12Cf614678f9bFeeB98cA9Bb95b5B0));
    IPendleRouter public pendleRouter = IPendleRouter(address(0x85dB6E6eDb8EC6DFeC222B80A54Cc7b42F59671e));

    ILendingPoolAddressesProvider public constant addressesProvider = ILendingPoolAddressesProvider(address(0x88757f2f99175387aB4C6a4b3067c77A695b0349));

    ILendingPool public aaveLendingPool;

    function getLendingPoolAddress() public view returns (address) {
        return addressesProvider.getLendingPool();
    }

    function msgSender() external view returns (address) {
        return msg.sender;
    }

    function thisAddress() external view returns (address) {
        return address(this);
    }

    function transferFrom(uint256 amount) external {
        usdc.transferFrom(msg.sender, address(this), amount);
    }

    function approval(uint256 amount) external {
        usdc.approve(getLendingPoolAddress(), amount);
    }

    function deposit(uint256 amount) external {
        ILendingPool lendingPool = ILendingPool(getLendingPoolAddress());
        lendingPool.deposit(address(usdc), amount, address(this), 0);
    }

    function austTransfer(uint256 amount) external {
        ausdc.transfer(msg.sender, amount);
    }

    function usdcToPendleOTYT(uint256 amount) external {
        // get aave lending pool address
        ILendingPool lendingPool = ILendingPool(
            addressesProvider.getLendingPool()
        );

        // transfer from user to this contract
        usdc.transferFrom(msg.sender, address(this), amount);

        // approve aave to use the money in this contract
        usdc.approve(address(lendingPool), amount);

        // deposit money into aave and receive aUSDC
        lendingPool.deposit(address(usdc), amount, address(this), 0);

        // approve pendle to take the aUSDC in this contract
        ausdc.approve(address(pendleRouter), amount);

        bytes32 forgeId = "AaveV2";
        // tokenise the yield and send to the message sender. 
        pendleRouter.tokenizeYield(forgeId, address(usdc), 1672272000, amount, msg.sender);
    }
}