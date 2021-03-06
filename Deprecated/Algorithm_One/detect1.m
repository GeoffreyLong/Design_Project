function [ rect ] = detect1( image, idxFrame )
%detect1: 
%   Detailed explanation goes here
se = strel('disk',5);
BUFFER = 10;

open = imopen(image,se);
close = imclose(image,se); 
im = close - open;

[sky, terrain] = segmentsky8(image);

% TEMPORARY PLANE OBJECT REMOVER
im(645:1190,2200:end) = 0;


%TODO the "4*b" is very arbitrarily set
% Perhaps do a threshold based on the std dev of the value?
im(terrain) = 0;
b = mean2(im);
im(im>4*b & sky) = 255;
im(im ~= 255) = 0;

% Arbitrary threshold (any threshold would work)
bw = im2bw(im, 0.5);
L = bwlabel(bw);
s = regionprops(L,'BoundingBox');

rect = zeros(numel(s),5);

for j=1:numel(s)
    bound = s(j).BoundingBox;
    bound(1) = bound(1) - BUFFER;
    bound(2) = bound(2) - BUFFER;
    bound(3) = bound(3) + 2*BUFFER;
    bound(4) = bound(4) + 2*BUFFER;
    rect(j,:) = [idxFrame bound];
end


    
end

