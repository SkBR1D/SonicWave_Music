// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SongMarketplace {
    address public owner;
    uint256 public listingFee;
    
    struct Song {
        address seller;
        string title;
        string artist;
        uint256 price;
        bool isAvailable;
    }
    
    Song[] public songs;

    mapping(address => uint256) public userBalances;

    event SongListed(uint256 songId, string title, string artist, uint256 price, address seller);
    event SongPurchased(address buyer, uint256 songId, string title, string artist, uint256 price);

    constructor(uint256 _initialListingFee) {
        owner = msg.sender;
        listingFee = _initialListingFee;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    // Function to set the listing fee, callable only by the owner
    function setListingFee(uint256 _newFee) public onlyOwner {
        listingFee = _newFee;
    }

    // Function to list a song for sale
    function listSong(string memory _title, string memory _artist, uint256 _price) public {
        require(_price >= listingFee, "Listing price must cover the listing fee");
        songs.push(Song(msg.sender, _title, _artist, _price, true));
        emit SongListed(songs.length - 1, _title, _artist, _price, msg.sender);
    }

    // Function to purchase a song
    function purchaseSong(uint256 _songId) public payable {
        require(_songId < songs.length, "Invalid song ID");
        Song storage song = songs[_songId];
        require(song.isAvailable, "This song is no longer available");
        require(msg.value >= song.price, "Insufficient funds to purchase the song");

        // Transfer the funds to the seller
        uint256 commission = (msg.value * 1) / 100; // 1% commission for the platform
        uint256 sellerEarnings = msg.value - commission;
        userBalances[song.seller] += sellerEarnings;
        owner.transfer(commission);

        // Mark the song as purchased
        song.isAvailable = false;

        // Transfer the song to the buyer (in a real-world scenario, you would have a mechanism to handle this)
        // For simplicity, we'll just emit an event
        emit SongPurchased(msg.sender, _songId, song.title, song.artist, song.price);
    }

    // Function to withdraw user balances
    function withdrawBalance() public {
        uint256 balance = userBalances[msg.sender];
        require(balance > 0, "No balance to withdraw");

        userBalances[msg.sender] = 0;
        payable(msg.sender).transfer(balance);
    }
}
