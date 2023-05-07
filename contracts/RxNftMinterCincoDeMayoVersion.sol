// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "@thirdweb-dev/contracts/base/ERC721Base.sol";

// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";
// import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
// import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
// import "@openzeppelin/contracts/security/Pausable.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";
// import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
// import "@openzeppelin/contracts/utils/Counters.sol";
// import "@openzeppelin/contracts/utils/Base64.sol";

// import "base64-sol/base64.sol";

contract RxNftMinter is ERC721Base {
    // uint256 private s_tokenCounter;
    // string private constant base64EncodedSvgPrefix =
    //     "data:image/svg+xml;base64,";

    // using Counters for Counters.Counter;

    // Counters.Counter private _tokenIdCounter;

    // constructor() ERC721Base("RxNFT", "HMD", msg.sender, 0) {}

    uint256 private rx_tokenCounter;

    // constructor() ERC721("RxNFT", "HMD") {
    //     rx_tokenCounter = 0;
    // }

    constructor(
        string memory _name,
        string memory _symbol
    )
        // address _royaltyRecipient,
        // uint128 _royaltyBps
        ERC721Base(_name, _symbol, msg.sender, 0)
    {
        rx_tokenCounter = 0;
    }

    struct Script {
        string patient_wallet;
        string name;
        string description;
        string medication;
        string dob;
        string quantity;
        uint256 rxId;
    }

    mapping(uint256 => Script) public scripts;

    Script[] allScripts;

    // function toAddress(
    //     string memory _patient_wallet
    // ) public pure returns (bytes32 result) {
    //     address patientAddress = address(bytes20(bytes(_patient_wallet)));
    //     return patientAddress;
    // }

    // function toAddress(
    //     string memory source
    // ) public pure returns (bytes32 result) {
    //     // require(bytes(source).length <= 32); // causes error, but string have to be max 32 chars

    //     // https://ethereum.stackexchange.com/questions/9603/understanding-mload-assembly-function
    //     // http://solidity.readthedocs.io/en/latest/assembly.html
    //     // this converts every char to its byte representation
    //     // see hex codes on http://www.asciitable.com/ (7 > 37, a > 61, z > 7a)
    //     // "az7" > 0x617a370000000000000000000000000000000000000000000000000000000000
    //     assembly {
    //         result := mload(add(source, 32))
    //     }
    //     return result;
    // }

    function _createScript(
        string memory _patient_wallet,
        string memory _name,
        string memory _description,
        string memory _medication,
        string memory _dob,
        string memory _quantity
    ) public returns (uint256) {
        Script memory _rx = Script({
            patient_wallet: _patient_wallet,
            name: _name,
            description: _description,
            medication: _medication,
            dob: _dob,
            quantity: _quantity,
            rxId: rx_tokenCounter
        });

        allScripts.push(_rx);

        // _transfer(address(0), _rx.patient_wallet, _rx.rxId);
        // emit Transfer(address(0), _rx.patient_wallet, _rx.rxId);
        // mintRx(_rx.patient_wallet, _rx.rxId);

        // mintRx(_patient_address, rx_tokenCounter);

        return _rx.rxId;
    }

    // (12:00) - mapping allows us to reference campaigns[0]
    // mapping(uint256 => Campaign) public campaigns;

    // (12:23) - global public variable:
    // uint256 public numberOfCampaigns = 0;

    // At: https://youtu.be/gyMwXuJrbJQ?t=80144
    // function svgToImageURI(
    //     string memory svg
    // ) public pure returns (string memory) {
    // His comments on the svg direct at (23:01:51): https://youtu.be/gyMwXuJrbJQ?t=82911
    // string memory baseURL = "data:image/svg+xml;base64,";
    // string memory svgBase64Encoded = Base64.encode(
    //     bytes(string(abi.encodePacked(svg)))
    // );
    // return string(abi.encodePacked(baseURL, svgBase64Encoded));
    //     return
    //         string(abi.encodePacked(base64EncodedSvgPrefix, svgBase64Encoded));
    // }

    // function mintNFT() public returns (uint256) {
    //     _safeMint(msg.sender, s_tokenCounter);
    //     s_tokenCounter = s_tokenCounter + 1;
    //     return s_tokenCounter; //BasicNFT: https://youtu.be/gyMwXuJrbJQ?t=74727
    // }

    // function getTokenCounter() public view returns (uint256) {
    //     return s_tokenCounter;
    // }

    // function safeMint(address _to, string memory _uri) public onlyOwner {
    // At: https://www.youtube.com/live/DSKDhBCmHXk?feature=share&t=531

    function mintRx(
        address _to
    )
        public
    // uint256 _rx_tokenCounter // string memory _uri // string memory _patient, // string memory _description, // string memory _medication, // string memory _dob, // string memory _quantity
    {
        // uint256 tokenId = _tokenIdCounter.current();

        // _safeMint(_to, _rx_tokenCounter);
        _safeMint(_to, 1);
        // _setTokenURI(tokenId, _uri);
        // _setTokenURI(
        // _rxId,
        // _setRxURI(_to, _patient, _description, _medication, _dob, _quantity)
        // _setRxURI(_rxId)
        // );
        rx_tokenCounter += 1;
    }

    //**********************From wizard: https://docs.openzeppelin.com/contracts/4.x/wizard ************************************************ */
    //Adds tokenURI at (23:03:16): https://youtu.be/gyMwXuJrbJQ?t=82996
    // require(_exists(tokenId), "Token Id not found. Contact Bates Bots.");

    // function tokenURI(
    //     uint256 tokenId
    // ) public view override returns (string memory) {
    //     return super.tokenURI(tokenId);
    // }

    // function _beforeTokenTransfer(
    //     address from,
    //     address to,
    //     uint256 tokenId,
    //     uint256 batchSize
    // ) internal override(ERC721) {
    //     super._beforeTokenTransfer(from, to, tokenId, batchSize);
    // }

    // function _burn(
    //     uint256 tokenId
    // ) internal override {
    //     super._burn(tokenId);
    // }

    // function supportsInterface(
    //     bytes4 interfaceId
    // ) public view override returns (bool) {
    //     return super.supportsInterface(interfaceId);
    // }

    //*********************************************************************************************************** */

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    // struct Parts {
    //     string[] parts1;
    //     string[] parts2;
    //     string[] parts3;
    //     string[] parts4;
    //     string[] parts5;
    //     string[] parts6;
    //     string[] parts7;
    //     string[] parts8;
    //     string[] parts9;
    // }

    // string[9] storage parts;
    // Parts[9] public parts;

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        // (15:25) - create new campaign
        // Campaign storage campaign = campaigns[numberOfCampaigns]; //populate first item in our Campaigns array (campaigns[0])

        // (16:47)
        // campaign.patient_address = _patient_address;
        // campaign.name = _name;
        // campaign.description = _description;
        // campaign.medication = _medication;
        // campaign.dob = _dob;
        // campaign.quantity = _quantity;

        // numberOfCampaigns++;
        // numberOfCampaigns - 1;

        // Script storage rx = allScripts[_rxId];
        Script storage rx = allScripts[tokenId];

        string[7] memory parts;

        parts[
            0
        ] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 400 80"><style>.base { fill: black; font-family: serif; font-size: 12px; }</style><rect width="100%" height="100%" fill="#FCF8F7" /><text x="10" y="20" class="base">';

        parts[1] = string(
            abi.encodePacked("Patient: ", rx.name, " - DOB: ", rx.dob)
        );

        parts[2] = '</text><text x="10" y="40" class="base">';

        parts[3] = string(
            abi.encodePacked(
                "Medication: ",
                rx.medication,
                " - Qty: ",
                rx.quantity
            )
        );

        parts[4] = '</text><text x="10" y="60" class="base">';

        parts[5] = string(abi.encodePacked("Pt Address: ", rx.patient_wallet));

        parts[6] = "</text></svg>";

        // string memory output = string(
        string memory svg = string(
            abi.encodePacked(
                parts[0],
                parts[1],
                parts[2],
                parts[3],
                parts[4],
                parts[5],
                parts[6]
            )
        );

        string memory baseURL = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(
            bytes(string(abi.encodePacked(svg)))
        );

        // return string(abi.encodePacked(baseURL, svgBase64Encoded));
        string memory imageURI = string(
            abi.encodePacked(baseURL, svgBase64Encoded)
        );

        //attributes
        string memory jsonAttributes = string(
            abi.encodePacked(
                '[{"trait_type": "sig", "value": "',
                rx.description,
                '"}, {"trait_type": "patient_wallet_address", "value": "',
                rx.patient_wallet,
                '"}, {"trait_type": "fill_status", "value": "',
                rx.dob,
                '"}]'
            )
        );

        //json
        // string memory billsMafiaImageURI = string(
        return
            string(
                abi.encodePacked(
                    _baseURI(),
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name": "',
                                rx.name,
                                '", "description": "',
                                rx.description,
                                '", ',
                                '", "Medication": "',
                                rx.medication,
                                '", ',
                                '", "Quantity": "',
                                rx.quantity,
                                '", ',
                                '", "DOB": "',
                                rx.dob,
                                '", ',
                                ' "image":"',
                                imageURI,
                                '", ',
                                // '"attributes": [{"trait_type": "npi", "value": "01010101"},{"trait_type": "state", "value": "CA"},{"trait_type": "expiration", "value": "06/06/2023"}]}'
                                '"attributes": ',
                                jsonAttributes,
                                "}"
                            )
                        )
                    )
                )
            );

        // return billsMafiaImageURI;
    } //end of tokenURI or generateSVG
} //end of contract
