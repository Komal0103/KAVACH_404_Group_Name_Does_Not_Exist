// https://eth-sepolia.g.alchemy.com/v2/eniA4V0GQmNocwgpJ0Q1_1ekuJuVNyEE

require("@nomiclabs/hardhat-waffle");
// require("@nomicfoundation/hardhat-toolbox");
require("@nomiclabs/hardhat-ethers");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.18",
  networks: {
    sepolia: {
      url: 'https://eth-sepolia.g.alchemy.com/v2/eniA4V0GQmNocwgpJ0Q1_1ekuJuVNyEE',
      accounts: ['fee9bb22657e089d9b8008340a5d5858d87556e4a4156f396bc0e9f5faf9f9e1']
    }
  }
};