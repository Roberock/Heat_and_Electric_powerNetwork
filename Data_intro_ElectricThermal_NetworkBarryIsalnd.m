clc; clear variables
% see [1] for the original description of the heat-electric power network
% case study and [2] for an application within a stochastic optimization framwork
%   [1]  Xuezhi Liu et al "Combined analysis of electricity and heat networks ", Applied Energy, 
%            Volume 162, 15 January 2016, Pages 1238-1250  
%  DOI    https://doi.org/10.1016/j.apenergy.2015.01.102

%   [2]  R.Rocchetta and E.Patelli, "Stochastic analysis and reliability-cost optimization
%            of distributed generators and air source heat pumps", 2017 2nd International Conference on System Reliability and Safety (ICSRS)
%        https://strathprints.strath.ac.uk/72133/1/https://ieeexplore.ieee.org/document/8272792.pdf
 
%% Example of how to define a data structure for the electric network  
% System topology clc; clear variables
% see [1] for the original description of the heat-electric power network
% case study and [2] for an application within a stochastic optimization framwork
%   [1]  Xuezhi Liu et al "Combined analysis of electricity and heat networks ", Applied Energy,
%            Volume 162, 15 January 2016, Pages 1238-1250
%  DOI    https://doi.org/10.1016/j.apenergy.2015.01.102

%   [2]  R.Rocchetta and E.Patelli, "Stochastic analysis and reliability-cost optimization
%            of distributed generators and air source heat pumps", 2017 2nd International Conference on System Reliability and Safety (ICSRS)
%        https://strathprints.strath.ac.uk/72133/1/https://ieeexplore.ieee.org/document/8272792.pdf

% Temp=load('D.mat');
% Del= Temp.D.Del; % electrical grid data
% Dth= Temp.D.Dth; % thermal grid data
%% Example of how to define a data structure for the electric network
% System topology
Del.NDn=8; % number of nodes
Del.FDn=7; % number of feeders (links between the nodes)
Del.FDks=[1;2;3;4;8;5;6];  % start node
Del.FDke=[2;3;4;8;5;6;7];  % end node
Del.FDAmp=[400;400;400;400;400;400;400]; % Ampacity [A], maxiumum current a cable can carry without exceeding its thermal limit

