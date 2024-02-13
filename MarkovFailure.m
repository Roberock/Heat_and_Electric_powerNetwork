function [FDmecst,NETmecst] = MarkovFailure(FDmecst, NETmecst, D)  
apply_random_failure_model = 0;
    if apply_random_failure_model==1 % recovery model to be implemented
        % Mechanical states of nodes --> 0 failure --> 1 operative
            NETmecst=zeros(D.Del.NDn,D.Del.DGtn+1);  % generators meccanical states are all healthy
            NETf = D.GenFailRates;
            %NETr = D.GenRecoveryRates;
            %ppt = NETf./(NETf+NETr);
            NETrnd = rand(D.Del.NDn, D.Del.DGtn+1);
            NETmecst(NETrnd> NETf) = 1; 
            %NETmecst(find((x~=0).*NETrnd > (x~=0).*ppt(ones(D.Del.NDn,1),:))) = 1; 

        % Feeders mecanical state --> 0 failure --> 1 operative
            FDmecst = zeros(D.Del.FDn,1); 
            FDmecst(rand(D.FDn, 1) > D.FDFailRates) = 1; 

    else   % example - all feeders and busses are operative 
            FDmecst=ones(D.Del.FDn,1);              % feeders meccanical states are all healthy
            NETmecst=ones(D.Del.NDn,D.Del.DGtn+1);  % generators meccanical states are all healthy
    end

end