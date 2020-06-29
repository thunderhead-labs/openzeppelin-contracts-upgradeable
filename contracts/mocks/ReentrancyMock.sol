// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "../utils/ReentrancyGuard.sol";
import "./ReentrancyAttack.sol";
import "../Initializable.sol";

contract ReentrancyMockUpgradeSafe is Initializable, ReentrancyGuardUpgradeSafe {
    uint256 public counter;


    constructor() public  {
        __ReentrancyMock_init();
    }

    function __ReentrancyMock_init() internal initializer {
        __ReentrancyGuard_init_unchained();
        __ReentrancyMock_init_unchained();
    }

    function __ReentrancyMock_init_unchained() internal initializer {


        counter = 0;

    }


    function callback() external nonReentrant {
        _count();
    }

    function countLocalRecursive(uint256 n) public nonReentrant {
        if (n > 0) {
            _count();
            countLocalRecursive(n - 1);
        }
    }

    function countThisRecursive(uint256 n) public nonReentrant {
        if (n > 0) {
            _count();
            // solhint-disable-next-line avoid-low-level-calls
            (bool success,) = address(this).call(abi.encodeWithSignature("countThisRecursive(uint256)", n - 1));
            require(success, "ReentrancyMock: failed call");
        }
    }

    function countAndCall(ReentrancyAttackUpgradeSafe attacker) public nonReentrant {
        _count();
        bytes4 func = bytes4(keccak256("callback()"));
        attacker.callSender(func);
    }

    function _count() private {
        counter += 1;
    }

    uint256[49] private __gap;
}
