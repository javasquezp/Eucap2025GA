function [latitude, longitude] = footprintCalculator(azimuth, elevation, satLat, satLong, satAlt)
% FUNCTIONNAME - This code allows the projection of the beam over the earth
% by calculating the corresponding projection of the azimuth and elevation.
% In this code we can easily just find the corresponding values of
% longitude and lattitude and then use different radiation patterns.
% THIS CODE NEEDS TO BE IMPROVED BY CONSIDERING AN INTRINSIC ROTATION OF
% THE ANTENNA TO A CERTAIN DIRECTION
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

%%%%%%%%%%%%%%%%%% Transformation of az-el to u-v %%%%%%%%%%%%%%%%%%%%%%%%%
[uv] = azel2uv([azimuth; elevation]); %Transform coordinates
u = uv(1,:);
v = uv(2,:);
[U, V] = meshgrid(u, v); %Generate matrix
[latitude, longitude] = uv2latlon(U(:),V(:),satLat,satLong,satAlt);
latitude = real(latitude);
longitude = real(longitude);
end
