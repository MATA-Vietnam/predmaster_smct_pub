// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NftTicket is ERC721, Ownable {
    mapping(address => bool) public operator;

    uint256 public totalSupply;
    string public _baseTokenURI;

    constructor() ERC721("Pred Master Plantinum NFT", "PMP-NFT") {}

    /** EVENT */
    event Received(address, uint256);
    event Minted(address, uint256);
    event ChangeUrl(string);

    function mint(address reciver) public onlySystem {
        totalSupply += 1;
        _mint(reciver, totalSupply);
        emit Minted(reciver, totalSupply);
    }

    function burn(uint256 tokenId) public {
        _burn(tokenId);
    }

    /**
     * @dev Set token URI
     */
    function updateBaseURI(string calldata baseTokenURI) public onlyOwner {
        _baseTokenURI = baseTokenURI;
    }

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(
        uint256 tokenId
    ) public view virtual override(ERC721) returns (string memory) {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );
        return
            bytes(_baseTokenURI).length > 0
                ? string(abi.encodePacked(_baseTokenURI))
                : "";
    }

    function setOperator(address[] memory _operator) public onlySystem {
        for (uint256 index = 0; index < _operator.length; index++) {
            operator[_operator[index]] = true;
        }
    }

    function removeOperator(address[] memory _operator) public onlySystem {
        for (uint256 index = 0; index < _operator.length; index++) {
            operator[_operator[index]] = false;
        }
    }

    modifier onlySystem() {
        require(
            owner() == msg.sender || operator[msg.sender] == true,
            "U2UEventToken: caller is not the owner"
        );
        _;
    }
}
