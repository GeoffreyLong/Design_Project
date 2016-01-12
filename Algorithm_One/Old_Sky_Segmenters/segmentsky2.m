function [ skyFrames, terrainFrames ] = segmentsky2( videoPath )
%segmentsky2: texture based image segmenter
%   BASED OFF: http://www.mathworks.com/help/images/examples/texture-segmentation-using-texture-filters.html
%   Entropy filtering takes entirely too long (~10 seconds per image)
%   Entropy filtering does seem to do a good jobe in picking out the plane though
%       Might be useful to apply to small window
%   Thusfar, this method doesn't seem very promising due to the comp time
%   The segmentation could probably be optimized with a few simple tweaks
%   The segmentation works decently as a whole but some images are almost
%   entirely sky due to camera issues (blown out images perhaps?)

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
    BW1 = im2bw(Eim, .5);
    
    %Removes small non-connected components
    BWao = bwareaopen(BW1,200);
    
    
    % Smooth by morphologically closing holes in the image in a 15 pixel neighborhood
    nhood = true(15);
    closeBWao = imclose(BWao,nhood);
    
    % Fill in holes, consider different type for this
    roughMask = imfill(closeBWao,'holes');
    imagesc(roughMask)
end

end
