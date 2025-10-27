// scripts/log.js

const hre = require("hardhat");
const { ethers } = hre;

async function main() {
  // Replaced with deployed contract address
  const contractAddress = "YOUR_DEPLOYED_CONTRACT_ADDRESS_HERE";

  const PriceOracleBTCUSD = await ethers.getContractFactory("PriceOracleBTCUSD");
  const oracle = PriceOracleBTCUSD.attach(contractAddress);

  console.log("🔍 Listening for PriceOracleBTCUSD events...");
  console.log(`📄 Contract Address: ${contractAddress}`);
  console.log(`⛽ Network: ${hre.network.name}`);
  console.log("--------------------------------------------");

  // Event: Price updated
  oracle.on("PriceUpdated", (newPrice, timestamp) => {
    const date = new Date(Number(timestamp) * 1000).toLocaleString();
    console.log("💹 Price Updated:");
    console.log(`💰 BTC/USD: $${newPrice}`);
    console.log(`🕒 Timestamp: ${date}`);
    console.log("--------------------------------------------");
  });

  // Event: Owner changed
  oracle.on("OwnerChanged", (oldOwner, newOwner) => {
    console.log("⚙️ Owner Changed:");
    console.log(`👤 Old Owner: ${oldOwner}`);
    console.log(`👑 New Owner: ${newOwner}`);
    console.log("--------------------------------------------");
  });

  // Keep script running
  process.stdin.resume();
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

