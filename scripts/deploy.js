// scripts/deploy.js

const hre = require("hardhat");

async function main() {
  await hre.run("compile");

  console.log("Deploying DataMarketplace...");

  const DataMarketplace = await hre.ethers.getContractFactory("DataMarketplace");
  const marketplace = await DataMarketplace.deploy();

  await marketplace.waitForDeployment();

  const deployer = await hre.ethers.provider.getSigner();
  const deployerAddress = await deployer.getAddress();

  console.log("✅ Deployment successful!");
  console.log(`📄 Contract: DataMarketplace`);
  console.log(`📍 Address: ${await marketplace.getAddress()}`);
  console.log(`👤 Deployed by: ${deployerAddress}`);
  console.log(`⛽ Network: ${hre.network.name}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
