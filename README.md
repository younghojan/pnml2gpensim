# pnml2gpensim
A Python Toolkit for Converting PNML Files to GPenSIM Format

The reason for developing this project is that I need to complete the homework for COMP620052: Concurrency: Theory and Practice, a graduate course at the School of Computer Science and Technology, Fudan University. Contributions and issues are welcome.



## PNML

The Petri Net Markup Language (PNML) is a proposal of an XML-based interchange format for Petri nets. Originally, the PNML was intended to serve as a file format for the Java version of the [Petri Net Kernel ](http://www2.informatik.hu-berlin.de/top/pnk/index-engl.html).



## WoPeD

[WoPeD](https://github.com/woped/WoPeD) is an easy-to-use software tool for editing, simulating and analyzing workflow nets as well as plain place-transition Petri nets. WoPeD is being developed continuously by faculty members and students at the University of Cooperative Education ("Berufsakademie") Karlsruhe/Germany in conjunction with a group of graduates who now are IT professionals in local partner companies. 



## GPenSIM

GPenSIM (General Purpose Petri net Simulator) is a tool for modeling, simulation, and performance evaluation of discrete-event systems. GPenSIM can integrate with MATLAB, allowing users to leverage MATLAB's powerful features for model analysis and visualization.



## Usage

To use pnml2gpensim to convert a PNML file into a file recognizable by gpensim (a MATLAB `.m` file), the following conditions must be met:

1. Each place and transition should be named using camel case, like
   - Place: p+YourModuleName+OtherInfo, for example `pTransportMsgSent` indicates that the place belongs to the "Transport" module.
   - Transition:  t+YourModuleName+OtherInfo, for example `tTransportSendMsg` indicates that the transition belongs to the "Transport" module.
2. IMCs (Inter-Module Connectors) should be defined as follows:
   1. It is a place, for example `pTransportToOwnerMsg`.
   2. A transition that it points to does not belong to the same module as it (identified through naming), such as `tTransportSendMsg -> pTransportToOwnerMsg tOwnerWaitMsg`.
3. The IO ports for each module should be defined as a transition connected to any IMC.



