// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

/*
                        METU BLOCKCHAIN
             ______________________________________
            //              //                    \\  
           //     _________//       __________     \\
          //    //        //     //\\        \\     \\         
         //    //        //     //  \\        \\     \\
        //    //        //     //    \\        \\     \\
        \\    \\        \\    //     //        //     //
         \\    \\        \\  //     //        //     //
          \\    \\________\\//     //________//     //      
           \\                     //               //
            \\___________________//_______________//

*/
contract OdtuBirincileri is ERC721, Ownable {

    error NonTransferrableToken();

    using Strings for uint256;

    string private URIPrefix;
    string private URISuffix = ".json";

    constructor (string memory _URIprefix) ERC721("ODTU Birincileri", "ODTU") {
        URIPrefix = _URIprefix;
    }

    function mint(address to, uint tokenId) external onlyOwner {
        _safeMint(to, tokenId);
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return URIPrefix;
    }

    function setTokenURI(string memory newURIPrefix) external onlyOwner{
        URIPrefix = newURIPrefix;
    }

    function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
        require(_exists(_tokenId), "Non-existent token given!");

        string memory currentURIPrefix = _baseURI();
        return bytes(currentURIPrefix).length > 0
            ? string(abi.encodePacked(currentURIPrefix, _tokenId.toString(), URISuffix))
        : "";
    }
    
    /****************** SOULBOUND LOGIC ******************/

    // Disallowed for preventing gas waste
    function _approve(address to, uint256 tokenId) internal override {
        revert NonTransferrableToken();
    }

    // Disallowed for preventing gas waste
    function _setApprovalForAll(
        address owner,
        address operator,
        bool approved
    ) internal override {
        revert NonTransferrableToken();
    }

    // Only allows transfers if it is minting
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override {
        if(from != address(0)) revert NonTransferrableToken();
    }
}
