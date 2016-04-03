function [ rect ] = drawscramble( filePath )
%DRAWSCRAMBLE 
%   Often times when a photo is searched for a possible plane, the search
%   is biased by the location of the previous plane. This rectangle
%   generator will scramble the ordering of the frames to remove this bias.
%   Also, this will be rotated. 


% Instantiate the video reader
v = VideoReader(filePath);

% Get the number of frames, frame width, and frame height from the video data
nFrames = v.NumberOfFrames;
width = v.Width;
height = v.Height;

% Create an empty array
rect = [];

startPos = 1400;
indices = randperm(nFrames-startPos);
indices = indices + startPos;

% Read in the SRT
[host, target] = getdetailedsrt(filePath, nFrames);

xOffset = 0;
yOffset = 600;
width = 1200;
height = 700;
croppedRect = [xOffset,yOffset,width,height];

% Iterate through the image frames
for i = 1:numel(indices)
    try
        % Set the video index to be the index in the scrambled vector
        vidIdx = indices(i);

        % Show the image with the frame number as title
        video = read(v,vidIdx);

        if (~isempty(host))
            curHost = host(host(:,1)==vidIdx,:);
            video = imrotate(video, -curHost(4), 'crop');
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
        if (curRect(3)+curRect(4) > 5)
            % This is a valid selection, so add it to the rectangle array
            % pair it with the frame number as first index of row
            
            curRect(1) = croppedRect(1) + curRect(1);
            curRect(2) = croppedRect(2) + curRect(2); 
            rect = [rect; vidIdx curRect];            
        end
    catch
        break;
    end
end

% Remove rows with all 0's
rect( ~any(rect,2), : ) = [];

%sort the rect on the frame number
sort(rect,1)

end

