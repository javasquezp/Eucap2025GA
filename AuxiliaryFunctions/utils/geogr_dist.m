%                     University of Luxembourg - SnT                         
%                         Author: Haythem CHAKER
%                           v1, Nov ,2020
function d = geogr_dist(coord1,coord2,R) % in meters

long1 = coord1(:,1)*pi/180;
lat1 = coord1(:,2)*pi/180;
long2 = coord2(:,1)*pi/180;
lat2 = coord2(:,2)*pi/180;
d = R.*acos(cos(long1-long2).*cos(lat1).*cos(lat2) + sin(lat1).*sin(lat2));       