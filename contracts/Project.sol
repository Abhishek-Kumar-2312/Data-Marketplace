// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract DataMarketplace {
    address public owner;

    struct Dataset {
        uint256 id;
        address payable seller;
        string name;
        string description;
        string ipfsHash;
        uint256 price;
        bool isSold;
    }

    uint256 public datasetCount;
    mapping(uint256 => Dataset) public datasets;

    event DatasetListed(
        uint256 indexed id,
        address indexed seller,
        string name,
        uint256 price
    );

    event DatasetPurchased(
        uint256 indexed id,
        address indexed buyer,
        uint256 price
    );

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function listDataset(
        string memory _name,
        string memory _description,
        string memory _ipfsHash,
        uint256 _price
    ) public {
        require(_price > 0, "Price must be greater than zero");

        datasetCount++;
        datasets[datasetCount] = Dataset(
            datasetCount,
            payable(msg.sender),
            _name,
            _description,
            _ipfsHash,
            _price,
            false
        );

        emit DatasetListed(datasetCount, msg.sender, _name, _price);
    }

    function purchaseDataset(uint256 _id) public payable {
        Dataset storage dataset = datasets[_id];
        require(_id > 0 && _id <= datasetCount, "Invalid dataset ID");
        require(!dataset.isSold, "Dataset already sold");
        require(msg.value == dataset.price, "Incorrect payment amount");

        dataset.seller.transfer(msg.value);
        dataset.isSold = true;

        emit DatasetPurchased(_id, msg.sender, dataset.price);
    }

    function getDataset(uint256 _id)
        public
        view
        returns (
            uint256,
            address,
            string memory,
            string memory,
            string memory,
            uint256,
            bool
        )
    {
        require(_id > 0 && _id <= datasetCount, "Invalid dataset ID");
        Dataset memory d = datasets[_id];
        return (
            d.id,
            d.seller,
            d.name,
            d.description,
            d.ipfsHash,
            d.price,
            d.isSold
        );
    }

    function changeOwner(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Invalid address");
        owner = newOwner;
    }

    function withdraw() public onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    receive() external payable {}
}
