function [ITot,V,Wind_Events,Lightning_Events]=Weather_Simulator(Tseries,long,lat,g)
ITot=[]; V=[]; 
%% LIGHTNING OCCURRANCE 
%% sequence of HPP for Lightning (with multiple, constant occurance ratio)
%SeasonsInt=[0 1400 2200 2900 3500 4300 5030 5800 6500 7200 8760]; % time of the year
SeasonsInt=linspace(1,8760,13); % 12 months
Light_occurance=[0 0 0.0005 0.0001 0.0085 0.019 0.022  0.015 0.002 0.001 0 0];  % frequency of occurance
Lightning_Events=[];
for i=1:length(Light_occurance)
    Tlight=HPP(Light_occurance(i),SeasonsInt(i+1)-SeasonsInt(i)); 
    Lightning_Events=[Lightning_Events Tlight(2:end-1)+SeasonsInt(i)]; 
end
 %% WIND
Wind_occurane=[0.011 0.012 0.0075 0.0065 0.005 0.006 0.003 0.0029 0.0045 0.0065 0.006 0.009];  % frequency of occurance
Wind_Events=[];
for i=1:length(Wind_occurane)
    Twind=HPP(Wind_occurane(i),SeasonsInt(i+1)-SeasonsInt(i)); 
    Wind_Events=[Wind_Events Twind(2:end-1)+SeasonsInt(i)]; 
end
%Transition data from Malaysian state
%[]  Shamshad et al. "First Order Markov Chain Models for Synthetic
%Generation of Wind Speed Time Series" Energy, 2005, 10.1016/j.energy.2004.05.026

% % wind speed upper and lower bound for the considered states
Vl=[0 2 4 6 8 10 12 14 16 18 20 22];
Vu=[2 4 6 8 10 12 14 16 18 20 22 25];

%First order cumulative transition matrix
Pwindcum=[...
    0.371 0.778 0.952 0.988 0.997 0.998 0.999 1.000 1.000 1.000 1.000 1.000
    0.166 0.612 0.924 0.983 0.995 0.999 0.999 1.000 1.000 1.000 1.000 1.000
    0.051 0.294 0.798 0.961 0.989 0.997 0.999 1.000 1.000 1.000 1.000 1.000
    0.017 0.100 0.403 0.794 0.954 0.989 0.997 0.999 1.000 1.000 1.000 1.000
    0.010 0.045 0.144 0.421 0.803 0.960 0.991 0.998 0.999 1.000 1.000 1.000
    0.006 0.027 0.070 0.178 0.473 0.816 0.962 0.993 0.997 1.000 1.000 1.000
    0.005 0.021 0.048 0.095 0.205 0.507 0.831 0.973 0.994 0.998 1.000 1.000
    0.006 0.022 0.052 0.085 0.140 0.267 0.632 0.871 0.976 0.998 1.000 1.000
    0.009 0.028 0.042 0.060 0.102 0.167 0.307 0.633 0.902 0.981 0.995 1.000
    0.014 0.068 0.123 0.137 0.164 0.192 0.233 0.438 0.726 0.890 0.973 1.000
    0.000 0.000 0.000 0.040 0.040 0.040 0.120 0.240 0.400 0.640 0.920 1.000
    0.000 0.000 0.000 0.000 0.000 0.000 0.000 0.200 0.200 0.400 1.000 1.000];
St=randi(12);%initial wind state
[V]=zeros(1,Tseries);
IT=zeros(round(Tseries/24),24);

for t=1:Tseries
    %Random wind speed depending on the previous state
    V(t)=Vl(St)+rand()*(Vu(St)-Vl(St));
    % new state random consistent with the transition probability
    St= find(Pwindcum(St,:) > rand(), 1, 'first') ;
    
    %% IRRADIANCE CLEAR SKY
    gnew=ceil(t/24);%day of the year
    if g~=gnew %if we are analyzing a new day
        g=gnew;
        [It]=Clear_Sky_IT(g,long,lat); % return clear sky total irradiance for h=1 to h=24 for given day, and given latitude and longitude
        IT(g,:)=It;
    end
    
    %% External Temperature

end
IT=IT';
ITot=IT(:)';
end
