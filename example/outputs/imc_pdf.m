function [png] = imc_pdf()

png.PN_name = 'imc';

png.set_of_Ps = {
	'pOwnerOrderToFF', ...
	'pSACrewListToSBGS', ...
	'pFFSOToSA', ...
	'pCTArrivalMsgToCustoms', ...
	'pSAManifestToCustoms', ...
	'pSAReceiptToFF', ...
	'pFFReceiptToTransport', ...
	'pDepotEmptyCTNToTransport', ...
	'pFFOrderToCB', ...
	'pCustomsDeclarationToCB', ...
	'pTransportCTNToOwner', ...
	'pCBDeclarationToCustoms', ...
	'pOwnerCTNToTransport', ...
	'pSAManifestToFF', ...
	'pCustomsClearanceToCT', ...
	'pCBAppointmentToCustoms', ...
	'pSAExpenseNoteToOwner', ...
	'pCustomsClearanceToCB', ...
	'pDepotCTNInfoToSA', ...
	'pSAAskToDepot', ...
	'pCTDepartureInfoToSA', ...
	'pDepotOutboundCTNToCT', ...
	'pSAShipMsgToCT', ...
	'pSAManifestToCT', ...
	'pTransportOutboundAndReceiptToDepot'
	};

png.set_of_As = {
	'pCBAppointmentToCustoms', 'tCustomsGetAppointment', 1, ...
	'pCBDeclarationToCustoms', 'tCustomsDeclareSuccess', 1, ...
	'pCTArrivalMsgToCustoms', 'tCustomsCIQ', 1, ...
	'pCTDepartureInfoToSA', 'tSAWaitShipDeparture', 1, ...
	'pCustomsClearanceToCB', 'tCBGetClearance', 1, ...
	'pCustomsClearanceToCT', 'tCTGetClearance', 1, ...
	'pCustomsDeclarationToCB', 'tCBAppoint', 1, ...
	'pDepotCTNInfoToSA', 'tSAGetCTNInfo', 1, ...
	'pDepotEmptyCTNToTransport', 'tTransportSendCTN', 1, ...
	'pDepotOutboundCTNToCT', 'tCTLoadCTN', 1, ...
	'pFFOrderToCB', 'tCBDeclare', 1, ...
	'pFFReceiptToTransport', 'tTransportSendCTN', 1, ...
	'pFFSOToSA', 'tSAHanleManifest', 1, ...
	'pOwnerCTNToTransport', 'tTransportGetOutboundCTN', 1, ...
	'pOwnerOrderToFF', 'tFFGetOrder', 1, ...
	'pSAAskToDepot', 'tDepotSendEmptyCTN', 1, ...
	'pSACrewListToSBGS', 'tSBGSRegistration', 1, ...
	'pSAExpenseNoteToOwner', 'tOwnerGetExpenseNote', 1, ...
	'pSAManifestToCT', 'tCTLoadCTN', 1, ...
	'pSAManifestToCustoms', 'tCustomsCIQ', 1, ...
	'pSAManifestToFF', 'tFFGetManifest', 1, ...
	'pSAReceiptToFF', 'tFFSendReceipt', 1, ...
	'pSAShipMsgToCT', 'tCTLoadCTN', 1, ...
	'pTransportCTNToOwner', 'tOwnerSendCTN', 1, ...
	'pTransportOutboundAndReceiptToDepot', 'tDepotGetOutboundAndReceipt', 1, ...
	'tCBAppoint', 'pCBAppointmentToCustoms', 1, ...
	'tCBDeclare', 'pCBDeclarationToCustoms', 1, ...
	'tCTDeparture', 'pCTDepartureInfoToSA', 1, ...
	'tCTSendArrivalMsg', 'pCTArrivalMsgToCustoms', 1, ...
	'tCustomsDeclareSuccess', 'pCustomsDeclarationToCB', 1, ...
	'tCustomsSendClearance', 'pCustomsClearanceToCB', 1, ...
	'tCustomsSendClearance', 'pCustomsClearanceToCT', 1, ...
	'tDepotSendCTNInfo', 'pDepotCTNInfoToSA', 1, ...
	'tDepotSendEmptyCTN', 'pDepotEmptyCTNToTransport', 1, ...
	'tDepotSendOutboundCTN', 'pDepotOutboundCTNToCT', 1, ...
	'tFFSendOrder', 'pFFOrderToCB', 1, ...
	'tFFSendReceipt', 'pFFReceiptToTransport', 1, ...
	'tFFSendSO', 'pFFSOToSA', 1, ...
	'tOwnerSendCTN', 'pOwnerCTNToTransport', 1, ...
	'tOwnerSendOrder', 'pOwnerOrderToFF', 1, ...
	'tSAAnnounceShipArrival', 'pSAShipMsgToCT', 1, ...
	'tSAAskForCTN', 'pSAAskToDepot', 1, ...
	'tSAHanleManifest', 'pSAManifestToCT', 1, ...
	'tSAHanleManifest', 'pSAManifestToCustoms', 1, ...
	'tSAHanleManifest', 'pSAManifestToFF', 1, ...
	'tSAMakeCrewList', 'pSACrewListToSBGS', 1, ...
	'tSAMakeReceipt', 'pSAReceiptToFF', 1, ...
	'tSASendExpenseNote', 'pSAExpenseNoteToOwner', 1, ...
	'tTransportSendCTN', 'pTransportCTNToOwner', 1, ...
	'tTransportSendOutboundCTN', 'pTransportOutboundAndReceiptToDepot', 1
	};

