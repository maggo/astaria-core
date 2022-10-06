pragma solidity ^0.8.16;

import "forge-std/Test.sol";

import {Authority} from "solmate/auth/Auth.sol";
import {MultiRolesAuthority} from "solmate/auth/authorities/MultiRolesAuthority.sol";
import {ERC721} from "gpl/ERC721.sol";
//import {CollateralToken, IFlashAction} from "../../CollateralToken.sol";
//import {ICollateralToken} from "../../interfaces/ICollateralToken.sol";
import {MockERC721} from "solmate/test/utils/mocks/MockERC721.sol";
import {IAstariaRouter, AstariaRouter} from "../../AstariaRouter.sol";
import {AuctionHouse} from "gpl/AuctionHouse.sol";
import {IAuctionHouse} from "gpl/interfaces/IAuctionHouse.sol";
import {Strings2} from "./utils/Strings2.sol";
import {IVault, VaultImplementation} from "../../VaultImplementation.sol";
import {FixedPointMathLib} from "solmate/utils/FixedPointMathLib.sol";
import {SafeCastLib} from "gpl/utils/SafeCastLib.sol";

import "./TestHelpers2.t.sol";

contract AstariaTest2 is TestHelpers {
    using FixedPointMathLib for uint256;
    using CollateralLookup for address;
    using SafeCastLib for uint256;

    function testBasicPublicVaultLoan() public {
        Dummy721 nft = new Dummy721();
        address tokenContract = address(nft);
        uint256 tokenId = uint256(1);

        uint256 initialBalance = WETH9.balanceOf(address(this));

        address publicVault =
            _createPublicVault({strategist: strategistOne, delegate: strategistTwo, epochLength: 14 days});

        _lendToVault(Lender({addr: address(1), amountToLend: 50 ether, lendingDuration: 0 days}), publicVault);

        _commitToLien({
            vault: publicVault,
            strategist: strategistOne,
            strategistPK: strategistOnePK,
            tokenContract: tokenContract,
            tokenId: tokenId,
            lienDetails: IAstariaRouter.LienDetails({
                maxAmount: 50 ether,
                rate: ((uint256(0.05 ether) / 365) * 1 days),
                duration: uint256(block.timestamp + 10 days),
                maxPotentialDebt: 50 ether
            }),
            amount: 10 ether
        });
    }

    function testBasicPrivateVaultLoan() public {}
}
