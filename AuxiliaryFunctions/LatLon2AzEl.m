function [azNew,elNew] = LatLon2AzEl(latitudE, longitudeE, satellitePosition, satelliteAltitude)

addpath(genpath('.')); % find the path by it self



for i =1 : size(latitudE,2)
    
    [u v] = conv_earth2uv(latitudE(i), longitudeE(i), satellitePosition, satelliteAltitude);
    [angleAzEl] = uv2azel([u; v]);
     az(i) = angleAzEl(1,1);
     el(i) = angleAzEl(2,1);

end

azNew = az+ (az(end)-az(1))/2;
azNew = azNew- (azNew(end)+azNew(1))/2;
elNew = el -(el(end)+el(1))/2;


end