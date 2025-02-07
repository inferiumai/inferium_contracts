// SPDX-License-Identifier: MIT

pragma solidity ^0.8.28;

interface IMintable {
    function mint(address _account, uint256 _amount) external;

    function setMinter(address _minter) external;

    function revokeMinter(address _minter) external;

    function isMinter(address _account) external returns (bool);
}