% Nodes parameters (generators positions and propreties
Del.MSn=3; % number of main generator sources
Del.MStyp=[1;2;1]; % Generators Type: one is Gas Turbine(2) and two is-steam Turbines (1)
Del.MSnod=[2,7,8]; % nodes where the main generating sources are located
Del.DGtn=4; %

% links (power cables) parameters
Del.FDX=0.08; % Reactance [Ohm/km]
Del.FDR=0.164; % Resistance [Ohm/km]
Del.Lengths=[260;170;230;320;200;160;260];  % Lenght of the links

% Nodes parameters (random power demanded, produced and base voltage)
Del.muLDth=[0.2;0;0.5;0.5;0.2;0.2;0;0]; % mean Load Demand
Del.stdLDth=[0.02;0;0.05;0.05;0.02;0.02;0;0]; % standard deviation of the Demand
Del.MSmu=[20;10;20]; % mean power produced by the main generators
Del.MSsig=[2;1;2]; % standard deviation of the power produced by the main generators
Del.Vnom=11; % base voltage in [kV]

% Cost data
Del.Cm=[1.3;1/0.79]; % Cost for Gas Turbine(2) and two is-steam Turbines (???)
Del.MSCo=0.1450; % Main Generators operational cost
Del.PVCo=3.7670e-05; % Potovolt operational cost
Del.WCo=0.0390; % Wind Turbine operational cost
Del.EVCo=0.0210; % El Vehicles operational cost
Del.STCo=4.6284e-5; % Storage operational cost
Del.VGCo=1e9; % Virtual generators operational cost
Del.Z=8.1;  % t.b.d.
Del.MScap=[40;40;50]; % t.b.d.

% Distributed generators data and production cost
Del.pckg=[50,1,1,50];% pakaging factors
Del.VGcap=10000; % Virtual generators capacity (virtually inf)
Del.ts=1; % 1-h simulation time step

Del.STn=1; % storages number of technologies
Del.STEs=0.04; % storage parameter
Del.STPpeak=0.2800; % storage peak output

Del.PVn=1; % PV number of technologies
Del.PVTa=30; % PV parameters
Del.PVTno=43; %
Del.PVIsc=1.8; %
Del.PVItc=1.4;%
Del.PVVoc=55.5; %
Del.PVVtc=194;%
Del.PVVPmax=38;%
Del.PVIPmax=1.32;%
Del.EVPp=6.73;% EV power
Del.SCn=300;%
Del.Inc=0.0240; %
Del.MScm=1.3;%
Del.SCn=7e2;%

Del.WWSrated=9.5; % rated Wind
Del.Eprice=@(L)-5.13717E-09*L^2+5.31538E-05*L; % price of the electricity from the total load demanded L

%% Barry island: Load the Heat District Network data
Temp=load('D.mat');
Dth=Temp.D.Dth; % load the structure of the 'thermal' network

%% show topology of the two networks (not linked)
G_th=graph(Dth.From_Node,Dth.To_Node);
G_th.plot;
hold on; grid on
G_el=graph(Del.FDks,Del.FDke);
G_el.plot
legend('Thermal nodes', 'Electrical nodes')

%% Sample External Environmental Conditions

long=-3.27;      % Barry Island UK Longitude
lat=51.3;        % Barry Island UK Latitude
SCn= 200; % Number of samples
Ndays=5; % number of days 
[ITot,ws,~,~]=Weather_Simulator(SCn,long,lat,24*Ndays); %  Generate weather history
% ITot clear sky irradiance
% ws wind speed
% s total 'real' irradiance
a= 0.2579; b= 0.7264; % distribution parameters
s=betarnd(a , b,size(ITot)).*ITot; 
Tamb=normrnd(6,3); % Example of normal distributed Temperature
subplot(2,1,1)
% display weather samples 
plot(ITot); hold on;
xlabel('IX of the simulated hour'); ylabel('irradiance')
plot(s,'.-r'); legend('clear sky irr', 'with cloud cover')
subplot(2,1,2)
plot(ws); hold on;
xlabel('IX of the simulated hour'); ylabel('wind speed [m/s]') 
%% 1) Start With Electric Network Economic Dispatch
% The Generators Allocation Matrix
%x=zeros(Del.NDn,Del.DGtn+1); % zero generators over the NDn nodes and for the Del.DGtn+1 technologies
% user-defined el-grid allocation matrix
% MS PV WT EV ST 
x=[   0,11,  0, 0, 13   % node 1
      0, 0,  1, 0, 15   % node 2
      0, 4,  4, 0, 5   % node 3
      0, 0,  0, 0, 5   % node 4
      0, 4,  0, 0, 20   % node 5
      0, 0,  0, 0, 2   % node 6
      0, 1,  1, 0, 0   % node 7
      0, 9,  1, 0, 40]; % node 8
  
x(Del.MSnod,1)=1; % add main generators in the first colum
 
% the meccanical states
FDmecst=ones(Del.FDn,1);                  %feeders meccanical state
NETmecst=ones(Del.NDn,Del.DGtn+1);        %feeders meccanical state
% Loads
LD=normrnd(Del.muLDth,Del.stdLDth);      % MWel of the 5 lumped electrical loads
% MS (Main power sources)
MSPp = normrnd(Del.MSmu, Del.MSsig);
MSPav = MSPp(ones(Del.NDn,1),:);

% Distirbuted generators  (DG)
DGmdl=DG_module();% define generic DG module

% Photovoltaic PV
Sun= 1; % irradiance 
Text=29; % ambient temperature
PVPav=DGmdl.Power_PV(Sun,Text,Del.NDn); % available power from PV pannles
PVPav = PVPav.*NETmecst(:,2).*x(:,2);

% Wind turbines WT
WSpeed=15; % wind speed
WPav=DGmdl.Power_WT(WSpeed,Del.NDn);   % available power from wind turbines
WPav = WPav.*NETmecst(:,3).*x(:,3);

