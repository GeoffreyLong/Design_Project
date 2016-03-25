function [ sky, terrain ] = segmentsky8( image )
%segmentsky7: Based on image morphology
%   sky: A mask for the sky portion
%   terrain: A mask for the terrain portion
%   image: The input image to be segmented
% This function will split the input image into the constituent sky and terrain
%   


se = strel('disk',35);

open = imopen(image,se);
close = imclose(image,se); 
im = close - open;

% This might not be universal, might want to change how this is done 
% i.e. the 30 value is kindof arbitrary
im = (im > 30);

% Pad to fill holes
im = padarray(padarray(padarray(im,[1 0],1,'post'),[0 1],1,'pre'),[0 1],1,'post');

filled = imfill(im, 'holes');

% Get only large connected components
%TODO Should probably change this to be dependent on terrain area
final = bwareaopen(filled(1:end-1, 2:end-1),400000);
%imshow(final);

sky = ~final;
terrain = final;



% imshow(final);
% imshowpair(final,filled,'montage');


end 