// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract Auction {
    address public owner;
    uint256 public highestBid;
    address public highestBidder;

    mapping(address => uint256) public bids;

    bool public auctionEnded;

    constructor() {
        owner = msg.sender; 
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    function placeBid() public payable {
        require(!auctionEnded, "Auction has ended");
        require(msg.value > highestBid, "Bid is too low");
        if (highestBidder != address(0)) {
            bids[highestBidder] += highestBid; 
        }

        highestBid = msg.value;
        highestBidder = msg.sender;
        bids[msg.sender] += msg.value;
    }

    function endAuction() public onlyOwner {
        require(!auctionEnded, "Auction already ended");
        auctionEnded = true;

        if (highestBid > 0) {
            payable(owner).transfer(highestBid);
        }
    }

    function withdraw() public {
        require(auctionEnded, "Auction is not yet ended");
        require(msg.sender != highestBidder, "Winner cannot withdraw");

        uint256 amount = bids[msg.sender];
        require(amount > 0, "No funds to withdraw");

        bids[msg.sender] = 0; 
        payable(msg.sender).transfer(amount);
    }
}
