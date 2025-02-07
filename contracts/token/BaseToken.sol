// SPDX-License-Identifier: MIT

pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract BaseToken is ERC20Burnable, Pausable, Ownable {
    using SafeERC20 for IERC20;
    
    event WithdrawToken(address indexed caller, address indexed indexToken, address indexed recipient, uint256 amount);

    constructor(
        string memory _name, 
        string memory _symbol, 
        uint256 _initialSupply
    ) ERC20(_name, _symbol) Ownable(msg.sender) {
        if (_initialSupply > 0) {
            _mint(msg.sender, _initialSupply);
        }
    }

    /**
    * @dev Allow owner withdraw stucked token in contract with a specific amount.
    */
    function withdrawToken(address _token, address _account, uint256 _amount) external onlyOwner {
        require(IERC20(_token).balanceOf(address(this)) >= _amount, "Insufficient");
        _withdrawToken(
            _token, 
            _account, 
            _amount
        );
    }

    /**
    * @dev Allow owner withdraw all stucked token in contract.
    */
    function withdrawToken(address _token, address _account) external onlyOwner {
        uint256 available = IERC20(_token).balanceOf(address(this));
        require(available > 0, "Zero");
        _withdrawToken(
            _token,
            _account,
            available
        );
    }

    function _withdrawToken(
        address _token, 
        address _account, 
        uint256 _amount
    ) internal {
        IERC20(_token).safeTransfer(_account, _amount);
        emit WithdrawToken(msg.sender, _token, _account, _amount);
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }
}
