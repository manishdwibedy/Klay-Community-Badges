// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title KlaytnCommunityNFT
 * @dev This contract implements an ERC721 token with additional features like pausing, ownership, URI storage,
 *      and burning capabilities. It is designed to represent SoulBound NFTs.
 */
contract KlaytnCommunityNFT is ERC721, ERC721URIStorage, ERC721Burnable {
    uint256 private _nextTokenId;

    // Mapping from owner address to list of owned token IDs
    mapping(address => uint256[]) private _ownedTokens;
    
    // Array to store addresses that have minted SoulBoundNFTs
    address[] private _minters;
    
    // Mapping to check if an address is already in the _minters array
    mapping(address => bool) private _isMinter;

    constructor()
        ERC721("KlaytnCommunityNFT", "KLAYCNFT")
    {}

    /**
     * @dev Mints a new token with the given URI and assigns it to the specified address.
     * Requirements:
     * - Sender must be the owner of the contract.
     * @param to The address to which the token will be minted.
     * @param uri The URI for the token metadata.
     */
    function safeMint(address to, string memory uri) public {
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
        _ownedTokens[to].push(tokenId);

        // Add the address to the minters list if it is not already present
        if (!_isMinter[to]) {
            _minters.push(to);
            _isMinter[to] = true;
        }
    }

    /**
     * @dev Overrides the transferFrom function to prevent token transfers.
     * @param from The address from which the token is transferred.
     * @param to The address to which the token is transferred.
     * @param tokenId The ID of the token being transferred.
     */
    function transferFrom(address from, address to, uint256 tokenId)
            public
            override(ERC721, IERC721)
            virtual
        {
            require(from == address(0), "Err: token transfer is BLOCKED");   
            super.transferFrom(from, to, tokenId);
        }

    /**
     * @dev Updates the internal state of the contract.
     * @param to The address to which the token is being transferred.
     * @param tokenId The ID of the token being transferred.
     * @param auth The authorization address.
     * @return Address The address to which the token is transferred.
     */
    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    /**
     * @dev Retrieves the URI for the specified token.
     * @param tokenId The ID of the token for which the URI will be retrieved.
     * @return string The URI for the token metadata.
     */
    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    /**
     * @dev Checks whether the contract supports the given interface.
     * @param interfaceId The ID of the interface.
     * @return bool True if the contract supports the given interface, false otherwise.
     */
    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    /**
     * @dev Retrieves all KlaytnCommunity NFTs owned by a specific address.
     * @param owner The address whose Soulbound NFTs will be retrieved.
     * @return uint256[] An array of token IDs owned by the specified address.
     */
    function getKlaytnCommunityNFTs(address owner) public view returns (uint256[] memory) {
        require(owner != address(0), "Invalid address");
        return _ownedTokens[owner];
    }

    /**
     * @dev Retrieves the list of addresses that have minted SoulBoundNFTs.
     * @return address[] An array of addresses that have minted SoulBoundNFTs.
     */
    function getCommunityMembers() public view returns (address[]  memory) {
        return _minters;
    }

    /**
     * @dev Checks whether the address holds the KlaytnCommunity NFT
     * @param member The address whose KlaytnCommunity NFTs will be checked
     * @return bool returns true if the address holds KlaytnCommunity NFT, otherwise returns false
     */
    function isCommunityMember(address member) public view returns (bool) {
        if (!_isMinter[member]) {
            return true;
        }
        return false;
    }
}