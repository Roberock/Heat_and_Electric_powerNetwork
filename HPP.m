%% HPP
function T=HPP(lambda,Tmax)
% lambda=input('Enter The lambda:');   % arrival rate
% Tmax=input('Enter maximum time:');         % maximum time
% clear T;
T(1)= 0;
i=1;

while T(i) < Tmax,
    U(i)=rand(1,1);
    T(i+1)=T(i)-(1/lambda)*(log(U(i)));
    i=i+1;
end

T(i)=Tmax;
end
%
% stairs(T(1:(i)), 0:(i-1));
% title(['A Sample path of the Poisson process with arrival rate ', num2str(lambda)])
% xlabel(['Time'])
% ylabel(['Number of Arrivals in [0,', num2str(Tmax), ']',])