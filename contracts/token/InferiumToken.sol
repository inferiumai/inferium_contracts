// SPDX-License-Identifier: MIT

pragma solidity ^0.8.28;

import "./MintableBaseToken.sol";

contract InferiumToken is MintableBaseToken {
    uint256 public constant MAX_SUPPLY = 250_000_000 * 10**18;

    constructor() MintableBaseToken("Inferium", "IFR", MAX_SUPPLY, 0) {
        //Reserve constructor logic
    }
}
