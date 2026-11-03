// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FoodTraceability {

    struct Batch {
        string productName;
        string origin;
        string status;
        address sender;
        address receiver;
        uint256 timestamp;
        bool received;
        bool exists;
    }

    mapping(bytes32 => Batch) private batches;

    event BatchRegistered(
        bytes32 indexed batchId,
        string name,
        address sender,
        address receiver
    );

    event ReceiptConfirmed(
        bytes32 indexed batchId,
        address receiver
    );

    function registerBatch(
        string calldata batchId,
        string calldata productName,
        string calldata origin,
        address receiver
    ) external {
        bytes32 id = keccak256(abi.encodePacked(batchId));

        require(bytes(batchId).length > 0, "Batch ID required");
        require(receiver != address(0), "Invalid receiver");
        require(!batches[id].exists, "Batch already exists");

        batches[id] = Batch(
            productName,
            origin,
            "Harvested",
            msg.sender,
            receiver,
            block.timestamp,
            false,
            true
        );

        emit BatchRegistered(
            id,
            productName,
            msg.sender,
            receiver
        );
    }

    function confirmReceipt(string calldata batchId) external {
        bytes32 id = keccak256(abi.encodePacked(batchId));

        require(batches[id].exists, "Batch not found");
        require(
            msg.sender == batches[id].receiver,
            "Only receiver can confirm"
        );

        batches[id].received = true;
        batches[id].status = "Received";

        emit ReceiptConfirmed(id, msg.sender);
    }

    function getBatch(string calldata batchId)
        external
        view
        returns (
            string memory productName,
            string memory origin,
            string memory status,
            address sender,
            address receiver,
            uint256 timestamp,
            bool received
        )
    {
        bytes32 id = keccak256(abi.encodePacked(batchId));

        require(batches[id].exists, "Batch not found");

        Batch memory batch = batches[id];

        return (
            batch.productName,
            batch.origin,
            batch.status,
            batch.sender,
            batch.receiver,
            batch.timestamp,
            batch.received
        );
    }
}