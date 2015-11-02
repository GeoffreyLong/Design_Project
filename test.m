% Load video and get its height and width
video = VideoReader('testVideo.mp4');
videoHeight = video.Height;
videoWidth = video.Width;

% Matlab video stucture
s = struct('cdata',zeros(videoHeight,videoWidth,3,'uint8'),'colormap',[]);

% Read one frame at a time

k=1;

while hasFrame(video)
    s(k).cdata = readFrame(video);
    videoFrame = readFrame(video);
    %Draw circle on to each frame
    RGB = insertShape(videoFrame, 'circle', [150 280 35], 'LineWidth', 5);
  % resize figure to video height and width
    imshow(RGB);

   % pause(1/video.FrameRate);

    k=k+1;
    
end

%play video
%movie(s,1,video.FrameRate);
