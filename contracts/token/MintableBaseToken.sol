// SPDX-License-Identifier: MIT

pragma solidity 0.8.28;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "./BaseToken.sol";
import "./interface/IMintable.sol";

contract MintableBaseToken is BaseToken, ERC20Capped, IMintable {
    uint8 public mintersCount;
    mapping(address => bool) public override isMinter;
    mapping(address => bool) public blacklists;

    event SetMinterRole(address indexed caller, address indexed recipient);
    event RevokeMinterRole(address indexed caller, address indexed recipient);
    event SetBlacklist(address indexed account, bool isBlacklist, string reason);

    modifier onlyMinter() {
        require(isMinter[msg.sender], "Not minter role");
        _;
    }

    modifier notBlacklist() {
        require(!blacklists[msg.sender], "Blacklist");
        _;
    }

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _maxSupply,
        uint256 _initialSupply
    ) BaseToken(_name, _symbol, _initialSupply) ERC20Capped(_maxSupply) {
        //Reserve constructor logic
    }

    function mint(address _account, uint256 _amount) external onlyMinter override {
        _mint(_account, _amount);
    }

    function setMinter(address _minter) external override onlyOwner {
        require(!isMinter[_minter], "Already minter");
        isMinter[_minter] = true;
        mintersCount += 1;
        emit SetMinterRole(msg.sender, _minter);
    }

    function revokeMinter(address _minter) external override onlyOwner {
        require(isMinter[_minter], "MintableBaseToken: Not minter");
        isMinter[_minter] = false;
        mintersCount -= 1;
        emit RevokeMinterRole(msg.sender, _minter);
    }

    /**
    * @dev Allow the owner to set the suspected account to blacklist.
    */
    function setBlacklist(
        address _account, 
        bool _isBlacklist, 
        string memory _reason
    ) external onlyOwner {
        blacklists[_account] = _isBlacklist;
        emit SetBlacklist(
            _account,
            _isBlacklist,
            _reason
        );
    }

    /**
    * @dev ERC20 internal wrapped function to replace _beforeTokenTransfer.
    * All normal functions transfer/approve,... will work normally if match conditions `whenNotPaused` and `notBlacklist`.
    */
    function _update(address from, address to, uint256 value) internal virtual override (ERC20, ERC20Capped) whenNotPaused notBlacklist {
        return ERC20Capped._update(
            from,
            to,
            value
        );
    }
}

