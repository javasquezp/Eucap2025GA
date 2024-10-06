function pts = coord_uv2earth(uv,satlat, satlon,sat_h)
	% COORD_UV2EARTH - convert u,v to lat,lon
	%
	% Author: Hartmut Brandt
	%
	% $Id: coord_uv2earth.m 527 2006-04-18 13:58:54Z brandt_h $
	%
	% compute the w component
	w = sqrt(1 - uv(:, 1) .^ 2 - uv(:, 2) .^ 2);

	% compute the earth coordinates
	pts = sect_with_earth([uv w],sat_h);

	% rotate
	pts(:, 2) = pts(:, 2) + satlon;
    pts(:, 1) = pts(:, 1) + satlat;
end

function ep = sect_with_earth(pts,sat_h)
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
	%R0 = earthRadius+sat_h;
    R0 = sat_h;
	% Earth radius
	RE = earthRadius;		% m

	ha = (pts(:, 1) .^ 2 ./ pts(:, 3) .^ 2) + (pts(:, 2) .^ 2 ./ pts(:, 3) .^ 2) + 1;
	hb = -2 .* (R0 + RE);
	hc = (R0 + RE) .^ 2 - RE .^ 2;

	hp = hb ./ ha;
	hq = hc ./ ha;

	r = (hp ./ 2) .^ 2 - hq;

	z = -hp ./ 2 - sqrt(r);

	% get index of all hitting lines
	hit = find(r >= 0);

	% allocate return values
	lat = ones(size(pts, 1), 1) .* NaN;
	lon = ones(size(pts, 1), 1) .* NaN;

	if (~isempty(hit))
		x(hit, 1) = z(hit) .* (pts(hit, 1) ./ pts(hit, 3));
		y(hit, 1) = z(hit) .* (pts(hit, 2) ./ pts(hit, 3));

		t = x;
		x = y;
		y = t;

		lat(hit) = asin(x(hit) / RE) / DEG;
		lon(hit) = atan(y(hit) ./ (R0 + RE - z(hit))) / DEG;
	end

	ep = [lat lon];
end