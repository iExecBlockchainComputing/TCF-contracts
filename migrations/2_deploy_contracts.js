const contracts = [
	"WorkerRegistry",
	"WorkOrderRegistry",
];

module.exports = async (deployer, network, accounts) => {
	await Promise.all(
		contracts.map(name => new Promise((resolve, reject) => {
			deployer.deploy(artifacts.require(name)).then(contract => {
				console.log(`${contract.constructor._json.contractName} deployed at ${contract.address}`);
				resolve();
			})
			.catch(reject);
		}))
	);
};
