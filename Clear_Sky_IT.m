function  [It]=Clear_Sky_IT(g,long,lat)
%% RADIAZIONE SOLARE CIELO SERENO SU SUPERFICIE ORIENTATA
% GUADAGNO SOLARE PER SUPERFICIE VETRATA CON SHADING SC [W/m2
% Corso di Fisica Tecnica – a.a. 2010/2011 - Docente: Prof. Carlo Isetti
% CALCOLO RADIZIONE SOLARE
% Capitolo 10

% csi is the inclination of the surface in exam (solar pannel, 90 deg for a vertical wall)
csi = 30;
csi=csi/360*2*pi;
% psis is the azimut of the surface in exam(Positive Est, negative Ovest, 0 Sud)
psis = -10;
psis=psis/360*2*pi;
% g=day of the year (e.g. 21 jully>> g = 201)
% fu =longitude of the central meridian within the time zone of interest (in degree)
fu = -15;
% w indica l'angolo giornaliero e nota bene è in radianti
w = g*pi/180;
% d =solar declination in degree
d = 23.45*sin((g+284)*360*pi/(180*365));
d=d/360*2*pi;
% tau time in h of a common clock
 tau =1:1:24;
e = 0.42*cos(w)-3.23*cos(2*w)-0.09*cos(3*w)-7.35*sin(w)-9.39*sin(2*w)-0.34*sin(3*w);
% e represent the time eq. (account for anomalies of the terrestral orbit)
% omega represent the sun angle (l'angolo orario del Sole)
omega = 15*(12-tau)-0.25*(e-4*(long-fu));
omega=omega/360*2*pi;
% lat = latitude of the object of interest 
lat=lat/360*2*pi;
% A is the virtual extratmospheric irradiance 
A = 1150.25+72.43*cos(0.95*g*pi/180)+34.25*sin(0.017*g*pi/180)+1.5*log(g);
% B coefficent of estintion of the atmposphere
B = 1/(6.74+0.026*g-5.13*power(10,-4)*power(g,2)+2.24*power(10,-6)*power(g,3)...
 -2.8*power(10,-9)*power(g,4));
% C is the diffuse irradiation coefficent
C = 1/(16.9+0.0001*g-8.65*power(10,-4)*power(g,2)+3.93*power(10,-6)*power(g,3)...
 -4.005*power(10,-9)*power(g,4));
% beta is the high of the sun over the orrizont
beta = asin(sin(lat).*sin(d)+ cos(lat).*cos(d).*cos(omega));
%loop to exclude negative value for betavalori negativi di beta
beta(beta<0)=0;
% psi indicate the solar azimut (Positive Est, Negative Ovest)
psi = acos(((sin(beta).*sin(lat))-sin(d))./(cos(beta).*cos(lat)));
% negative value for the azimut after midday h12
psi(13:end)=psi(13:end).*-1;
% teta l'angolo di incidenza de3lle radiazioni solari dirette
teta = acos(cos(beta).*cos(psi-psis).*sin(csi)+sin(beta).*cos(csi));
%assegnare valori nulli quando teta< 90
teta(teta>=pi/2)=pi/2;

% IDn rappresenta l'intensità della radiazione diretta normale alla superficie
for tau=1:1:24
 if beta(tau)==0
 IDn(tau)=0;
else
 IDn(tau)= A/(exp(B/sin(beta(tau))));
end
end
% ID indica la radiazione diretta
ID = IDn.*cos(teta);
% F esprime il fattore di vista tra la superficie considerata e la volta celeste
F = (1+cos(csi))./2;
% Id esprime la componente diffusa della radiazione complessiva
Id = C.*IDn*F;
%rog è il coefficiente di riflessione del terreno circostante
rog = 0.3; 
% Ig rappresenta la componente riflessa della radiazione complessiva
Ig = IDn.*(C+sin(beta)).*rog.*(1-F);
% IT esprime la radiazione complessiva somma di ID, Id, Ig. in W/m^2
It=ID+Id+Ig;
It=It/1000;%in[kW/m^2]
%% IRRADIANCE CROSSING A TRANSPARENT WINDOW  
%shading coefficient superficie vetrata
% SC=.77;
% % calcolo radiazione solare trasmessa attraverso vetro con assegnato fattore SC
% a1=.01154;
% a2=0.77674;
% a3=-3.94657;
% a4=8.57661;
% a5=-8.38135;
% a6=3.01188;
% AD=.253.*(a1+a2.*cos(teta)+a3.*cos(teta).^2+ a4.*cos(teta).^3+a5.*cos(teta).^4+a6.*cos(teta).^5);
% Add=.506.*(a1./2+a2./3+a3./4+ a4./5+a5./6+a6./7);
% b1=-.00885;
% b2=2.71235;
% b3=-.62062;
% b4=-7.07329;
% b5=9.75995;
% b6=-3.89922;
% BD=b1+b2.*cos(teta)+b3.*cos(teta).^2+ b4.*cos(teta).^3+b5.*cos(teta).^4+b6.*cos(teta).^5;
% Bdd=2.*(b1./2+b2./3+b3./4+ b4./5+b5./6+b6./7);
% Itra=SC*(ID.*(BD+AD)+(Id+Ig).*(Bdd+Add)); 
end