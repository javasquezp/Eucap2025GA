function [c, ceq] = constrainFunctionSPAICELEO(variables, positionArray,...
    az0, maxActive)
%%%%%%%%%%%%%%%%%%%%%%%%%%% Reproducibility %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%prvS = rng(2013);

%%%%%%%%%%%%%%%%%%%%%%%%%Defin constans to be used %%%%%%%%%%%%%%%%%%%%%%%%
nBeams = length(az0);
%%%%%%%%%%%%%%%%%%%%%%%%Define  Variables%%%%%%%%%%%%%%%%%%%%%%%%%%%%
activeElements = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

numElements = length(positionArray);

    for i = 1 : nBeams
        wtest = variables((i-1)*numElements+1:i*numElements)';
        w = abs(wtest); %obtain the new weight matrix
           activeElements = activeElements + w;
             
    end
    %%% IMPORTANT%%
    % In this part of the code we can choose how we can limit the power the
    % first is by limiting the total power per element and the second is
    % the overall power
    c = sum(activeElements>maxActive)/length(activeElements);
   % c = sum(activeElements)>pMax;
%     c = sum(sll3D<=sll0);
     ceq = [];



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end
