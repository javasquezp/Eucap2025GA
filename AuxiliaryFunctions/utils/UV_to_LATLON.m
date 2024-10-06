%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (c) Eva Lagunas                                     November 2017            
%  University of Luxembourg - SnT                        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Transform (u_coord, v_coord) coordinates into (lat,long) for a particular
% GEO satellite orbit
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [lon,lat]=UV_to_LATLON(u_coord,v_coord,sat_lat,sat_lon,sat_h)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUTS:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% u_coor ( N x 1 ) 
% v_coor ( N x 1 )
% (sat_lon, sat_lat) coordiantes of satellite orbit
% sat_h: satellite height (usually 35,786 km for GEO)  in [m]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OUTPUTS:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (lon,lat) as (N x 1) each in degrees
% alt: height above WGS84 ellipsoid (m) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Stefano has for TAS 5E: [46.91N, 2.46E]
% lat_tilt=42;%46.91;% these values have been modified in order to point the pattern at Europe!!!
% lon_tilt=6;%2.46;

% lat_tilt=80;%46.91;% these values have been modified in order to point the pattern at Europe!!!
% lon_tilt=-50;%2.46;

lat_tilt=0;
lon_tilt=0;

% [u_tilt,v_tilt]=conv_earth2uv(lat_tilt-11.91,lon_tilt-0.1,sat_lon);
%[u_tilt,v_tilt]=conv_earth2uv(lat_tilt+sat_lat,lon_tilt+sat_lon,sat_lat, sat_lon,sat_h);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pts = coord_uv2earth([u_coord,v_coord],sat_lat, sat_lon,sat_h);
lat=pts(1,1);
lon=pts(1,2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Old Code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Earth Radius
% RE=6378*10^3; % [m]
% % (u,v) to (phi,theta)
% PhiTheta = uv2phitheta([(u_coord+u_tilt).'; (-v_coord)+v_tilt.']);
% PhiTheta = uv2phitheta([u_coord.'; -v_coord.']);
% phi=PhiTheta(1,:);   % [deg]
% theta=PhiTheta(2,:); % [deg]
% % (phi,theta) to (az,elev)
% AzEl = phitheta2azel(PhiTheta);
% az=AzEl(1,:);   % [deg]
% elev=AzEl(2,:); % [deg]
% % (az,elev) to (x,y,z)
% % input in radians
% [x,y,z]=sph2cart(az*pi/180,elev*pi/180,RE);
% % (x,y,z) to (lat,lon) based on WGS84
% [lat,lon,alt] = cart2latlon(x,y,z);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
