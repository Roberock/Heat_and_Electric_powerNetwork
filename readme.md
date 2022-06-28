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
_DG_module.m_ : This class simulate the power production behaviour of different types (PV, EV, ST, WT, HP) of distributed generators; <br />
_Weather_Simulator.m_ : simulates weather conditions on the power grid given geo-location and day of the year (wind speed, irradiance, lightning strike density; <br />
_PowEl2PowTh.m_ :   function converting electrical power to thermal power; <br />
_OPF.m_ : Optimal power flow function considering virtual generators; <br />
_Clear_Sky_IT_ : Compute clear sky irradiance

## Examples 
_Example1_MonteCarlo.m_ : an example of reliability/resilience assessment (energy not suppllied distribution) by the combined heat and electric power grid. Carried out via Monte Carlo simulation for an allocation matrix; <br />
_Data_intro_ElectricThermal_NetworkBarryIsalnd.m_ : step-by-step description of the combined grid data and economic dispatch simulation; <br />


```
Temp=load('D.mat'); % load data
Del= Temp.D.Del; % electrical grid data
Dth= Temp.D.Dth; % thermal grid data
Wtr= Temp.D.Weather; % weather data
```

```
 %% show topology of the two networks (not linked and separatelly)
figure(10)
G_th=graph(D.Dth.From_Node,D.Dth.To_Node);
G_th.plot;
hold on; grid on
G_el=graph(D.Del.FDks,D.Del.FDke);
G_el.plot
legend('Thermal nodes', 'Electrical nodes')
```   

![alt text](https://github.com/Roberock/Heat_and_Electric_powerNetwork/figs/CombinedGridTopology.jpg?raw=true)



```
% electrical allocation matrix
% MS PV WT EV ST 
x_el=[0,11, 0,0,13   % node 1
      1, 0,11,0, 1   % node 2
      0,11,23,0,10   % node 3
      0, 0,11,0,21   % node 4
      0,11, 0,0,11   % node 5
      0, 0, 0,0, 2   % node 6
      1,11,11,0, 0   % node 7
      1,11,11,0,11]; % node 8
```    






```
 
```   
