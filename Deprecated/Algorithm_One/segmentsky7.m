function [ sky, terrain ] = segmentsky7( image )
%segmentsky7: Based on edge density and image morphology
%   sky: An image frame containing only the sky component of the image
%   terrain: An image frame containing only the terrain (not sky)
%   image: The input image to be segmented
% This function will split the input image into the constituent sky and terrain
%   Begins by running Canny edge detection to find the sharp edges
%       Expect the sharper edges to be ground as clouds, etc aren't
%       usually very sharp. Find the region with a concentration of sharp
%   Morphologically manipulate this until the sky and terrain are only 2
%   objects. Then filter out the initial image and return the result.

%NOTE cuts the horizon a bit low... could consider a straight line cut
% This does segregate textured vs non textured components though

nhood = true(4);

e = edge(image,'canny',0.08, 0.4);
closed = imclose(e,nhood);
filled = imfill(closed,'holes');

% Size of Border
closer = 1;

% Border and fill so that the result is uniform 
filled(:, 1:closer) = 1;
filled(end-closer:end, :) = 1;
filled(:, end-closer:end) = 1;
filled = imfill(filled,'holes');

% Remove Border
filled = bwmorph(filled, 'branchpoints');

% Get only large connected components
%TODO Should probably change this to be dependent on terrain area
reduced = bwareaopen(filled,40000);

% Dilate because sometimes there exists a line between the selected
% component and the border
final = bwmorph(reduced, 'dilate');

%imshow(final);
%imshowpair(final,image);

sky = ~final;
terrain = final;