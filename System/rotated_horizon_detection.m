function [ horizonY ] = rotated_horizon_detection( host, height )
%ROTATED_HORIZON_DETECTION 
%   This function will estimate the horizon on a rotated image
%   Equations based on "Aerial Object Tracking from an Airborne Platform"
%       by Andreas Nussberger, Helmut Grabner, and Luc Van Gool

% Might be improved with information of the elevation of the ground 
%   (if the altitude isn't from sea level, which it probably is)
pi = 3.14159;

altitude = host(2);
pitch = host(3);

earthRadius = 20925525; % Radius of the earth in feet (source Google)
aircraftAlt = earthRadius + altitude;
horizDist = sqrt(aircraftAlt^2 - earthRadius^2);

centralAngle = acos(earthRadius / aircraftAlt);
pDist = tan(centralAngle) * aircraftAlt; % ? what is this ?
%TODO fix the 1.5*pi addition, shouldn't have to make that adjustment
% Perhaps the camera wasn't set correctly
angleToHoriz = 1.5*pi*acos(horizDist / pDist) - (pitch * (pi/180)); 

% This angleToHoriz doesn't seem 100% correct

% Perhaps use f*tan(angleToHoriz) / sensorHeight
%   where f is the focal length in mm, and sensorHeight is also in mm
%   f*tan(angleToHoriz) should give the distance off center of the horizon
%   on the image plane
% hardcoded the values for height (2050) and size of a pixel (3.45*10^-3)
horizonY = -(12 * tan(angleToHoriz)) / (3.45e-3 * height) * height + height/2;


end
