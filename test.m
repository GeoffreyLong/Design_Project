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
    k=k+1;
end

% get attributes of s
%whos s

% Create Axes
currAxes = axes;
while hasFrame(video)
    videoFrame = readFrame(video);
    image(videoFrame, 'Parent', currAxes);
    currAxes.Visible = 'off';
    pause(1/video.FrameRate);
    rect = getrect;
end

% resize figure to video height and width
%set(gcf,'position',[150 150 video.Width video.Height]);
%set(gca,'units','pixels');
%set(gca,'position',[0 0 video.Width video.Height]);

%play video
movie(s,1,video.FrameRate);
