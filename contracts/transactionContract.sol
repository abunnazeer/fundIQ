// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./PortfolioContract.sol"; // Import the portfolio contract for accessing portfolio data

contract TransactionContract {
    PortfolioContract private portfolioContract; // Portfolio contract instance

    // Mapping of user addresses to their transaction history
    mapping(address => Transaction[]) private transactionHistory;

    // Struct to represent a transaction
    struct Transaction {
        string action; // Transaction action (e.g., "Buy", "Sell")
        string symbol; // Asset symbol (e.g., ETH, BTC)
        uint256 amount; // Amount of the asset transacted
        uint256 timestamp; // Timestamp of the transaction
    }

    // Event emitted when a transaction occurs
    event TransactionExecuted(
        address indexed user,
        string action,
        string symbol,
        uint256 amount
    );

    // Constructor to set the PortfolioContract address
    constructor(address _portfolioContractAddress) {
        portfolioContract = PortfolioContract(_portfolioContractAddress);
    }

    // Function to execute a buy transaction
    function buy(string memory _symbol, uint256 _amount) external {
        // Call the PortfolioContract to add the asset to the user's portfolio
        portfolioContract.addAsset(_symbol, _amount);

        // Record the transaction in the transaction history
        transactionHistory[msg.sender].push(
            Transaction("buy", _symbol, _amount, block.timestamp)
        );

        // Emit an event
        emit TransactionExecuted(msg.sender, "buy", _symbol, _amount);
    }

    // Function to execute a sell transaction
    function sell(string memory _symbol, uint256 _amount) external {
        // Get the user's portfolio
        PortfolioContract.Asset[] memory userPortfolio = portfolioContract
            .getPortfolio();

        // Find the index of the asset with the given symbol
        uint256 assetIndex = findAssetIndex(userPortfolio, _symbol);

        // Ensure the asset exists in the user's portfolio
        require(
            assetIndex < userPortfolio.length,
            "Asset not found in portfolio"
        );

        // Call the PortfolioContract to remove the asset from the user's portfolio
        portfolioContract.removeAsset(assetIndex);

        // Record the transaction in the transaction history
        transactionHistory[msg.sender].push(
            Transaction("sell", _symbol, _amount, block.timestamp)
        );

        // Emit an event
        emit TransactionExecuted(msg.sender, "sell", _symbol, _amount);
    }

    // Function to find the index of an asset in the user's portfolio
    function findAssetIndex(
        PortfolioContract.Asset[] memory assets,
        string memory _symbol
    ) private pure returns (uint256) {
        for (uint256 i = 0; i < assets.length; i++) {
            if (
                keccak256(bytes(assets[i].symbol)) == keccak256(bytes(_symbol))
            ) {
                return i; // Return the index if the asset is found
            }
        }
        return assets.length; // Return the length of the assets array if the asset is not found
    }

    // // Function to execute a sell transaction
    // function sell(string memory _symbol, uint256 _amount) external {
    //     // Call the PortfolioContract to remove the asset from the user's portfolio
    //     // Note: Additional validation should be added to ensure the user has sufficient assets to sell
    //     portfolioContract.removeAsset(_symbol);

    //     // Record the transaction in the transaction history
    //     transactionHistory[msg.sender].push(
    //         Transaction("sell", _symbol, _amount, block.timestamp)
    //     );

    //     // Emit an event
    //     emit TransactionExecuted(msg.sender, "sell", _symbol, _amount);
    // }

    // Function to get the user's transaction history
    function getTransactionHistory()
        external
        view
        returns (Transaction[] memory)
    {
        return transactionHistory[msg.sender];
    }
}
