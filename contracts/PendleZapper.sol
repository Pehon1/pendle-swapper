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

    IERC20 internal usdc;
    IERC20 internal ausdc;
    IPendleRouter internal pendleRouter;

    // Commission rate is in thousands. for example, 1% is 1000, 0.1% is 100
    uint256 public commissionInThousands;

    ILendingPoolAddressesProvider internal addressesProvider;

    event Swapped(address swapper, uint256 amount);

    constructor(IERC20 _usdc, IERC20 _ausdc, ILendingPoolAddressesProvider _lendingPoolProvider, IPendleRouter _pendleRouter, uint256 _commissionInThousands) {
        usdc = _usdc;
        ausdc = _ausdc;
        addressesProvider = _lendingPoolProvider;
        pendleRouter = _pendleRouter;
        commissionInThousands = _commissionInThousands;
    }
    
    function setCommissionRate(uint256 _commissionInThousands) external onlyOwner {
        commissionInThousands = _commissionInThousands;
    }
    
    /**
    * Calculates the amount of commission to pay the owner of the contract, based on a input
    * amount
    */
    function commissionAmount(uint256 _tokenBigAmount) public view returns (uint256) {
        return _tokenBigAmount.mul(commissionInThousands).div(100000);
    }

    function getLendingPoolAddress() internal view returns (address) {
        return addressesProvider.getLendingPool();
    }

    function convertAmountToBigNumber(uint256 amount, IERC20 token) public view returns (uint256) {
        return amount.mul(10 ** token.decimals());
    }

    function usdcToPendleOTYT(uint256 amount) external {

        // get aave lending pool address
        ILendingPool lendingPool = ILendingPool(addressesProvider.getLendingPool() );

        // transfer from user to this contract
        usdc.transferFrom(msg.sender, address(this), convertAmountToBigNumber(amount, usdc));

        // calculate the commission and the amount to convert
        uint256 commissionFromAmount = commissionAmount(convertAmountToBigNumber(amount, usdc));
        uint256 amountToConvert = convertAmountToBigNumber(amount, usdc).sub(commissionFromAmount);

        require(
            convertAmountToBigNumber(amount, usdc).sub(commissionFromAmount.add(amountToConvert)) == 0,
            "Commission calculation failed."
        );

        // transfer commission to owner
        usdc.transfer(owner(), commissionFromAmount);

        // approve aave to use the money in this contract
        usdc.approve(address(lendingPool), amountToConvert);

        // deposit money into aave and receive aUSDC
        lendingPool.deposit(address(usdc), amountToConvert, address(this), 0);

        // approve pendle to take the aUSDC in this contract
        ausdc.approve(address(pendleRouter), amountToConvert);

        bytes32 forgeId  = "AaveV2";
        // tokenise the yield and send to the msg sender. Converts aUSDC to YT OT here
        pendleRouter.tokenizeYield(forgeId, address(usdc), 1672272000, amountToConvert, msg.sender);

        emit Swapped(msg.sender, amount);
    }
}