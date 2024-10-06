function [fCost] = costFunctionNoToolBox(variables, positionArray, az0, el0, sll0,...
    w0, angRange, bwAzo, bwElo, frequency, cSpeed)
%%%%%%%%%%%%%%%%%%%%%%%%%%% Reproducibility %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rng(1,'twister')
%%%%%%%%%%%%%%%%%%%%%%%%%Defin constans to be used %%%%%%%%%%%%%%%%%%%%%%%%
nBeams = length(az0);
%%%%%%%%%%%%%%%%%%%%%%%%Define  Variables%%%%%%%%%%%%%%%%%%%%%%%%%%%%
az = angRange;
el = angRange;
azShort = [angRange(1):2:angRange(end)];
elShort = [angRange(1):2:angRange(end)];
[azM, elM] = meshgrid(azShort, elShort);
lambda = cSpeed/frequency;
activeElements = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Extracting azimuth and elevation cuts
format = 'rectangular';
plotType = 'Powerdb';
plotStyle = 'Overlay';

numElements = length(positionArray);

    for i = 1 : nBeams
        wtest = variables((i-1)*numElements+1:i*numElements)';
        w = w0(:, i).*wtest; %obtain the new weight matrix
        %Obtain the radiation pattern cuts
        %cosPattAz = cos(az*pi/180).^2.*cos(el0*pi/180).^2;
        elCut = arrayFactorMatlab(positionArray./lambda, w, az0(i), angRange)';%.*cosPattAz';
        %cosPattEl = cos(az0*pi/180).^2.*cos(el*pi/180).^2;
        azCut = arrayFactorMatlab(positionArray./lambda, w, angRange, el0(i))';%.*cosPattEl';
        %Obtain full radiation pattern
        %cosPatt3D =cos(azM*pi/180).^2.*cos(elM*pi/180).^2;
        aF3 = arrayFactorMatlab(positionArray/lambda, w, azShort, elShort);
        radPatt3D = aF3;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%Extracting Information%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%Extracting beam information
        %SLL
        sll3D(i) = sll3Dsearch(radPatt3D);
        
        %Beamwidth
     
            bwAz(i) = beamwidthCalculation(angRange, azCut,-3);
            bwEl(i) = beamwidthCalculation(angRange, elCut,-3);
            activeElements = activeElements + w;
       
    %gain = 10*log10(42000./(bwAz.*bwEl));
    %Gain
%%%%%%%%%%%%%%%%%%%%%%%%%Cost Function%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% Weights for the cost function %%%%%%%%%%%%%%%%%%%%%% 
k1 = 0.3;
k2 = 0.2;
k3 = 0.5;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% Cost Function Beamwidth %%%%%%%%%%%%%%%%%%%%%%%%%%%

Z1 = sum(abs(bwAz - bwAzo)./bwAzo + abs(bwEl - bwElo)./bwElo)/ nBeams; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %if sll3D>sll0
     %Z2 = sum(~(sll3D >= sll0));
     sll3D(sll3D>=sll0)=sll0;

% else
     Z2 = sum(abs(sll3D-sll0)./sll0)/nBeams;
 %end
 %%%%%%%%%%%%%%%%%%%%%%%%%% Active Elements %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Z3 = sum(activeElements>3)/length(activeElements);

fCost = k1*Z1 + k2*Z2 + k3*Z3;
%fCost(1) = Z1;
%fCost(2) = Z2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end