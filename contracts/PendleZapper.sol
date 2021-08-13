// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./ILendingPoolAddressesProvider.sol";
import "./ILendingPool.sol";
import "@pendle/core/contracts/interfaces/IPendleRouter.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PendleZapper is Ownable {

    IERC20 public usdc = IERC20(address(0xe22da380ee6B445bb8273C81944ADEB6E8450422));
    IERC20 public ausdc = IERC20(address(0xe12AFeC5aa12Cf614678f9bFeeB98cA9Bb95b5B0));
    IPendleRouter public pendleRouter = IPendleRouter(address(0x85dB6E6eDb8EC6DFeC222B80A54Cc7b42F59671e));

    ILendingPoolAddressesProvider public addressesProvider = ILendingPoolAddressesProvider(address(0x88757f2f99175387aB4C6a4b3067c77A695b0349));

    event Swapped(address swapper, uint256 amount);

    constructor(IERC20 _usdc, IERC20 _ausdc, ILendingPoolAddressesProvider _lendingPoolProvider, IPendleRouter _pendleRouter) {
        usdc = _usdc;
        ausdc = _ausdc;
        addressesProvider = _lendingPoolProvider;
        pendleRouter = _pendleRouter;
    }

    function getLendingPoolAddress() internal view returns (address) {
        return addressesProvider.getLendingPool();
    }

    function convertAmountToBigNumber(uint256 amount, IERC20 token) internal view returns (uint256) {
        return amount * token.decimals();
    }

    function usdcToPendleOTYT(uint256 amount) external {

        // get aave lending pool address
        ILendingPool lendingPool = ILendingPool(addressesProvider.getLendingPool() );

        // transfer from user to this contract
        usdc.transferFrom(msg.sender, address(this), convertAmountToBigNumber(amount, usdc));

        // approve aave to use the money in this contract
        usdc.approve(address(lendingPool), convertAmountToBigNumber(amount, usdc));

        // deposit money into aave and receive aUSDC
        lendingPool.deposit(address(usdc), convertAmountToBigNumber(amount, usdc), address(this), 0);

        // approve pendle to take the aUSDC in this contract
        ausdc.approve(address(pendleRouter), convertAmountToBigNumber(amount, ausdc));

        bytes32 memory forgeId  = "AaveV2";
        // tokenise the yield and send to the msg sender. Converts aUSDC to YT OT here
        pendleRouter.tokenizeYield(forgeId, address(usdc), 1672272000, convertAmountToBigNumber(amount, ausdc), msg.sender);

        emit Swapped(msg.sender, amount);
    }
}