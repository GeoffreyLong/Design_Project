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
        imgTitle = sprintf('frame %d of %d', i, nFrames);
        title(imgTitle);
        curRect = getrect;
        
        % if the rect is small it corresponds to a click, so don't save
        if (curRect(3)+curRect(4) < 5)
            % Can give option to skip multiple or go back depending on
            % whether the click is outside the frame or not
            % For instance, if the click x location is greater than the bounds of the
            % image it corresponds to a skip of 5 images
            % If click is to left of image (x < 0) then go back 1 image
            % Click on image is for a one frame skip
            % This would be basic though, might want more intuitive
            % solution
        else
            % Need some error handling here... 
            %   i.e. if the index of the rectangle is out of the img bounds
            %   Could simply decrement i such that they have to select
            %   again
            rect(i,:) = curRect;
        end
    catch
        % If you close the image without selection, the for loop terminates
        break;
    end
end


rect