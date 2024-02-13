classdef DG_module
    % DG_module class:
    % to simulate the power produced by distributed generators 
    %% START Proprieties
    properties
        % PV Panel
        PVn=1%       PVn: number of solar technologies
        PVIPmax=1.32%       PVIPmax: current at max power [A]
        PVItc=1.4%       PVItc: current temperature coef. [mA/Celsius]
        PVIsc=1.8%       PVIsc: short circuit current [A]
        PVTa=30%       PVTa: ambient temperature [Celsius]
        PVTno=43%       PVTno: nominal operating temperature [Celsius]
        PVVPmax=38%       PVVPmax: voltage at max power [V]
        PVVtc=194%       PVVtc: voltage temperature coef. [mV/Celsius]
        PVVoc=55.5%       PVVoc: voltage open circuit [V]
        
        % WIND TURBINE 
        WPrated  =50        %           WPrated: rated power [kW]
        WWSci =3.8000         %           WWSci: cut-in wind speed [m/s]
        WWSrated =9.5         %           WWSrated: rated wind speed [m/s]
        WWSco =23.8         %           WWSco: cut-out wind speed [m/s]

        %Storage
        STPpeak=0.28;       % storage peak power?
        STEs=0.0400;        % storage electric power rating?
        STn=1;               % STn: number of storage technologies
        
        % ON-OFF HeatPump (model Maneurop SH 140-4)
        a1=0.8387;  a2= 0.08744; % Fitting Coefficient HP on-off (Dongelline et al)
        b1=0.01142; b2= 0.001204 ;
        c1=30.68/35; % [KW/deg C]
        c2= 3.615/35;
    end
    
    
    methods
        %% CONSTRUCTOR
        function PVobj  = DG_module(varargin)  % method to define an object of type Scenario_Based_Reliability
            if nargin==0;  return % Create an empty object
            end
            for k=1:2:length(varargin)
                switch lower(varargin{k})
                    case {'data', 'del', 'd', 'datastructure'}
                        % PV
                        PVobj.PVn=varargin{k+1}.PVn; PVobj.PVIPmax=varargin{k+1}.PVIPmax;
                        PVobj.PVItc=varargin{k+1}.PVItc; PVobj.PVIsc=varargin{k+1}.PVIsc;
                        PVobj.PVTa=varargin{k+1}.PVTa; PVobj.PVTno=varargin{k+1}.PVTno;
                        PVobj.PVVPmax=varargin{k+1}.PVVPmax;  PVobj.PVVtc=varargin{k+1}.PVVtc; PVobj.PVVoc=varargin{k+1}.PVVoc;
                        % WT 
                        PVobj.WPrated=varargin{k+1}.WPrated;
                        PVobj.WWSci=varargin{k+1}.WWSci;
                        PVobj.WWSrated=varargin{k+1}.WWSrated;
                        PVobj.WWSco=varargin{k+1}.WWSco;
                        % HeatPump On-Off
                        PVobj.WWSco=varargin{k+1}.a1;
                        PVobj.WWSco=varargin{k+1}.a2;
                        PVobj.b1=varargin{k+1}.b1;
                        PVobj.b2=varargin{k+1}.b2;
                        PVobj.c1=varargin{k+1}.c1;
                        PVobj.c2=varargin{k+1}.c2;
                end
            end
        end     % of constructor
         
        %% power method for the PV pannels 
        function Pow = Power_PV(obj,s,Text,NDn)
            % s sun irradiance
            % Text [Celsius] external air temperature
            % NDn number of nodes
            %   Output
            %        Pow: solar power produced by module(s)
            Idx=ones(NDn,1);
            tc = Text+s(:,ones(1,obj.PVn)).*(obj.PVTno(Idx,:)-20)/0.8;
            iy = s(:,ones(1,obj.PVn)).*(obj.PVIsc(Idx,:)+obj.PVItc(Idx,:).*(tc-25)/1000);
            vy = obj.PVVoc(Idx,:)-obj.PVVtc(Idx,:).*tc/1000;
            ff = (obj.PVVPmax(Idx,:).*obj.PVIPmax(Idx,:))./...
                (obj.PVVoc(Idx,:).*obj.PVIsc(Idx,:));
            Pow = ff.*vy.*iy/1000;
        end
        
        %% power method for the Wind Turbines 
        function Pow = Power_WT(obj,ws,NDn)
            %       ws: wind speed [m/s]
            Pow = zeros(NDn,1);
            %   Case 1:  cut in wind speed < wind speed <= rated wind speed
            clas1 = all((obj.WWSci(ones(NDn,1),:) < ws(:,ones(1,1))).*(ws(:,ones(1,1)) <= obj.WWSrated(ones(NDn,1),:)) == 1);
            %   Case 2:  rated wind speed < wind speed <= cut out speed
            clas2 = all((obj.WWSrated(ones(NDn,1),:) < ws(:,ones(1,1))).*(ws(:,ones(1,1)) <= obj.WWSco(ones(NDn,1),:)) == 1);
            if clas1
                Pow = obj.WPrated(ones(NDn,1),:).*(ws(:,ones(1,1))-obj.WWSci(ones(NDn,1),:))./...
                    (obj.WWSrated(ones(NDn,1),:)-obj.WWSci(ones(NDn,1),:));
            elseif clas2
                Pow = obj.WPrated(ones(NDn,1),:);
            end
        end
        
        %%   DGs Storage systems (ST)
        function Pow = Power_ST(obj,NDn)
             STlev = rand(NDn, obj.STn).*obj.STEs(ones(NDn,1),:); 
             Pow = STlev;
             STPaux = obj.STPpeak(ones(NDn,1),:);
             Pow(Pow > STPaux) = STPaux(Pow > STPaux); 
        end
   
        %% power method for the Heat Pumps Turbines 
        function [Pow_hp,COPdc]=Power_HP_OnOff(obj,Text,Tw)
            %Onn-Off Air-to_Water Heat Pumps
            %  Input
            % Text = External Air Temperature (e.g. Random Variable)
            % Tw = Hot Water Temperature (e.g. 35 deg Celsius)
            %  Output
            % Powhp= Thermal Power Output delivered by the Heat Pump
            % COPdc = Coefficent of Performance  at full load 
            % Power and Coeff of performance at full load
            
            Pow_hp=obj.a1.*Text+obj.b1.*Text.^2+obj.c1.*Tw;
            %COPdc=3.42;
            COPdc=obj.a2.*Text+obj.b2.*Text.^2+obj.c2.*Tw;
            % if the temperature is outside the operative ranges
            Pow_hp(Text<-10 | Text>20)=0;    COPdc(Text<-10 | Text>20)=0;
        end
    end
end

