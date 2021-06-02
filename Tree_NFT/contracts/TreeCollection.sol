// SPDX-License-Identifier: Unlicensed
pragma solidity 0.6.6; // select the solidity version

import "@openzeppelin/contracts/token/ERC721/ERC721.sol"; //importing the ERC721 protocol contract
import "@chainlink/contracts/src/v0.6/VRFConsumerBase.sol"; // Importing the VRFCONSUMERBASE used for randomness

contract TreeCollection is ERC721, VRFConsumerBase { // inheriting from the ERC721 and Chainlink contracts, 
                                                     //   VRF is for random numbers generating
        bytes32 internal keyHash;
        uint256 public fee;
        uint256 public tokenCounter;

        enum Species{PINE, OAK, BIRK, ACCACIA}

        mapping(bytes32 => address) public requestIdToSender;
        mapping(bytes32 => string) public requestIdToTokenURI;
        mapping(uint256 => Species) public tokenIdToSpecies;
        mapping(bytes32 => uint256) public requestIdToTokenId;
        event requestedTree(bytes32 indexed requestId);

 
 // In the constructor, VRFCoordinator coordinates on-chain verifiable-randomness requests
 // LinkToken is used to pay node operators 
 // keyhash used to prove that a random number is indeed random
    constructor(address _VRFCoordinator, address _LinkToken, bytes32 _keyhash) public  
    //Adding the constructors of ERC721 and VRFConsumerBase in our constructor

    VRFConsumerBase(_VRFCoordinator, _LinkToken) 
    ERC721("TREES", "TREE") // The input parameters are the name of our NFT and the symbol for it
    {
        keyHash = _keyhash;
        fee = 0.1 *10 ** 18; // 0.1 LINK 
        tokenCounter = 0;
    }

// The function we call when we create an NFT
// The userInputSeed is a number we input and which chainlink will prove if the number we receive is random or not
// tokenURI is an identifier for a given asset which points to a JSON file containing the metadata

    function createTree(uint256 userInputSeed, string memory tokenURI) public returns (bytes32){ 
         bytes32 requestId = requestRandomness(keyHash, fee, userInputSeed); // We send a request to create a randon NFT
         requestIdToSender[requestId] = msg.sender; // Here we make sure that when we call for creating an NFT
                                                    // the corect number is returned to the initiator
         requestIdToTokenURI[requestId] = tokenURI; 
         emit requestedTree(requestId);

    }
    // We complete our randmoness request, returning the requestedId and the randomNumber that was generated
    function fulfillRandomness(bytes32 requestId, uint256 randomNumber) internal override {
        address treeOwner = requestIdToSender[requestId]; // We get the address of the person who originally
                                                        // created the request (saved in mapping)
        string memory tokenURI = requestIdToTokenURI[requestId]; // We get the tokenURI that we initially added by calling the function
        // Any time we mint a new element in our collection from the contract we need to set a tokenID
        uint256 newItemId = tokenCounter; // Our first tokenID will be 0
        _safeMint(treeOwner, newItemId);// We call safeMint from ERC721
        _setTokenURI(newItemId, tokenURI);
        Species tree_species = Species(randomNumber % 3); //divides the number by 3 and the remainder chooses our species from the enum
        tokenIdToSpecies[newItemId] = tree_species; 
        requestIdToTokenId[requestId] = newItemId;    //We map the requestId to the tokenId
        tokenCounter ++ ; 


    }

    function setTokenURI(uint256 tokenId, string memory _tokenURI) public {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: Transfer initiator is not owner nor approved"); // we check if the Message sender is the owner. 
       _setTokenURI(tokenId, _tokenURI); 
    }


}


