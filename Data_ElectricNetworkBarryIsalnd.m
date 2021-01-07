clc 
clear variables
%% Barry island Electric Network Data
Del.NDn=8;
Del.FDn=7;
Del.MSn=3;
Del.MStyp=[1;2;1]; % 1 is Gas Turbine, 2 is steam Turbine
Del.MSnod=[2,7,8];
Del.DGtn=4;
Del.FDX=0.08; % Reactance Ohm/km
Del.FDR=0.164; % Reactance Ohm/km
Del.Lengths=[260;170;230;320;200;160;260];  %line Lenght
Del.muLDth=[0.2;0;0.5;0.5;0.2;0.2;0;0]; % load Demanded
Del.stdLDth=[0.02;0;0.05;0.05;0.02;0.02;0;0]; % load Demanded
Del.Cm=[1.3;1/0.79];
Del.Z=8.1; %
Del.MSmu=[20;10;20];
Del.MSsig=[2;1;2];
Del.MScap=[40;40;50];
Del.Vnom=11; % base voltage in [kV]
Del.FDks=[1;2;3;4;8;5;6];  % start node
Del.FDke=[2;3;4;8;5;6;7];  % end node
Del.FDAmp=[400;400;400;400;400;400;400];
Del.MSCo=0.1450; % Main Generators cost
Del.PVCo=3.7670e-05; % Potovolt cost
Del.WCo=0.0390; % Wind Turbine cost
Del.EVCo=0.0210; % El Vehicles cost
Del.STCo=4.6284e-5; % Storage cost
Del.VGCo=1e9; % Virtual generators cost
Del.pckg=[50,1,1,50];% pakaging factors
Del.VGcap=10000; % Virtual generators capacity
Del.ts=1; % 1h simulation time
% Storages
Del.STn=1;
Del.STEs=0.04;
Del.STPpeak=0.2800;
 %% Barry island: Now Heat District Network Solution
load('D.mat')
 

%% Sample External Environmental Conditions
Tamb=normrnd(6,3); % Heating Temperature Normally Distributed
% Compute Thermal power Demand

%% 1) Start With Electric Network Economic Dispatch
% The Generators Allocation Matrix
x=zeros(Del.NDn,Del.DGtn+1);
x(Del.MSnod,1)=1;
% the meccanical states
FDmecst=ones(Del.FDn,1);                  %feeders meccanical state
NETmecst=ones(Del.NDn,Del.DGtn+1);        %feeders meccanical state
% Loads
LD=normrnd(Del.muLDth,Del.stdLDth);      % MWel of the 5 lumped electrical loads
% MS
MSPp = normrnd(Del.MSmu, Del.MSsig);
MSPav = MSPp(ones(Del.NDn,1),:);
% DGs Storage systems (ST)
ik=1;
STlev = rand(Del.NDn, Del.STn).*Del.STEs(ones(Del.NDn,1),:);
STPav = STP(STlev, x(:,1+ik), Del);
STPav = STPav.*NETmecst(:,1+ik);
% MCHP
% DGPav=[..Pav MCHPav STPav] 
DGPav=x(:,2:end); 
NETPavM=[MSPav DGPav];        %Matrix of electric power Available 
[Pgen,ENS, NETminCo, PNETu, PDGu, ef] = OPF(x, NETPavM, LD, FDmecst, Del);
PowTh=PowEl2PowTh(Pgen,Del);



 