function [pns] = transport_pdf()

pns.PN_name = 'Transport';

pns.set_of_Ps = {
	'pTransportOutBoundCTNReceived', ...
	'pTransportCTNSent'
	};

pns.set_of_Ts = {
	'tTransportGetOutboundCTN', ...
	'tTransportSendCTN', ...
	'tTransportSendOutboundCTN'
	};

pns.set_of_As = {
	'pTransportCTNSent', 'tTransportGetOutboundCTN', 1, ..., ...
	'pTransportOutBoundCTNReceived', 'tTransportSendOutboundCTN', 1, ...
	};

pns.set_of_ports = {
	'tTransportSendOutboundCTN', ...
	'tTransportSendCTN', ...
	'tTransportGetOutboundCTN'
	};

