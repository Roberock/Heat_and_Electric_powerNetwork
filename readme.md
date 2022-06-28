# Code for the simulation of a combine heat and electric network

## Citations
[]R. Rocchetta and E. Patelli, "Stochastic analysis and reliability-cost optimization of distributed generators and air source heat pumps," 2017 2nd International Conference on System Reliability and Safety (ICSRS), 2017, pp. 31-35, doi: 10.1109/ICSRS.2017.8272792. <br />

[] X. Liu, J. Wu, N. Jenkins and A. Bagdanavicius, "Combined analysis of electricity and heat networks", Applied Energy, vol. 162, pp. 1238-1250, 2016.

## Functionality
_MC_HP.m_ : power production model for multi-compressor Air-to-Water HPs ; <br />
_OnOff_HP.m_ : power production model for the On-Off Air-to_Water Heat Pumps model Maneurop SH 140-4 ; <br />
_HPP.m_: sample from homogeneous Poisson Process HPP; <br />
_MarkovFailure.m_ : randomize failures of the network components; <br />
_MC_HEATPOWER(X, D)_ : Monte Carlo simulation of the combined grid X= allocation matrix D=data structure for the combined grid; <br />
_D.mat_ data structure containing; <br />
  _Del_ data for the electrical grid; <br />
  _Dth_ data for the thermal grid ; <br />
  _Weather_ : data to simulate the weather conditions; <br />
_DG_module.m_ : This class simulate the power production behaviour of different types of distributed generators; <br />
_Weather_Simulator.m_ : simulates weather conditions on the power grid given geo-location and day of the year (wind speed, irradiance, lightning strike density; <br />
_PowEl2PowTh.m_ :   function converting electrical power to thermal power; <br />
_OPF.m_ : Optimal power flow function considering virtual generators; <br />
_Clear_Sky_IT_ : Compute clear sky irradiance

## Examples 
_Example1_MonteCarlo.m_ : an example of reliability/resilience assessment (energy not suppllied distribution) by the combined heat and electric power grid. Carried out via Monte Carlo simulation for an allocation matrix; <br />
_Data_intro_ElectricThermal_NetworkBarryIsalnd.m_ : step-by-step description of the combined grid data and economic dispatch simulation; <br />
