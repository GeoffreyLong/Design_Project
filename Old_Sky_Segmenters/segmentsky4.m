function [ skyFrames, terrainFrames ] = segmentsky4( videoPath )
%segmentsky4: texture based image segmenter
%   BASED OFF: http://www.mathworks.com/help/images/examples/texture-segmentation-using-texture-filters.html
%   Texture Filter = stdfilt filtering
%   This has potential since the NHOOD matrix could take on a variety of configurations
%   Currently needs some basic closing
%   Test via overlaying filter on original image

LEVEL = 0.25; % Similar to grey threshold
NHOOD = ones(199,199);
CONNECTION_THRESH = 1;
FILTER_NEIGHBOORHOOD_SIZE = 1;

% Instantiate the video reader
v = VideoReader(videoPath);

% Get the number of frames, frame width, and frame height from the video data
nFrames = v.NumberOfFrames;

for i = 1:25:nFrames 
    image = read(v,i);    
    E = stdfilt(image,NHOOD);
    
    % Convert to binary image
    Eim = mat2gray(E);
    BW1 = im2bw(Eim, LEVEL);
    
    %Removes small non-connected components
    BWao = bwareaopen(BW1,CONNECTION_THRESH);
    
    
    % Smooth by morphologically closing holes in the image in a 15 pixel neighborhood
    nhood = true(FILTER_NEIGHBOORHOOD_SIZE);
    closeBWao = imclose(BWao,nhood);
    
    % Fill in holes, consider different type for this
    roughMask = imfill(closeBWao,'holes');
    imagesc(roughMask)
end

end

