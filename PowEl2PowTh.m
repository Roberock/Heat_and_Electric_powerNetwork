function PowTh=PowEl2PowTh(MGPgen,D)
%% simple example model for converting residual thermal to electrical power demand
    Powelcon=0.6; % MWel power output of extration unit in full condensing mode 
    Powthcon=0; % MWth power output of extration unit in full condensing mode 
    PowTh=zeros(size(MGPgen));
    PowTh(D.MStyp==1)=MGPgen(D.MStyp==1).*D.Cm; % gas turbines
    PowTh(D.MStyp==2)=(Powelcon-MGPgen(D.MStyp==2)).*D.Z+Powthcon; % steam turbines 
end