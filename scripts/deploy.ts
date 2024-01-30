import { ethers } from "hardhat";

const tokens = (n: number) => {
  return ethers.parseUnits(n.toString(), "ether");
};

async function main() {
  // Setup accounts & variables
  const [deployer] = await ethers.getSigners();
  const NAME = "Darias NFT Gallery";
  const SYMBOL = "DNG";

  // Deploy contract
  const factory = await ethers.getContractFactory("DariasNFTGallery");
  const contract = await factory.deploy(NAME, SYMBOL);

  await contract.waitForDeployment();

  const address = await contract.getAddress();

  console.log(`Darias Deployed Contract is at: ${address}\n`);

  // List paintings
  const names = [
    "Ghibli Cat",
    "Ghibli Witch",
    "Mac Miller",
    "Mafia Man",
    "Plant",
    "Scary Sheep",
    "Magical Sword",
  ];

  // List painitng costs
  const costs = [
    tokens(100),
    tokens(25),
    tokens(15),
    tokens(200),
    tokens(30),
    tokens(145),
    tokens(200),
  ];

  // List painting images
  const images = ["anime_cat", "ghibli", "mac_miller", "mafia_man", "plant", "sheep", "sword",];

  names.forEach(async (name, i) => {
    console.log(`Listing Item ${i + 1}: ${name}`);
    const transaction = await contract
      .connect(deployer)
      .list(names[i], costs[i], images[i]);
    await transaction.wait();
  });
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
