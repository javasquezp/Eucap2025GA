function plotRadOnMap(latitude, longitude, radPattern)
% FUNCTIONNAME - This code allows the plot the radiation pattern over the
% earth. This code allows plotting multiple radiation patterns defined in
% the radPattern variable
%
% Syntax: [latitude, longitude] = footprintCalculator(azimuth, elevation, satLat, satLong, satAlt)
%
% Inputs:
%   input - azimuth : Vector form
%           elevation : Vector Form 
%           satLat : of the satellite
%           satLong : of the satellite
%           satAlt : of the satellite in meters
% Outputs:
%   output - latitude
%            longitude
%
% Example:
%   inputExample = ([0 1 2], [0 1 2], 10, 10, 36e6)
%   
%
% Author: Juan Andrés Vásquez Peralvo
% Date: July 4, 2023
% Version: 1.0

% Function code goes here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% Start of the Code %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% Define Constants %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% Load Map %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
geoshow('landareas.shp','FaceColor', [1 1 1]);
ylim([ 30   70]);    
xlim([-15   20 ]);
hold on;
box on;
%%%%%%%%%%%%%%%%%%%%%%%%%%%% Code processing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nBeams = size(radPattern, 2); %determine the number of beams
matrixSize = size(radPattern, 1)^0.5;
latitudeM = reshape(latitude,[matrixSize, matrixSize]); % Convert to a matrix
longitudeM = reshape(longitude, [matrixSize, matrixSize]);


for i = 1 : nBeams
    
    latitudeP = latitude(radPattern(:,i)>-3);
    longitudeP = longitude(radPattern(:,i)>-3);
    pattern3DP = radPattern(radPattern(:,i)>-3,i);
    scatter3(longitudeP, latitudeP,pattern3DP+10,10, ...
            pattern3DP,'MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',0.5);
    hold on
    radPatternM = reshape(radPattern(:,i), [matrixSize, matrixSize]);
    contour(longitudeM, latitudeM, radPatternM, [max(max(radPatternM)) max(max(radPatternM))-3])
end
  colormap(jet); colorbar;
    % 
     xlabel('Longitude');ylabel('Latitude');
     zlabel('Gain[dB]');
     title('Coverage')


end 