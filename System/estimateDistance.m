function [ rect ] = estimateDistance( target, host )
%UNTITLED Summary of this function goes here
%   target: the intruder plane information in the 3D world in the form
%       [Frame Number, Azimuth (degrees), Elevation (degrees), Distance (feet)]
%   host: A vector denoting the host aircraft information formatted as follows
%       [Frame Number, Altitude (feet), Pitch (degrees), Roll (degrees), Heading]
%   rect: the intruder plane location on the 2D image plane in the form
%       [x Position, y Position, width, height]


%TODO update the estimate plane location to work with the estimated horizon
%TODO check equations

height = 2050;
width = 2448;
planeSize = 6; % Rough guess of target size in meters
f = 12e-3; % 

horizontalLocation = (12 * tand(target(2))) / (3.45e-3 * width) * width + width/2;
verticalLocation = (12 * tand(target(3)+host(3))) / (3.45e-3 * height) * height + height/2;
size = f*planeSize / ((3.45e-3 * (width+height)/2) * target(4));

if (size < 5)
    size = 5;
end

rect = [horizontalLocation, verticalLocation, size];


end

