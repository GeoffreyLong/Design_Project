function [ skyFrames, terrainFrames ] = segmentsky3( videoPath )
%segmentsky3: texture based image segmenter
%   BASED OFF: http://www.mathworks.com/help/images/examples/texture-segmentation-using-texture-filters.html
%   Similar to segmentsky3, but with range filtering
%   Runs faster than segmentsky2, slightly better segmentation
%   Complete if no better filter is found

% Instantiate the video reader
v = VideoReader(videoPath);

% Get the number of frames, frame width, and frame height from the video data
nFrames = v.NumberOfFrames;

for i = 1:25:nFrames 
    image = read(v,i);    
    %E = stdfilt(image,9);
    E = rangefilt(image,ones(5));
%    E = entropyfilt(image);
    
    % Convert to binary image
    Eim = mat2gray(E);
    BW1 = im2bw(Eim, 0.11);
    
    %Removes small non-connected components
    BWao = bwareaopen(BW1,150);
    
    
    % Smooth by morphologically closing holes in the image in a 15 pixel neighborhood
    nhood = true(40);
    closeBWao = imclose(BWao,nhood);
    
    % Fill in holes, consider different type for this
    roughMask = imfill(closeBWao,'holes');
    imagesc(roughMask)
end

end

