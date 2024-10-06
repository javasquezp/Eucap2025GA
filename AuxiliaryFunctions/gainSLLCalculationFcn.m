function gainC = gainCalculationFcn(antennaPosition, w)
    % gainCalculationFcn - Description of the function.
    %
    % Syntax: gain = gainCalculationFcn(AF, angRange)
    %
    % Inputs:
    %   antennaPositions : positions of the antennas normalized by lambda
    %   w : weight Vector
    %
    % Outputs:
    %   output - calculated gain
    %
    % Example:
    %   inputExample = (positions /lambda,w(:,1))
    %   ;
    %
    % Author: Juan Andres Vasquez Peralvo
    % Date: July 19, 2023
    % Version: 1.0
    granularity = 200; % Number of points
    dEl = 180/granularity;
    dAz = 360/granularity;
    angRangeEl = [-180/2:dEl:180/2]; %it has to be in this range
    angRangeAz = [-360/2:dAz:360/2]; %it has to be in this range
    [angRangeAzM, angRangeElM] = meshgrid(angRangeAz, angRangeEl); 
    AF3 = db2mag(arrayFactorMatlab(antennaPosition, w, angRangeAz, angRangeEl));
     
     Prad = sum(sum(abs(AF3).^2.*cos(angRangeElM*pi/180)*dAz*pi/180*dEl*pi/180)); %Total Radiation Pattern
     gainC = 4*pi*abs(AF3).^2/Prad; %Directivity formula calcualtion

end