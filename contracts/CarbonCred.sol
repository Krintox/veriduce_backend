// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract OneTimeSaleToken is ERC20, Ownable {
    uint256 public salePrice;
    string public metaData;
    address public payoutAddress;
    mapping(address => uint256) public purchasedTokens;

    event TokensPurchased(address indexed buyer, uint256 amount);
    event TokensBurned(address indexed burner, uint256 amount, string metaData);

    constructor(
        string memory name,
        string memory symbol,
        uint256 initialSupply,
        uint256 _salePrice,
        string memory _metaData,
        address _payoutAddress
    ) ERC20(name, symbol) Ownable(msg.sender) { // ✅ Pass msg.sender to Ownable
        _mint(msg.sender, initialSupply * 10**decimals());
        salePrice = _salePrice;
        metaData = _metaData;
        payoutAddress = _payoutAddress;
    }

    function buyToken(uint256 amount) external payable {
        require(msg.value == amount * salePrice, "Incorrect Ether value sent");
        require(balanceOf(owner()) >= amount, "Not enough tokens available for sale");

        _transfer(owner(), msg.sender, amount);
        purchasedTokens[msg.sender] += amount;
        payable(payoutAddress).transfer(msg.value);

        emit TokensPurchased(msg.sender, amount);
    }

    function burnToken(uint256 amount) external {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance to burn");

        _burn(msg.sender, amount);
        emit TokensBurned(msg.sender, amount, metaData);
    }

    function getUnsoldTokens() external view returns (uint256) {
        return balanceOf(owner());
    }

    function getPurchasedTokens(address account) external view returns (uint256) {
        return purchasedTokens[account];
    }

    function mint(uint256 amount) external onlyOwner {
        _mint(owner(), amount);
    }

    function renounceOwnership() public override onlyOwner {
        super.renounceOwnership();
    }

    function transferOwnership(address newOwner) public override onlyOwner {
        super.transferOwnership(newOwner);
    }
}
