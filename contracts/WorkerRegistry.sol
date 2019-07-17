pragma solidity ^0.5.0;

import "./IWorkerRegistry.sol";

contract WorkerRegistry is IWorkerRegistry
{

	enum WorkerStatus
	{
		NULL,
		ACTIVE,
		OFFLINE,
		DECOMMISSIONED,
		COMPROMISED
	}

	struct Worker
	{
		uint8     workerType;
		bytes32   organizationId;
		bytes32[] appTypeIds;
		string    details;
		uint8     status;
	}

	// WorkerID → Worker
	mapping(bytes32 => Worker) private m_workers;

	// workerType → organizationId → appTypeId → WorkerID[]
	mapping(uint8 => mapping(bytes32 => mapping(bytes32 => bytes32[]))) m_workersDB;

	constructor()
	public
	{}

	function workerRegister(
		bytes32            workerID
	, uint8              workerType
	, bytes32            organizationId
	, bytes32[] calldata appTypeIds
	, string    calldata details
	) external {
		Worker storage worker = m_workers[workerID];
		worker.workerType     = workerType;
		worker.organizationId = organizationId;
		worker.appTypeIds     = appTypeIds;
		worker.details        = details;
		worker.status         = uint8(WorkerStatus.NULL); // DEFAULT ?

		m_workersDB[uint8(0)  ][bytes32(0)    ][bytes32(0)].push(workerID);
		m_workersDB[workerType][bytes32(0)    ][bytes32(0)].push(workerID);
		m_workersDB[uint8(0)  ][organizationId][bytes32(0)].push(workerID);
		m_workersDB[workerType][organizationId][bytes32(0)].push(workerID);

		for (uint256 p = 0; p < appTypeIds.length; ++p)
		{
			m_workersDB[uint8(0)  ][bytes32(0)    ][appTypeIds[p]].push(workerID);
			m_workersDB[workerType][bytes32(0)    ][appTypeIds[p]].push(workerID);
			m_workersDB[uint8(0)  ][organizationId][appTypeIds[p]].push(workerID);
			m_workersDB[workerType][organizationId][appTypeIds[p]].push(workerID);
		}
	}

	function workerUpdate(
		bytes32         workerID
	, string calldata details
	) external {
		m_workers[workerID].details = details;
	}

	function workerSetStatus(
		bytes32 workerID
	, uint8   status
	) external {
		m_workers[workerID].status = status;
	}

	function workerLookUp(
		uint8   workerType
	, bytes32 organizationId
	, bytes32 appTypeId
	) external view returns(
		uint256          totalCount // CHANGED
	, string    memory lookupTag // CHANGED
	, bytes32[] memory ids
	) {
		bytes32[] storage matchs = m_workersDB[workerType][organizationId][appTypeId];
		return (matchs.length, "", matchs);
	}

	function workerLookUpNext(
		uint8           workerType
	, bytes32         organizationId
	, bytes32         appTypeId
	, string calldata /*lookUpTag*/
	) external view returns(
		uint256          totalCount // CHANGED
	, string    memory newLookupTag
	, bytes32[] memory ids
	) {
		bytes32[] storage matchs = m_workersDB[workerType][organizationId][appTypeId];
		return (matchs.length, "", matchs);
	}

	function workerRetrieve(
		bytes32 workerID
	) external view returns (
		uint8            workerType
//, string    memory workerTypeDataUri // NOT DEFINED ANYWHERE
	, bytes32          organizationId
	, bytes32[] memory appTypeIds
	, string    memory details
	, uint8            status
	) {
		Worker storage worker = m_workers[workerID];
		return ( worker.workerType, worker.organizationId, worker.appTypeIds, worker.details, worker.status );
	}
}
