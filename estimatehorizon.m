function [ x, y ] = estimatehorizon( host )
%estimatehorizon: Will estimate the position of the horizon line
%   horizLine: a line equation denoting the possible location of the horizon
%   host: A vector denoting the host aircraft information formatted as follows
%       [Frame Number, Altitude (feet), Pitch (degrees), Roll (degrees), Heading]
%   Equations based on "Aerial Object Tracking from an Airborne Platform"
%       by Andreas Nussberger, Helmut Grabner, and Luc Van Gool

% Might be improved with information of the elevation of the ground 
%   (if the altitude isn't from sea level, which it probably is)
height = 2050;
width = 2448;
pi = 3.14159;

altitude = host(2);
pitch = host(3);
roll = host(4);

earthRadius = 20925525; % Radius of the earth in feet (source Google)
aircraftAlt = earthRadius + altitude;
horizDist = sqrt(aircraftAlt^2 - earthRadius^2);

centralAngle = acos(earthRadius / aircraftAlt);
pDist = tan(centralAngle) * aircraftAlt; % ? what is this ?
angleToHoriz = 1.5*pi*acos(horizDist / pDist) - (pitch * (pi/180)); % Added 1.5pi seems to help

% This angleToHoriz doesn't seem 100% correct

% Perhaps use f*tan(angleToHoriz) / sensorHeight
%   where f is the focal length in mm, and sensorHeight is also in mm
%   f*tan(angleToHoriz) should give the distance off center of the horizon
%   on the image plane
% hardcoded the values for height (2050) and size of a pixel (3.45*10^-3)
verticalLocation = -(12 * tan(angleToHoriz)) / (3.45e-3 * height) * height + height/2;

% Roll is positive wrt slope
x = [0, width];
verticalOffset = width/2 * tand(roll);
y = [verticalLocation + verticalOffset, verticalLocation - verticalOffset]

horizLine = ceil(verticalLocation);

end

