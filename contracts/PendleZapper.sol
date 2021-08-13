// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ILendingPool.sol";
import "./ILendingPoolAddressesProvider.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@pendle/core/contracts/interfaces/IPendleRouter.sol";

contract PendleZapper is Ownable {

    using SafeMath for uint256;

    IERC20 public usdc;
    IERC20 public ausdc;
    IPendleRouter public pendleRouter;

    ILendingPoolAddressesProvider public addressesProvider;

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
        return amount.mul(10 ** token.decimals());
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

        bytes32 forgeId  = "AaveV2";
        // tokenise the yield and send to the msg sender. Converts aUSDC to YT OT here
        pendleRouter.tokenizeYield(forgeId, address(usdc), 1672272000, convertAmountToBigNumber(amount, ausdc), msg.sender);

        emit Swapped(msg.sender, amount);
    }
}