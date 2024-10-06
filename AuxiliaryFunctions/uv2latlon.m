function [latitude, longitude] = uv2latlon(u, v, satLat, satLon, satAlt)
% FUNCTIONNAME - This code transforms values of u and v in latitude and longitude
% In addition, this function has an embeedded function insidefor easyness
%
% Syntax: [latitude, longitude] = uv2latlon(u, v, satLat, satLon, satAlt)
%
% Inputs:
%   input - u : In Matrix Form
%           v : In Matrix Form
%           satLat : degrees
%           satLon : degrees
%           satAlt : in meters
% Outputs:
%   output - latitude, longitude
%
% Example:
%   inputExample = ([0.2 0.3 ; 0.4 0.3], [0.2 0.6; 0.55 -0.5],10, -10, 36e6)
%   
%
% Author: Not Me
% Date: July 4, 2023
% Version: 1.0

% Function code goes here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% Start of the Code %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% Define Constants %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%% Transformation of az-el to u-v %%%%%%%%%%%%%%%%%%%%%%%%%

	% COORD_UV2EARTH - convert u,v to lat,lon
	%
	% Author: Hartmut Brandt
	%
	% $Id: coord_uv2earth.m 527 2006-04-18 13:58:54Z brandt_h $
	%
	% compute the w component
	w = sqrt(1 - u.^ 2 - v.^ 2);

	% compute the earth coordinates
	[latitude, longitude] = sect_with_earth(u, v, w, satAlt);

	% rotate
	longitude = longitude + satLon;
    latitude = latitude + satLat;
end
function [lat, lon] = sect_with_earth(u, v, w, satAlt)
% SECT_WITH_EARTH - compute intersection points of lines from satellite to
%	arbitrary points with the earth
%
% For all points in pts (given in satellite co-ordinates as [x y z] triples,
% compute the nearest (if any) intersection point of a line from [0 0 0] to
% [x y z] with earth and return the corresponding [lat lon] pairs. The
% returned matrix may have less rows than the input matrix if there are lines
% that never hit earth.
%
% THIS function is different from that in sect_with_earth.m. The coordinate
% system is rotated: y looks south and x looks east! 
%%%%% MODIFIED (Danilo Spano - Apr2019): y now looks North.
%
% Input:
%	pts	matrix Nx3 of point coordinates
% Output:
%	ep	matrix Nx2 of [lan lon]
% 
	% Degree -> Rad
	DEG = pi / 180;

% % % % % % % % % % % % % % % % 	% GEO-Satellit radius
	R0 = satAlt;

	% Earth radius
	RE = earthRadius;		% m

	ha = (u .^ 2 ./ w .^ 2) + (v .^ 2 ./ w .^ 2) + 1;
	hb = -2 .* (R0 + RE);
	hc = (R0 + RE) .^ 2 - RE .^ 2;

	hp = hb ./ ha;
	hq = hc ./ ha;

	r = (hp ./ 2) .^ 2 - hq;

	z = -hp ./ 2 - sqrt(r);

	% get index of all hitting lines
	hit = find(r >= 0);

	% allocate return values
	lat = ones(size(u, 1), 1) .* NaN;
	lon = ones(size(u, 1), 1) .* NaN;

	if (~isempty(hit))
		x(hit, 1) = z(hit) .* (u(hit) ./ w(hit));
		y(hit, 1) = z(hit) .* (v(hit) ./ w(hit));

		t = x;
		x = y;
		y = t;

		lat(hit) = asin(x(hit) / RE) / DEG;
		lon(hit) = atan(y(hit) ./ (R0 + RE - z(hit))) / DEG;
	end

	
end