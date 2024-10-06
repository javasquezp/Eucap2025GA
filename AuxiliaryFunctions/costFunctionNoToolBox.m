function [fCost] = costFunctionNoToolBox(variables, positionArray, az0, el0, sll0,...
    w, angRange, bwAzo, bwElo, frequency, cSpeed)
%%
%%%%%%%%%%%%%%%%%%%%%%%%Define Global Variables%%%%%%%%%%%%%%%%%%%%%%%%%%%%
az = angRange;
el = angRange;
azShort = [angRange(1):2:angRange(end)];
elShort = [angRange(1):2:angRange(end)];
[azM, elM] = meshgrid(azShort, elShort);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Extracting azimuth and elevation cuts
format = 'rectangular';
plotType = 'Powerdb';
plotStyle = 'Overlay';
lambda = cSpeed/frequency;
wtest = variables';
w = w.*wtest; %obtain the new weight matrix
%Obtain the radiation pattern cuts
%cosPattAz = cos(az*pi/180).^2.*cos(el0*pi/180).^2;
elCut = arrayFactorMatlab(positionArray./lambda, w, az0, angRange)';%.*cosPattAz';
%cosPattEl = cos(az0*pi/180).^2.*cos(el*pi/180).^2;
azCut = arrayFactorMatlab(positionArray./lambda, w, angRange, el0)';%.*cosPattEl';
%Obtain full radiation pattern
%cosPatt3D =cos(azM*pi/180).^2.*cos(elM*pi/180).^2;
aF3 = arrayFactorMatlab(positionArray/lambda, w, azShort, elShort);
radPatt3D = aF3;
%%%%%%%%%%%%%%%%%%%%%%%%%%%Extracting Information%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%Extracting beam information
%SLL
sll3D = sll3Dsearch(radPatt3D);

%Beamwidth
bwAz = beamwidthCalculation(angRange, azCut,-3);
bwEl = beamwidthCalculation(angRange, elCut,-3);
%gain = 10*log10(42000./(bwAz.*bwEl));
%Gain
%%%%%%%%%%%%%%%%%%%%%%%%%Cost Function%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
k1 = 0.3;
k2 = 0.7;
 Z1 = abs(bwAz - bwAzo)/bwAzo + abs(bwEl - bwElo)/bwElo; %Cost function for bw
 if sll3D>sll0
     Z2 = 0;
 else
     Z2 = abs(sll3D-sll0)./sll0;
 end

fCost = k1*Z1 + k2*Z2;
%fCost(1) = Z1;
%fCost(2) = Z2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end