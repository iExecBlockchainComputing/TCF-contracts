pragma solidity ^0.5.0;

interface WorkerRegistry
{
	function workerRegister(
		bytes32            workerID
	, uint8              workerType
	, bytes32            organizationID
	, bytes32[] calldata applicationTypeId
	, string    calldata details
	) external;

	function workerUpdate(
		bytes32         workerID
	, string calldata details
	) external;

	function workerSetStatus(
		bytes32 workerID
	, uint8   status
	) external;

	function workerLookUp(
		uint8   workerType
	, bytes32 organizationId
	, bytes32 applicationTypeId
	) external view returns(
		uint256          totalCount // CHANGED
	, string    memory lookupTag // CHANGED
	, bytes32[] memory ids
	);

	function workerLookUpNext(
		uint8           workerType
	, bytes32         organizationId
	, bytes32         applicationTypeId
	, string calldata lookUpTag
	) external view returns(
		uint256          totalCount // CHANGED
	, string    memory newLookupTag
	, bytes32[] memory ids
	);

	function workerRetrieve(
		bytes32 workerID
	) external view returns (
		uint8            workerType
//, string    memory workerTypeDataUri // NOT DEFINED ANYWHERE
	, bytes32          organizationId
	, bytes32[] memory applicationTypeId
	, string    memory details
	, uint8            status
	);
}
