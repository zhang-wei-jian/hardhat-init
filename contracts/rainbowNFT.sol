// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

// 导入ERC721URIStorage，提供NFT铸造和URI存储功能
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
// 导入Ownable，提供权限管理（只有所有者能调用特定函数）
import "@openzeppelin/contracts/access/Ownable.sol";

contract rainbowNFT is ERC721URIStorage, Ownable {

   // NFT 的编号 id，默认初始化为 0
   uint256 private _nextTokenId;

   /**
    * @dev 构造函数
    * @param owner_ 初始所有者地址，将由 Ownable 合约的构造函数设置
    * ERC721 构造函数设置 NFT 的名称和符号
    */
   constructor(address owner_)
       ERC721("rainbowNFT", "RBN")
       Ownable(owner_)
   {
       // 这里可以添加其他初始化逻辑（如果需要）
   }

   /**
    * @dev 安全铸造 NFT
    * @param to 接收 NFT 的地址
    * @param url NFT 的 URI，通常指向包含元数据（如图片、描述等）的 JSON 文件
    * 只有所有者（通过 Ownable 的 onlyOwner 修饰符）才能调用此函数
    */
   function safeMint(address to, string memory url) public onlyOwner {
       // 递增 _nextTokenId，确保每次铸造的 tokenId 唯一且从 1 开始
       _nextTokenId++;

       // 调用 ERC721 的 _safeMint 函数，将 NFT 铸造给地址 to，并使用递增后的 _nextTokenId 作为 tokenId
       _safeMint(to, _nextTokenId);

       // 为新铸造的 NFT 设置 URI，将 tokenId 与其对应的资源（例如图片或元数据）绑定
       _setTokenURI(_nextTokenId, url);
   }
}
