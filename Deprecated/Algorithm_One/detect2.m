function [ rect ] = detect2( image, idxFrame )
%UNTITLED Uses sobel to extract plane
%   Detailed explanation goes here

BUFFER = 10;

[sky, terrain] = segmentsky8(image);

BW = edge(image,'Sobel',0.07,'both');

% TEMPORARY PLANE OBJECT REMOVER
BW(645:1190,2200:end) = 0;

BW(terrain) = 0;
BW(BW & sky) = 1;

L = bwlabel(BW);
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

