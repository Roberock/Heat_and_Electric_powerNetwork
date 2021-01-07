%% NHPP
function NHPP(lambda,Tmax)
lambda=input('Enter The arrival Rate:');   % arrival rate
Tmax=input('Enter maximum time:');         % maximum time
clear T;
T(1)= 0;
a=input('Enter constant a>0:');
b=input('Enter constant b<1:');
S(1)=0;
i=1;

while T(i) < Tmax,
  U(i)=rand(1,1);
  T(i+1)=T(i)-(1/lambda)*(log(U(i))); % Homogeneous Poisson Distr.
  lambdat=a*(T(i+1))^(-b);
  u(i)=rand(1,1);
  if u(i)<=lambdat/lambda % <-- Here is my doubt/question
    i=i+1;
    S(i)=T(i);            % <-- Here is my doubt/question
  end
end
stairs(S(1:(i)), 0:(i-1));
title(['A Sample path of the non homogeneous Poisson process']);
xlabel(['Time interval']);
ylabel([' Number of event ']);