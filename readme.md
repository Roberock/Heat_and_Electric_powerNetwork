### Code for the simulation of a combine heat and electric network

# Citations
[]R. Rocchetta and E. Patelli, "Stochastic analysis and reliability-cost optimization of distributed generators and air source heat pumps," 2017 2nd International Conference on System Reliability and Safety (ICSRS), 2017, pp. 31-35, doi: 10.1109/ICSRS.2017.8272792. <br />

[] X. Liu, J. Wu, N. Jenkins and A. Bagdanavicius, "Combined analysis of electricity and heat networks", Applied Energy, vol. 162, pp. 1238-1250, 2016.

## Functionality
MC_HP.m : power production model for multi-compressor Air-to-Water HPs ; <br />
OnOff_HP.m: power production model for the On-Off Air-to_Water Heat Pumps model Maneurop SH 140-4 ; <br />
HPP.m : sample from homogeneous Poisson Process HPP; <br />
MarkovFailure.m : randomize failures of the network components; <br />
MC_HEATPOWER(X, D) : Monte Carlo simulation of the combined grid X= allocation matrix D=data structure for the combined grid; <br />
D.mat data structure containing; <br />
Del data for the electrical grid; <br />
Dth data for the thermal grid ; <br />
Weather data to simulate the weather conditions; <br />
DG_module.m : This class simulate the power production behaviour of different types of distributed generators; <br />
Weather_Simulator.m: simulator for the uniform weather conditions on the power grid (wind speed, irradiance, lightning strike density; <br />
PowEl2PowTh.m   function converting electrical power to thermal power; <br />
OPF.m: Optimal power flow function considering virtual generators; <br />
 
 
 Example1_MonteCarlo.m  an example of reliability/resilience assessment (energy not suppllied distribution) by the combined heat and electric power grid. Carried out via Monte Carlo simulation for an allocation matrix; <br />
 Data_intro_ElectricThermal_NetworkBarryIsalnd.m step-by-step description of the combined grid data and economic dispatch simulation; <br />
