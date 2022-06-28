### Code for the simulation of a combine heat and electric network

# Citations
[]R. Rocchetta and E. Patelli, "Stochastic analysis and reliability-cost optimization of distributed generators and air source heat pumps," 2017 2nd International Conference on System Reliability and Safety (ICSRS), 2017, pp. 31-35, doi: 10.1109/ICSRS.2017.8272792.
[] X. Liu, J. Wu, N. Jenkins and A. Bagdanavicius, "Combined analysis of electricity and heat networks", Applied Energy, vol. 162, pp. 1238-1250, 2016.

## Functionality
 
MC_HP.m : power production model for multi-compressor Air-to-Water HPs
OnOff_HP.m: power production model for the On-Off Air-to_Water Heat Pumps model Maneurop SH 140-4
HPP.m : sample from homogeneous Poisson Process HPP
MarkovFailure.m : randomize failures of the network components
MC_HEATPOWER(X, D) : Monte Carlo simulation of the combined grid X= allocation matrix D=data structure for the combined grid
D.mat data structure containing,
Del data for the electrical grid
Dth data for the thermal grid 
Weather data to simulate the weather conditions
DG_module.m : This class simulate the power production behaviour of different types of distributed generators
Weather_Simulator.m: simulator for the uniform weather conditions on the power grid (wind speed, irradiance, lightning strike density
PowEl2PowTh.m   function converting electrical power to thermal power
OPF.m: Optimal power flow function considering virtual generators
 
 
 Example1_MonteCarlo.m  an example of reliability/resilience assessment (energy not suppllied distribution) by the combined heat and electric power grid. Carried out via Monte Carlo simulation for an allocation matrix.
 Data_intro_ElectricThermal_NetworkBarryIsalnd.m step-by-step description of the combined grid data and economic dispatch simulation 
