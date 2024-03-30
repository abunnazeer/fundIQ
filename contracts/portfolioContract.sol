// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PortfolioContract {
    struct Asset {
        string symbol;
        uint256 amount;
    }

    mapping(address => Asset[]) private portfolio;

    // Event emmited when an asset is added to the portfolio
    event AssetAdded(address indexed user, string symbol, uint256 amount);

    //Event emmitted when an asset is removed from the portfolio
    event AssetRemoved(address indexed user, string symbol, uint256 amount);

    // Function to add an asset to the user's portfoilio
    function addAsset(string memory _symbol, uint256 _amount) external {
        //Check that the amount is non-zero
        require(_amount > 0, "Amount must be greater than zero");

        // Add the asse to the users portfolio
        portfolio[msg.sender].push(Asset(_symbol, _amount));
        //Emit an event
        emit AssetAdded(msg.sender, _symbol, _amount);
    }

    //Function to remove an asset from the users portfolio
    function removeAsset(uint256 _index) external {
        // Check that the index is valid
        require(_index < portfolio[msg.sender].length, "Invalid index");

        //Retrrieve the asset from the portfolio
        Asset memory asset = portfolio[msg.sender][_index];

        // Remove the asset from the portfolio
        delete portfolio[msg.sender][_index];

        //Emit an event
        emit AssetRemoved(msg.sender, asset.symbol, asset.amount);
    }

    //Function to get the users portfolio
    function getPortfolio() external view returns (Asset[] memory) {
        return portfolio[msg.sender];
    }
}
