pragma solidity ^0.5.0;

import "./IWorkerRegistryList.sol";
import "./libs/Set.sol";

contract WorkerRegistryList is IWorkerRegistryList
{
	using Set for Set.set;

	enum RegistryStatus
	{
		NULL,
		ACTIVE,
		OFFLINE,
		DECOMMISSIONED
	}

	struct Registry
	{
		string    uri;
		bytes32   scAddr;
		bytes32[] appTypeIds;
		uint8     status;
	}

	// OrgID → Registry
	mapping(bytes32 => Registry) private m_registries;

	// AppTypeId → Set of OrgID
	mapping(bytes32 => Set.set ) private m_registriesByAppType;

	constructor()
	public
	{}

	function registryAdd(
		bytes32            orgID
	, string    calldata uri
	, bytes32            scAddr
	, bytes32[] calldata appTypeIds
	) external {
		_cleanRegistryAppType(orgID);

		Registry storage registry = m_registries[orgID];
		registry.uri        = uri;
		registry.scAddr     = scAddr;
		registry.appTypeIds = appTypeIds;
		registry.status     = uint8(RegistryStatus.NULL); // DEFAULT ?

		_setRegistryAppType(orgID);
	}

	function registryUpdate(
		bytes32            orgID
	, string    calldata uri
	, bytes32            scAddr
	, bytes32[] calldata appTypeIds
	) external {
		_cleanRegistryAppType(orgID);

		Registry storage registry = m_registries[orgID];
		registry.uri        = uri;
		registry.scAddr     = scAddr;
		registry.appTypeIds = appTypeIds;
		registry.status     = uint8(RegistryStatus.NULL); // DEFAULT ?

		_setRegistryAppType(orgID);
	}

	function registrySetStatus(
		bytes32 orgID
	, uint8   status
	) external {
		m_registries[orgID].status = status;
	}

	function registryLookUp(
		bytes32 appTypeId
	) external view returns (
		uint256          totalCount // CHANGED
	, string    memory lookupTag  // CHANGED
	, bytes32[] memory ids
	) {
		return (m_registriesByAppType[appTypeId].length(), "", m_registriesByAppType[appTypeId].content());
	}

	function registryLookUpNext(
		bytes32         appTypeId // TYPO
	, string calldata /*lookUpTag*/
	) external view returns (
		uint256          totalCount // CHANGED
	, string    memory newLookupTag
	, bytes32[] memory ids
	) {
		return (m_registriesByAppType[appTypeId].length(), "", m_registriesByAppType[appTypeId].content());
	}

	function registryRetrieve(
		bytes32 orgID // CHANGED
	) external view returns (
		string    memory uri
	, bytes32          scAddr
	, bytes32[] memory appTypeIds
	, uint8            status
	) {
		Registry storage registry = m_registries[orgID];
		return ( registry.uri, registry.scAddr, registry.appTypeIds, registry.status );
	}

	function _setRegistryAppType(bytes32 orgID)
	internal
	{
		bytes32[] storage appTypeIds = m_registries[orgID].appTypeIds;
		for (uint256 p = 0; p < appTypeIds.length; ++p)
		{
			m_registriesByAppType[appTypeIds[p]].add(orgID); // Require would revert on duplicate → set knows how to avoid conflicts
		}
	}

	function _cleanRegistryAppType(bytes32 orgID)
	internal
	{
		bytes32[] storage appTypeIds = m_registries[orgID].appTypeIds;
		for (uint256 p = 0; p < appTypeIds.length; ++p)
		{
			m_registriesByAppType[appTypeIds[p]].remove(orgID); // Could require
		}
	}

}
