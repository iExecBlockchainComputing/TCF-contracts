pragma solidity ^0.5.0;

import "./libs/SignatureVerifier.sol";

contract WorkOrderRegistry is SignatureVerifier
{
	enum WorkOrderStatus
	{
		NULL,
		ACTIVE,
		COMPLETED
	}

	struct WorkOrder
	{
		uint256 status;
		bytes32 workerID;
		bytes32 requesterID;
		string  request;
		address verifier;
		uint256 returnCode;
		string  response;
	}

	// workOrderID → workOrder
	mapping(bytes32 => WorkOrder) m_workorders;

	event workOrderSubmitted(
		bytes32 indexed workOrderID,
		bytes32 indexed workerID,
		bytes32 indexed requesterID);

	event workOrderCompleted(
		bytes32 indexed workOrderID,
		uint256 indexed workOrderReturnCode);

	constructor()
	public
	{}

	function workOrderSubmit(
		bytes32        _workerID,
		bytes32        _requesterID,
		string  memory _workOrderRequest,
		address        _verifier,
		bytes32        _salt)
	public returns (
		uint256        errorCode
	) {
		bytes32 workOrderID = keccak256(abi.encode(
			_workerID,
			_requesterID,
			_workOrderRequest,
			_verifier,
			_salt
		));

		WorkOrder storage wo = m_workorders[workOrderID];
		require(wo.status == uint256(WorkOrderStatus.NULL), "wo-already-submitted");
		wo.status      = uint256(WorkOrderStatus.ACTIVE);
		wo.workerID    = _workerID;
		wo.requesterID = _requesterID;
		wo.request     = _workOrderRequest;
		wo.verifier    = _verifier;

		emit workOrderSubmitted(
			workOrderID,
			_workerID,
			_requesterID);

		return 0;
	}

	function workOrderComplete(
		bytes32       _workOrderID,
		uint256       _workOrderReturnCode,
		string memory _workOrderResponse,
		bytes  memory _workOrderSignature
	) public returns (
		uint256       errorCode
	) {
		WorkOrder storage wo = m_workorders[_workOrderID];
		require(wo.status == uint256(WorkOrderStatus.ACTIVE), "wo-already-submitted");

		require(checkSignature(
			wo.verifier,
			toEthSignedMessageHash(
				keccak256(abi.encodePacked(
					_workOrderID,
					_workOrderReturnCode,
					_workOrderResponse
				))
			),
			_workOrderSignature
		));

		wo.status      = uint256(WorkOrderStatus.COMPLETED);
		wo.returnCode  = _workOrderReturnCode;
		wo.response    = _workOrderResponse;

		emit workOrderCompleted(
			_workOrderID,
			_workOrderReturnCode);

		return 0;
	}

	function workOrderGet(
		bytes32       _workOrderID
	) public view returns (
		uint256       status,
		bytes32       workerID,
		bytes32       requesterID,
		string memory request,
		address       verifier,
		uint256       returnCode,
		string memory response)
	{
		return (
			m_workorders[_workOrderID].status,
			m_workorders[_workOrderID].workerID,
			m_workorders[_workOrderID].requesterID,
			m_workorders[_workOrderID].request,
			m_workorders[_workOrderID].verifier,
			m_workorders[_workOrderID].returnCode,
			m_workorders[_workOrderID].response);
	}

}
