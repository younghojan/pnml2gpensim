function [png] = sa_pdf()

png.PN_name = 'sa';

png.set_of_Ps = {
	'pSAEnd', ...
	'pSACTNInfoReceived', ...
	'pSAManifestHandled', ...
	'pSAReceiptSent', ...
	'pSACrewListMade', ...
	'pSAAnnounced', ...
	'pSAShipDeparted', ...
	'pSAAsked'
	};

png.set_of_Ts = {
	'tSAGetCTNInfo', ...
	'tSAMakeReceipt', ...
	'tSAHanleManifest', ...
	'tSAAskForCTN', ...
	'tSAAnnounceShipArrival', ...
	'tSAWaitShipDeparture', ...
	'tSAMakeCrewList', ...
	'tSASendExpenseNote'
	};

png.set_of_As = {
	'pSAAnnounced', 'tSAMakeCrewList', 1, ...
	'pSAAsked', 'tSAGetCTNInfo', 1, ...
	'pSACTNInfoReceived', 'tSAAnnounceShipArrival', 1, ...
	'pSACrewListMade', 'tSAWaitShipDeparture', 1, ...
	'pSAManifestHandled', 'tSAMakeReceipt', 1, ...
	'pSAReceiptSent', 'tSAAskForCTN', 1, ...
	'pSAShipDeparted', 'tSASendExpenseNote', 1, ...
	'tSAAnnounceShipArrival', 'pSAAnnounced', 1, ...
	'tSAAskForCTN', 'pSAAsked', 1, ...
	'tSAGetCTNInfo', 'pSACTNInfoReceived', 1, ...
	'tSAHanleManifest', 'pSAManifestHandled', 1, ...
	'tSAMakeCrewList', 'pSACrewListMade', 1, ...
	'tSAMakeReceipt', 'pSAReceiptSent', 1, ...
	'tSASendExpenseNote', 'pSAEnd', 1, ...
	'tSAWaitShipDeparture', 'pSAShipDeparted', 1
	};

png.set_of_Ports = {
	'tSAMakeCrewList', ...
	'tSAHanleManifest', ...
	'tSAMakeReceipt', ...
	'tSASendExpenseNote', ...
	'tSAGetCTNInfo', ...
	'tSAAskForCTN', ...
	'tSAWaitShipDeparture', ...
	'tSAAnnounceShipArrival'
	};

