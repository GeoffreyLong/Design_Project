% Load video and get its height and width
%video = VideoReader('xylophone.mp4');
%videoHeight = video.Height;
%videoWidth = video.Width;

% Matlab video stucture
%s = struct('cdata',zeros(videoHeight,videoWidth,3,'uint8'),'colormap',[]);

% Instantiate the video reader
v = VideoReader('xylophone.mp4');

% Get the frames from the video data
nFrames = v.Duration * v.FrameRate

% Create an empty array
rect = zeros(nFrames,4);

% Iterate through the image frames, if the image is closed before selection
% loop will terminate
for i = 1:nFrames
    try
        video = read(v,i);
        imshow(video);
        rect(i,:) = getrect;
        %TODO add a way to skip multiple frames at once... If a lot of
        % video data this could get tedious
        % Alternatively we could have the user define the range for this
        % loop
        pause;
    catch
        % If you close the image without selection, the for loop terminates
        break;
    end
end


rect




