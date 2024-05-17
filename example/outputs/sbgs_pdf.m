function [png] = sbgs_pdf()

png.PN_name = 'sbgs';

png.set_of_Ps = {
	'pSBGSEnd'
	};

png.set_of_Ts = {
	'tSBGSRegistration'
	};

png.set_of_As = {
	'tSBGSRegistration', 'pSBGSEnd', 1
	};

png.set_of_Ports = {
	'tSBGSRegistration'
	};

