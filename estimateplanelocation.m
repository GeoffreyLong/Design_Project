function [ rect ] = estimateplanelocation( target )
%UNTITLED Summary of this function goes here
%   target: the intruder plane information in the 3D world in the form
%       [Frame Number, Azimuth (degrees), Elevation (degrees), Distance (feet)]
%   rect: the intruder plane location on the 2D image plane in the form
%       [x Position, y Position, width, height]

height = 2050;
width = 2448;
planeSize = 6; % Rough guess of target size
f = 12000

horizontalLocation = (12 * tand(target(2))) / (3.45e-3 * width) * width + width/2;
verticalLocation = (12 * tand(target(3))) / (3.45e-3 * height) * height + height/2;
size = f*planeSize / ((3.45e-3 * (width+height)/2) * target(4));

if (size < 5)
    size = 5;
end

rect = [horizontalLocation, verticalLocation, size, size]


end

