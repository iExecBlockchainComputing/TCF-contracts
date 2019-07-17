var WorkerRegistry     = artifacts.require("WorkerRegistry");
var WorkerRegistryList = artifacts.require("WorkerRegistryList");

module.exports = async function(deployer, network, accounts)
{
	console.log("# web3 version:", web3.version);
	chainid   = await web3.eth.net.getId();
	chaintype = await web3.eth.net.getNetworkType()
	console.log("Chainid is:", chainid);
	console.log("Chaintype is:", chaintype);

	await deployer.deploy(WorkerRegistry);
	const WorkerRegistryInstance = await WorkerRegistry.deployed();
	console.log("WorkerRegistryInstance deployed at address: " + WorkerRegistryInstance.address);

	await deployer.deploy(WorkerRegistryList);
	const WorkerRegistryListInstance = await WorkerRegistryList.deployed();
	console.log("WorkerRegistryListInstance deployed at address: " + WorkerRegistryListInstance.address);

};