% Electric Vehicles EV (to do)
%..
EVav=zeros(Del.NDn,1);

% Storages (ST)
STPav=DGmdl.Power_ST(Del.NDn);  % available power from storages
STPav = STPav.*NETmecst(:,5).*x(:,5); % remove failed comp and use allocation matrix

%Matrix of electric power Available
NETPavM = [MSPav PVPav WPav EVav STPav].*[ones(Del.NDn,1) Del.pckg(ones(Del.NDn,1), 1:4 )]; 

Del.NDn=8; % number of nodes
Del.FDn=7; % number of feeders (links between the nodes)
Del.FDks=[1;2;3;4;8;5;6];  % start node
Del.FDke=[2;3;4;8;5;6;7];  % end node
Del.FDAmp=[400;400;400;400;400;400;400]; % Ampacity [A], maxiumum current a cable can carry without exceeding its thermal limit 

% Nodes parameters (generators positions and propreties
Del.MSn=3; % number of main generator sources
Del.MStyp=[1;2;1]; % Generators Type: one is Gas Turbine(2) and two is-steam Turbines (1)
Del.MSnod=[2,7,8]; % nodes where the main generating sources are located
Del.DGtn=4; % 

% links (power cables) parameters
Del.FDX=0.08; % Reactance [Ohm/km]
Del.FDR=0.164; % Resistance [Ohm/km]
Del.Lengths=[260;170;230;320;200;160;260];  % Lenght of the links

% Nodes parameters (random power demanded, produced and base voltage)
Del.muLDth=[0.2;0;0.5;0.5;0.2;0.2;0;0]; % mean Load Demand
Del.stdLDth=[0.02;0;0.05;0.05;0.02;0.02;0;0]; % standard deviation of the Demand
Del.MSmu=[20;10;20]; % mean power produced by the main generators
Del.MSsig=[2;1;2]; % standard deviation of the power produced by the main generators
Del.Vnom=11; % base voltage in [kV] 

% Cost data
Del.Cm=[1.3;1/0.79]; % Cost for Gas Turbine(2) and two is-steam Turbines (???)
Del.MSCo=0.1450; % Main Generators operational cost
Del.PVCo=3.7670e-05; % Potovolt operational cost
Del.WCo=0.0390; % Wind Turbine operational cost
Del.EVCo=0.0210; % El Vehicles operational cost
Del.STCo=4.6284e-5; % Storage operational cost
Del.VGCo=1e9; % Virtual generators operational cost 
Del.Z=8.1;  % t.b.d. 
Del.MScap=[40;40;50]; % t.b.d.

% Distributed generators data and production cost
Del.pckg=[50,1,1,50];% pakaging factors
Del.VGcap=10000; % Virtual generators capacity (virtually inf)
Del.ts=1; % 1-h simulation time step
 
Del.STn=1; %
Del.STEs=0.04; %
Del.STPpeak=0.2800; %

Del.PVn=1; % 
Del.PVTa=30; %
Del.PVTno=43; %
Del.PVIsc=1.8; %
Del.PVItc=1.4;%
Del.PVVoc=55.5; %
Del.PVVtc=194;%
Del.PVVPmax=38;%
Del.PVIPmax=1.32;%
Del.EVPp=6.73;%
Del.SCn=300;%
Del.Inc=0.0240; %
Del.MScm=1.3;%
Del.SCn=7e2;%

Del.WWSrated=9.5; % rated Wind 
Del.Eprice=@(L)-5.13717E-09*L^2+5.31538E-05*L; % price of the electricity from the total load demanded L

%% Barry island: Load the Heat District Network data
Temp=load('D.mat');
Dth=Temp.D.Dth; % load the structure of the 'thermal' network
 
%% show topology of the two networks (not linked)
figure
G_th=graph(Dth.From_Node,Dth.To_Node);
G_th.plot;
hold on; grid on
G_el=graph(Del.FDks,Del.FDke);
G_el.plot
legend('Thermal nodes', 'Electrical nodes')
 
 
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



 
