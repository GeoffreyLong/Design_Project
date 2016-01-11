function [ rect ] = drawwithhelper( videoPath )
%drawrectangles: This function returns bounded rectangles from images
%   rect: A nx5 matrix where 
%       n is the number of detections
%       Each row is the frame number with the 4 dimensional rectangle selection
%   videoPath: The location of the video in the system

% This function will iterate through the frames of the video sequence
%   For each frame you are given three options
%       1) Draw a rectangle around a point of interest using the mouse
%           This rectangle will be saved in the array only if it is a valid selection
%               A valid selection will be completely inside the image
%               and larger than a click in enclosed area (set at 6 pixels)
%           The user will have to continue selecting 
%               until a valid selection is made, or (2) or (3) happens
%       2) Click to advance frames
%           Clicks outside of the image will advance multiple frames
%               The number of frames advanced depends 
%               on the number of successive clicks outside the image
%           A click on the image will reset the counter and advance one frame
%           Skipped frames will have rects of (0,0,0,0)
%       3) Close the image viewer to terminate the loop
%           All subsequent frames will have rects of (0,0,0,0)

readRect = readrectxml(videoPath);

if (readRect(1,1) == 0)
    printString = sprintf('No Rect found, defaulting to drawrectangles');
    display(printString)
    rect = drawrectangles(videoPath);
    return;
end
readIdx = 1;
maxRectIdx = size(readRect,1);

% Instantiate the video reader
v = VideoReader(videoPath);

% Get the number of frames, frame width, and frame height from the video data
nFrames = v.NumberOfFrames;
width = v.Width;
height = v.Height;

% Create an empty array
rect = zeros(nFrames,5);

% Instantiate the counters used in easy frame skipping
nClicks = 0;
nFrameSkip = 0;
nSkips = 0;

croppedRect = [0,0,v.Width,v.Height];

% Iterate through the image frames
for i = 1:nFrames
    % Skip a set number of frames
    % This number is set below through "clicks"
    if (nSkips < nFrameSkip)
        nSkips = nSkips + 1;
        continue;
    else
        % Reset the frame skipping indices
        nSkips = 0;
        nFrameSkip = 0;

        try
            % Show the image with the frame number as title
            video = read(v,i);
            
            while (readIdx <= maxRectIdx && readRect(readIdx,1) < i)
                readIdx = readIdx + 1;
            end
            
            if (readIdx <= maxRectIdx && readRect(readIdx,1) == i)
                tmpIdx = 1;

                while (readIdx <= maxRectIdx && readRect(readIdx,1) == i)
                    tmpRects(tmpIdx, :) = [readRect(readIdx,2)-croppedRect(1) readRect(readIdx,3)-croppedRect(2) readRect(readIdx,4) readRect(readIdx,5)];
                    readIdx = readIdx + 1;
                    tmpIdx = tmpIdx + 1;
                end
                
                % Need linewidth of 5 cause usually scales to 25%
                video = insertShape(video, 'Rectangle', tmpRects, 'LineWidth', 5);
            end
            
            newImg = imcrop(video,croppedRect);
            imshow(newImg);
            imgTitle = sprintf('frame %d of %d', i, nFrames);
            title(imgTitle);

            % Want to avoid selections outside of range of image
            % This avoids such selections if they do not correspond to "clicks"
            % Will force the user to continue selecting until valid selection is made
            curRect = getrect;
            while ((curRect(1) < 0 || curRect(1)+curRect(3) > width ...
                        || curRect(2) < 0 || curRect(2)+curRect(4) > height) ...
                        && curRect(3)+curRect(4) > 5)
                curRect = getrect;
            end

            % If the rect is sufficiently small it corresponds to a click 
            %   These are not used in rectangle selection
            %   They are only used to increment the frame number
            %   The drawn rectangles are not saved
            if (curRect(3)+curRect(4) < 5)
                % A click outside of the image will skip multiple frames
                %   This number of frames is 2^number of successive clicks
                % A click on the image will reset the counter 
                %   It will also advance one frame
                if (curRect(1) < 0 || curRect(1) > width ...
                        || curRect(2) < 0 || curRect(2) > height)
                    nClicks = nClicks + 1;
                    nFrameSkip = 2^nClicks;
                else
                    nClicks = 0;
                end
            else
                % A selection will reset the nClicks
                nClicks = 0;
                
                % This is a valid selection, so add it to the rectangle array
                % pair it with the frame number as first index of row
                
                curRect(1) = croppedRect(1) + curRect(1);
                curRect(2) = croppedRect(2) + curRect(2);
                rect(i,:) = [i curRect];            
            end
        catch
            % If you close the image without a selection, the for loop terminates
            break;
        end     
    end
end

% Remove rows with all 0's
rect( ~any(rect,2), : ) = [];

end
