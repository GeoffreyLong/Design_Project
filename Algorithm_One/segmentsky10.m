function [ sky, terrain, horizon ] = segmentsky10( image, lastHorizon, roll )
%UNTITLED Based on the Hough transform
%   Detailed explanation goes here
% lastHorizon: a line in the form [x1 y1 x2 y2]

% Might be cool to make my own adaptation of the hough transform
% specifically tailored to horizon detection, i.e. from the left side
% of the image iterate through a series of (m,b) combinations where 
% m is slope and b is the y intercept (left side) we can constrain the
% range of slopes we want for each b, i.e. you don't really need
% positive slopes when the b intercept is high on the image (close to 0)

% This iteration will not work very well for mountainous environments

% Rather arbitrarily made...
SCALE = 0.1;

if nargin < 2
    %TODO finish horizonseed
    % lastHorizon = horizonseed(image);
    lastHorizon = [0 0 0 0]
end

image = imresize(image, SCALE);

bw = edge(image, 'canny', [], 1);
bw = bwmorph(bw,'dilate',1);

% Could constrain between a certain angle offset of the roll via hough(bw, 'Theta', ____)
% This might be tedious though since I would need two different hough
% transforms for the different ranges (for horizontal lines)
% Also there is a hough implementation with FillGap I believe
[H,theta,rho] = hough(bw);
peaks  = houghpeaks(H,10);
lines = houghlines(bw,theta,rho,peaks);

% dummy value
minNormal = 10000000;

%imshow(image)
%hold on;
for k = 1:numel(lines)
    x1 = lines(k).point1(1);
    y1 = lines(k).point1(2);
    x2 = lines(k).point2(1);
    y2 = lines(k).point2(2);
    theta = lines(k).theta;
    if (theta < 0)
        theta = -(theta + 90);
    else
        theta = -(theta - 90);
    end
    theta
    
    %line([x1,x2], [y1,y2]);
    
    slope = (y2-y1) / (x2-x1);
    if x1 ~=0
        y1 = y1 - (x1 - 0) * slope;
        x1 = 0;
    end
    
    if x2 ~= 0
        x2old = x2;
        x2 = size(image,2);
        y2 = (x2 - x2old) * slope + y2;
    end
    
    temporaryHorizon = [0 y1/SCALE 2448 y2/SCALE];

    %100 arbitrary scale to make angle slightly more important than location
    horizNormal = norm(lastHorizon - temporaryHorizon) + 25*abs(roll-theta);
    
    if horizNormal < minNormal
        horizon = temporaryHorizon
        minNormal = horizNormal;
    end
end

sky = 0;
terrain = 0;
%TODO return a mask
% To make the sky will want to make the x,y under the line = 0 and all
% above = 1. For the terrain just do the opposite of sky
% ex. f=(i,j)->(i+j) will make every elm in index i,j = the sum of the indices
%f = (i,j)->((i<horizon(1)) 
%image = matrix(size(image,1), size(image,2), f)
end

