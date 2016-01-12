function [ skyFrames, terrainFrames ] = segmentsky1(videoPath)
%segmentsky1: A simple function to split the sky based on hue values
%   BASED OFF http://matlabtricks.com/post-35/a-simple-image-segmentation-example-in-matlab
%   Hue based segmenter
%   This function attempts to split the image based on the hue value
%   Unfortunately, because the images are greyscale (so you can't split on
%   blue color), and because the function is based on lighting conditions
%   (which are bound to change), this function is largely useless

LOW_THRESHOLD = 120;
HIGH_THRESHOLD = 130;

% Instantiate the video reader
v = VideoReader(videoPath);

% Get the number of frames, frame width, and frame height from the video data
nFrames = v.NumberOfFrames;

for i = 1:nFrames 
    image = read(v,i);     

    [height, width, planes] = size(image);
    rgb = reshape(image, height, width * planes);
    
    g = image(:, :, 1);             % grey channel (if RGB then 2,3 would be green/blue) 
        
    % blueness = double(b) - max(double(r), double(g)); % if RGB
    
    %mask = g < HIGH_THRESHOLD & g > LOW_THRESHOLD;
    
    labels = bwlabel(g<120);

    % Know that the sky will likely be at the top of the frame
    id = labels(1, 1);

    % get the mask containing only the desired object
    sky = (labels == id);
    imagesc(sky);
end

end

