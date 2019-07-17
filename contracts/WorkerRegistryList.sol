pragma solidity ^0.5.0;

interface WorkerRegistryList
{
	function registryAdd(
		bytes32            orgID
	, string    calldata uri
	, bytes32            scAddr
	, bytes32[] calldata appTypeIds
	) external;

	function registryUpdate(
		bytes32            orgID
	, string    calldata uri
	, bytes32            scAddr
	, bytes32[] calldata appTypeIds
	) external;

	function registrySetStatus(
		bytes32 orgID
	, uint8   status
	) external;

	function registryLookUp(
		bytes32 appTypeId
	) external view returns (
		uint256          totalCount // CHANGED
	, string    memory lookupTag  // CHANGED
	, bytes32[] memory ids
	);

	function registryLookUpNext(
		bytes32         applTypeId
	, string calldata lookUpTag
	) external view returns (
		uint256          totalCount // CHANGED
	, string    memory newLookupTag
	, bytes32[] memory ids
	);

	function registryRetrieve(
		bytes32 orgID // CHANGED
	) external view returns (
		string    memory uri
	, bytes32          scAddr
	, bytes32[] memory appTypeIds
	, uint8            status
	);
}
