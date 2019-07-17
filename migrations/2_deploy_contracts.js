var WorkerRegistryImplementation     = artifacts.require("WorkerRegistryImplementation");
var WorkerRegistryListImplementation = artifacts.require("WorkerRegistryListImplementation");

module.exports = async function(deployer, network, accounts)
{
	console.log("# web3 version:", web3.version);
	chainid   = await web3.eth.net.getId();
	chaintype = await web3.eth.net.getNetworkType()
	console.log("Chainid is:", chainid);
	console.log("Chaintype is:", chaintype);

	await deployer.deploy(WorkerRegistryImplementation);
	const WorkerRegistryInstance = await WorkerRegistryImplementation.deployed();
	console.log("WorkerRegistryInstance deployed at address: " + WorkerRegistryInstance.address);

	await deployer.deploy(WorkerRegistryListImplementation);
	const WorkerRegistryListInstance = await WorkerRegistryListImplementation.deployed();
	console.log("WorkerRegistryListInstance deployed at address: " + WorkerRegistryListInstance.address);

};
