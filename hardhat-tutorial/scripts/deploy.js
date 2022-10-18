const { ethers } = require("hardhat");
require("dotenv").config({ path: ".env"});
const {NFT_CONTRACT_ADDRESS} = require("../constants")

async function main() {

  const cryptoDevsNFTContract = NFT_CONTRACT_ADDRESS;

  const cryptoDevsTokenContract = await ethers.getContractFactory("CryptoDevToken");

  const deployedContract = await cryptoDevsTokenContract.deploy(cryptoDevsNFTContract);

  await deployedContract.deployed();

  console.log("Deployed Crypto Devs Token Address", deployedContract.address);
}

main()
.then(() => process.exit(0))
.catch((error) => {
  console.error(error)
  process.exit(1);
});