const hre = require("hardhat");

async function main() {

  const MyCoin = await hre.ethers.getContractFactory("MyCoin");
  const myCoin = await MyCoin.deploy();
  await myCoin.deployed();


  const EncodeTest = await hre.ethers.getContractFactory("EncodeTest");
  const encodeTest = await EncodeTest.deploy(myCoin.address);
  await encodeTest.deployed();

  let tx = await encodeTest.transfer(myCoin.address, 5)
  console.log(tx.toString())




  
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
