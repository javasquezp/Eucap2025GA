function [fCost] = costFunctionSPAICELEO(variables, positionArray, az0, el0, sll0,...
    w0, bwAzo, bwElo, frequency, cSpeed, eirpo, powerPerElelemntPerBeam, ...
    angRangeAz, angRangeEl, antennaPatternFull)
%%%%%%%%%%%%%%%%%%%%%%%%%%% Reproducibility %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%prvS = rng(2013);

%%%%%%%%%%%%%%%%%%%%%%%%%Defin constans to be used %%%%%%%%%%%%%%%%%%%%%%%%
nBeams = length(az0);
%%%%%%%%%%%%%%%%%%%%%%%%Define  Variables%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%azShort = [angRange(1):5:angRange(end)];
%elShort = [angRange(1):5:angRange(end)];
%[azM, elM] = meshgrid(azShort, elShort);
lambda = cSpeed/frequency;
activeElements = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Extracting azimuth and elevation cuts
format = 'rectangular';
plotType = 'Powerdb';
plotStyle = 'Overlay';
global counter;
numElements = length(positionArray);
counter = counter +1;
    for i = 1 : nBeams
        wtest = variables((i-1)*numElements+1:i*numElements)';
        w = w0(:, i).*wtest; %obtain the new weight matrix
        %Obtain the radiation pattern cuts
        %cosPattAz = cos(az*pi/180).^2.*cos(el0*pi/180).^2;
        %elCut = arrayFactorMatlab(positionArray./lambda, w, az0(i), angRange)';%.*cosPattAz';
        %antennaPatternEl = pattern(antenna, frequency, -az0(i), angRange, 'PropagationSpeed', ...
        %cSpeed, 'Type', 'eField', 'Normalize',false,'CoordinateSystem', ...
        %'rectangular');
        %cosPattEl = cos(az0*pi/180).^2.*cos(el*pi/180).^2;
        %azCut = arrayFactorMatlab(positionArray./lambda, w, angRange, el0(i))';%.*cosPattEl';
        %antennaPatternAz = pattern(antenna, frequency, angRange, -el0(i), 'PropagationSpeed', ...
        %cSpeed, 'Type', 'eField', 'Normalize',false,'CoordinateSystem', ...
        %'rectangular');
       % for kk = 1 : length(angRange)
        %    antennaPatternAxisCut1 = pattern(antenna, frequency, angRange(kk)-az0(i), angRange(kk)-el0(i), 'PropagationSpeed', ...
        %cSpeed, 'Type', 'eField', 'Normalize',false,'CoordinateSystem', ...
        %'rectangular');
        %    antennaPatternAxisCut2 = pattern(antenna, frequency, angRange(kk)-az0(i), angRange(kk)-el0(i), 'PropagationSpeed', ...
        %cSpeed, 'Type', 'eField', 'Normalize',false,'CoordinateSystem', ...
        %'rectangular');
        %    axisCut1 = mag2db(db2mag(arrayFactorMatlab(positionArray./lambda, w, angRange(kk)-az0(i), angRange(kk)-el0(i))').* ...
        %antennaPatternEl);
        %    axisCut2 = mag2db(db2mag(arrayFactorMatlab(positionArray./lambda, w, angRange(kk)-az0(i), angRange(kk)-el0(i))').* ...
        %antennaPatternEl);

        %end
        %Obtain full radiation pattern  
        %cosPatt3D =cos(azM*pi/180).^2.*cos(elM*pi/180).^2;
        %elCut = mag2db(db2mag(arrayFactorMatlab(positionArray./lambda, w, az0(i), angRange)').* ...
        %antennaPatternEl);%.*cosPattAz';
        %cosPattEl = cos(az0*pi/180).^2.*cos(el*pi/180).^2;
        %azCut = mag2db(db2mag(arrayFactorMatlab(positionArray./lambda, w, angRange, el0(i))').* ...
        %antennaPatternAz);%.*cosPattEl';
        %aF3 = arrayFactorMatlab(positionArray/lambda, w, azShort, elShort);
        %radPatt3D = mag2db(db2mag(aF3).*antennaPatternShort);
        radPatt3D = (db2mag(arrayFactorMatlab(positionArray/lambda, w, angRangeAz, angRangeEl)).*...
        antennaPatternFull);
        radPatt3DdB = mag2db(abs(radPatt3D+0.0001));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%Extracting Information%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%Extracting beam information
        %SLL
        sll3D(i) = sll3Dsearch(radPatt3DdB);

        %%%%%%%%%%%%%%%%%%%%%%%% EIRP Calculations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Prad = sum(sum(abs(radPatt3D).^2.*cos(angRangeElM*pi/180)*dAz*pi/180*dEl*pi/180)); %Total Radiation Pattern
        %gainC = 4*pi*abs(radPatt3D).^2./Prad;
        %gain(i) = 10*log10(max(max(abs(gainC))));
        %eirpC(i) = gain(i) + pow2db(sum(abs(w),1)*powerPerElelemntPerBeam);
        %Beamwidth
        % if ~isinf(azCut)
        %     bwAz(i) = beamwidthCalculation(angRange, azCut,-3);
        %     bwEl(i) = beamwidthCalculation(angRange, elCut,-3);
        %     bwAx1(i) = beamwidthCalculation(angRange, axisCut1,-3);
        %     bwAx2(i) = beamwidthCalculation(angRange, axisCut2,-3);
        %     activeElements = activeElements + w;
        % else
        %     bwAz(i) = 100;
        %     bwEl(i) = 100;
        %     bwAx1(i) = 100;
        %     bwAx2(i) = 100;
        % end
        % we obtain the contour
        [xy] = contourc(angRangeAz,angRangeEl,radPatt3DdB - max(radPatt3DdB(:)),[1 -3]);
        xBw = xy(1,2:end)- az0(i); % the positions in x for the beamwidth
        yBw = xy(2,2:end) - el0(i); % Positions in y for the beamwidth
        bw = (sqrt(xBw.^2+yBw.^2))*2;
        % Here I will calculate directly the error
        errorbw = (     bw  - bwAzo(i)    )   ./  bwAzo(i);
        % Compute the sum of squared errors (SSE)
        sse = sum(errorbw.^2);
       
       % Compute the variance of the points as an additional measure
        varPoints = var(bw);
       
      bwperB(i) = varPoints + sse;

   end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%Cost Function%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% Weights for the cost function %%%%%%%%%%%%%%%%%%%%%% 
k1 = 0.6;
k2 = 0.4;
%k3 = 0.4; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% Cost Function Beamwidth %%%%%%%%%%%%%%%%%%%%%%%%%%%

%Z1 = sum(abs(bwAz - bwAzo)./bwAzo + abs(bwEl - bwElo)./bwElo + ...
 %   abs(bwAx1 - bwElo)./bwElo + abs(bwAx2 - bwElo)./bwElo)/ (nBeams); 
 %bwperB = [];
 %for kk = 1 : nBeams
    
    % bwperB(i) = mean((bw( i,:)-az0(i)).^2);
    
% end

 Z1 = mean(bwperB);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% Cost Function SLL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     
     sll3D(sll3D>=sll0)=sll0;

     Z2 = sum(abs(sll3D-sll0)./sll0)/nBeams;

%%%%%%%%%%%%%%%%%%%%%%%%%% Cost Function EIRP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Z3 = sum(abs(eirpo-eirpC)./eirpo)./nBeams;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fCost = k1*Z1 + k2*Z2;%+ k3*Z3;
%fCost(1) = Z1;
%fCost(2) = Z2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end