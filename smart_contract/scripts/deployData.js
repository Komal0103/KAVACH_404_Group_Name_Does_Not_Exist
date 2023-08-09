const hre = require("hardhat");
// const { ethers } = hre;

const main = async () => {
    const Data = await ethers.getContractFactory("UserData");
    const data = await Data.deploy();

    await data.deployed();

    console.log("Transactions deployed to: ", data.address);
}

const runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch(error){
        console.log(error);
        process.exit(1);
    }
}

runMain();