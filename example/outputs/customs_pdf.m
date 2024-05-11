function [pns] = customs_pdf()

pns.PN_name = 'Customs';

pns.set_of_Ps = {
	'pCustomsEnd', ...
	'pCustomsCIQed', ...
	'pCustomsInspected', ...
	'pCustomsAppointmentReceived', ...
	'pCustomsDeclared'
	};

pns.set_of_Ts = {
	'tCustomsDeclareSuccess', ...
	'tCustomsCIQ', ...
	'tCustomsSendClearance', ...
	'tCustomsInspect', ...
	'tCustomsGetAppointment'
	};

pns.set_of_As = {
	'pCustomsCIQed', 'tCustomsInspect', 1, ..., ...
	'pCustomsInspected', 'tCustomsSendClearance', 1, ..., ...
	'pCustomsDeclared', 'tCustomsGetAppointment', 1, ..., ...
	'pCustomsAppointmentReceived', 'tCustomsCIQ', 1, ...
	};

pns.set_of_ports = {
	'tCustomsGetAppointment', ...
	'tCustomsDeclareSuccess', ...
	'tCustomsCIQ', ...
	'tCustomsSendClearance'
	};

