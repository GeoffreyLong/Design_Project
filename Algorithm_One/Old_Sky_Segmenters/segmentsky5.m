function [ skyFrames, terrainFrames ] = segmentsky5( videoPath )
%segmentsky5: texture based k-means image segmenter

% Instantiate the video reader
v = VideoReader(videoPath);

% Get the number of frames, frame width, and frame height from the video data
nFrames = v.NumberOfFrames;

for i = 1:25:nFrames 
    image = read(v,i);  
    gray = im2double(image(1:v.Height, 1:v.Width, 1));
        
    idx = kmeans(gray,2);
    imshow(ind2rgb(reshape(idx, size(image,1), size(image, 2)), [0 0 1; 0 0.8 0]))
end

end

