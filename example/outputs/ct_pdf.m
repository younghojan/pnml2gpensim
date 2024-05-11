function [pns] = ct_pdf()

pns.PN_name = 'CT';

pns.set_of_Ps = {
	'pCTArrivalMsgSent', ...
	'pCTCTNLoaded', ...
	'pCTEnd', ...
	'pCTClearanceReceived'
	};

pns.set_of_Ts = {
	'tCTSendArrivalMsg', ...
	'tCTLoadCTN', ...
	'tCTDeparture', ...
	'tCTGetClearance'
	};

pns.set_of_As = {
	'pCTCTNLoaded', 'tCTSendArrivalMsg', 1, ..., ...
	'pCTClearanceReceived', 'tCTDeparture', 1, ..., ...
	'pCTArrivalMsgSent', 'tCTGetClearance', 1, ...
	};

pns.set_of_ports = {
	'tCTDeparture', ...
	'tCTSendArrivalMsg', ...
	'tCTLoadCTN', ...
	'tCTGetClearance'
	};

