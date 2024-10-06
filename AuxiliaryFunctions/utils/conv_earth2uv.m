function [u, v] = conv_earth2uv(lat, lon, satlon,sat_h)
	% rotate so that the satellite is in [0,0]
	lon = lon - satlon;

	% convert the co-ordinates point to satellite x, y, z
	[x, y, z] = coord_earth2xyz(lat, lon,sat_h);

	% normalize it to get u, v
	len = sqrt(x .^ 2 + y .^ 2 + z .^ 2);
	u = x ./ len;
	v = y ./ len;
end

function [x, y, z] = coord_earth2xyz(lat, lon,sat_h)
	% COORD_EARTH2XYZ - compute x,y,z from lat,lon
	%

	% Degree -> Rad
	DEG = pi / 180;

% % % % % % % % % % % % % % 	% GEO-Satellit radius
	R0 = earthRadius+sat_h;

	% Earth radius
	RE = earthRadius;		% m

	% convert to rad
	lat = lat .* DEG;
	lon = lon .* DEG;

	y = RE .* sin(lat);
	z = R0 + RE - sqrt((RE .^ 2 - y .^ 2) ./ (tan(lon) .^ 2  + 1));
	x = tan(lon) .* (R0 + RE - z);
end
