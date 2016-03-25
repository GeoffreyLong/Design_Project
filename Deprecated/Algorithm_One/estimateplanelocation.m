function [ size ] = estimateDistance( target )
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

    size = f*planeSize / ((3.45e-3 * (width+height)/2) * target(4));

    if (size < 5)
        size = 5;
    end

    % host(3)
    % rect = [horizontalLocation, verticalLocation, size, size];


end

