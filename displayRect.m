function displayRect( videoPath, rect )

% Instantiate the video reader

v = VideoReader(videoPath);
nFrames = v.Duration * v.FrameRate;

for i = 1:nFrames
    video = read(v,i);
%   insert the rectangle as the specified location on each frame  
    shape = insertShape(video, 'Rectangle', [rect(i,2) rect(i,3) rect(i,4) rect(i,5)], 'LineWidth', 1);
    imshow(shape);
end

% while hasFrame(v)
%     video = readFrame(v);
%     shape = insertShape(video, 'circle', [150 280 35], 'LineWidth', 5);
%     imshow(shape);
% end


