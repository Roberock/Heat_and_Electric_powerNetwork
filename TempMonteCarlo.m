%% This script shows how to run a Monte Carlo Simultion Analysis on the Berry isalnd Heat-Power Network
clc;
clear variables;
close all;
%% Load Network Data
Data=load('D.mat');
D=Data.D;
D.Del.SCn=800; % Number of Monte Carlo samples (240= 10 days)
D.Dth.Cost_onoff=10000; % 10000 £ an approx. investment cost for an on-off heat pumps
%% Initialize a matrix of Distributed Generators

% Xnom contains the allocation matrix for the electric and thermal grids
% an allocation matrix defines the number and tyoe of generators in each node of the
% grid, for instance
% x_el is a matrix [N_electric_nodes x N electric generator types]
% x_el(D.Del.MSnod,1)=1 ; % allocate the main generators
% x(:,2)=0*(1:D.Del.NDn); % zeros pvoltaic pannels
% x(:,3)=0*(D.Del.NDn+1:2*D.Del.NDn); %zeros wind turbines
% x(:,4)=0*(2*D.Del.NDn+1:3*D.Del.NDn); %zeros electric vehicles
% x(:,5)=0*(3*D.Del.NDn+1:4*D.Del.NDn); %zeros storage systems

% a random allocation matrix
% MS PV WT EV ST
x_el =[0,10,0,20,3; % node 1
    2,0,1,0,1;   % node 2
    0,12,2,0,0;  % node 3
    0,0,1,10,2;  % node 4
    0,10,0,0,10; % node 5
    0,0,0,0,2;   % node 6
    2,15,10,0,0; % node 7
    2,12,1,2,10];% node 8

% I still have to update the code for the EV
%. ..so consider onlu allocation matrix of Main Generators, PV panels, Wind
%Turbines and Storage systems
Xnom.x_el=x_el(:,[1:3,5]);
Xnom.x_th(:,1)=zeros(D.Dth.Nnodes,1); % allocation matrix of On-OFF Heat Pumps
Xnom.x_th(1:15,1)=1; % we consider only one type of heat generator (ON-OFF HeatPump)

%% run the monte carlo
[RES] = MC_HEATPOWER(Xnom, D); 
figure
subplot(5,2,1)
plot(cumsum(RES.pdfENS));xlabel('Time');title('Cumulative sum of Energy not supplied'); grid on;
subplot(5,2,2)
plot(RES.pdfCg);xlabel('Time');title('Operational cost of the network'); grid on;
subplot(5,2,3)
plot(RES.pdfLDel.el);xlabel('Time');title('Electric load demand'); grid on;
subplot(5,2,4)
plot(RES.pdfLDel.th);xlabel('Time');title('Thermal load demand'); grid on;
subplot(5,2,5)
plot(RES.pdfLDel.th_to_elbackup);xlabel('Time');title('Thermal load served by electric back-ups'); grid on;
subplot(5,2,6)
plot(RES.pdfDGP_RES);xlabel('Time');title('Renewable power used'); grid on;
subplot(5,2,7)
plot(RES.pdfNETuP);xlabel('Time');title('Total power used'); grid on;
subplot(5,2,8)
plot(RES.pdfDGPp(:,1));xlabel('Time');title('Solar PV production'); grid on;
subplot(5,2,9)
plot(RES.pdfDGPp(:,2));xlabel('Time');title('Wind Turbines production'); grid on;
subplot(5,2,10)
plot(sum(RES.MecStates.FDmecst,2));xlabel('Time');title('Available electrical cables'); grid on;