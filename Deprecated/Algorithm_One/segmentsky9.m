function [ sky, terrain ] = segmentsky9( image )
%segmentsky9: Uses Otsu Segmentation
%   Loosely based off of "Vision-Based Horizon Detection and Target Tracking for UAVs"
%       BY Yingju Chen, Ahmad Abushakra, and Jeongkyu Lee

%TODO Needs some work on selecting the region / threshold

ulc = image(1:20, 1:20);
urc = image(1:20, end-20:end);
llc = image(end-20:end, 1:20);
lrc = image(end-20:end, end-20:end);

% [graythresh(ulc) graythresh(urc); graythresh(llc) graythresh(lrc)]

im1 = im2bw(image,(graythresh(urc) + graythresh(ulc))/2);
im2 = im2bw(image,(graythresh(lrc) + graythresh(llc))/2);



im1 = ~imfill(~im1, 'holes');
%im2 = imfill(im2, 'holes');

im1 = ~bwareaopen(~im1,100000);
%im2 = bwareaopen(im2,100000);

%imshowpair(im1, im2,'montage');

sky = im1;
terrain = ~im1;

end