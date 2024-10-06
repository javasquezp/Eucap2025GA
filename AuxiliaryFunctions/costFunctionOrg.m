function [fCost] = costFunction(variables, array, az0, el0, sllAz0, sllEl0,...
    w, angRange, bwAzo, bwElo, frequency, cSpeed)
%%
%%%%%%%%%%%%%%%%%%%%%%%%Define Global Variables%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Extracting azimuth and elevation cuts
format = 'rectangular';
plotType = 'Powerdb';
plotStyle = 'Overlay';
wtest = variables';
w = w.*wtest; %obtain the new weight matrix
%Obtain the radiation pattern cuts
elCut = pattern(array, frequency, az0, angRange, 'PropagationSpeed', ...
    cSpeed, 'CoordinateSystem', format ,'weights', [w], ...
        'Type', plotType, 'PlotStyle', plotStyle);
azCut = pattern(array, frequency, angRange, el0, 'PropagationSpeed', ...
    cSpeed, 'CoordinateSystem', format ,'weights', [w], ...
        'Type', plotType, 'PlotStyle', plotStyle);

%%%%%%%%%%%%%%%%%%%%%%%%%%%Extracting Information%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%Extracting beam information
%SLL
[sllAz, sllEl] = sllExtraction(azCut, elCut);

%Beamwidth
bwAz = beamwidthCalculation(angRange, azCut,-3);
bwEl = beamwidthCalculation(angRange, elCut,-3);
gain = 10*log10(42000./(bwAz.*bwEl));
%Gain
%%%%%%%%%%%%%%%%%%%%%%%%%Cost Function%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
k1 = 1;
k2 = 2;
Z1 = abs(bwAz - bwAzo) + abs(bwEl - bwElo); %Cost function for bw
if sllAz>sllAz0 && sllEl>sllEl0 
    Z2 = 0;
else
    Z2 = abs(sllAz-sllAz0)./sllAz0 +abs(sllEl-sllEl0)/sllEl0;
end

fCost = Z1 + k2*Z2;
%fCost(1) = Z1;
%fCost(2) = Z2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end