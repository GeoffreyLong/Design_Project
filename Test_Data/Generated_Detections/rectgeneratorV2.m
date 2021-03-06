function [rect] = rectgeneratorV2( filePath, lastFrame )
%RECTGENERATORV2
%   Allows the user to enter explicit numbers to permute after initial selection
%   NOTE not fully tested... phased out in favor of RectGeneratorV3


filePath = 'Test_Data/July_6_cam1_01.avi';
lastFrame = 0;


% Instantiate the video reader
v = VideoReader(filePath);

% Get the number of frames, frame width, and frame height from the video data
nFrames = v.NumberOfFrames;
width = v.Width;
height = v.Height;

% Create an empty array
rect = [];

% Read in the SRT
[host, target] = getdetailedsrt(filePath, nFrames);

% Instantiate the cropper
croppedRect = [0,0,width,height];

if (lastFrame == 0)
    lastFrame = nFrames;
end

% Iterate through the image frames
for i = lastFrame:-1:1
        % Show the image with the frame number as title
        img = read(v,i);

        if (~isempty(host))
            curHost = host(host(:,1)==i,:);
            img = imrotate(img, -curHost(4), 'crop');
        end
        
        % This will scale the cropped rect slightly to ensure the plane
        % stays in the cropped region
        % If there was a detection in the last frame,
        % then set the cropped rect to be a bit bigger than this, 
        % else enlarge the existing cropped rect
        if (~isempty(rect))
            tempRect = rect(end,:);
            if (tempRect(1) == i+1)
                croppedRect = tempRect(2:5);
            end
            
            % Scale up the bounding box a bit while staying within bounds
            croppedRect(3) = ceil(3 * croppedRect(3));
            croppedRect(4) = ceil(3 * croppedRect(4));
            
            croppedRect(1) = ceil(croppedRect(1) - 1/3 * croppedRect(3));
            croppedRect(2) = ceil(croppedRect(2) - 1/3 * croppedRect(4));
            
            if (croppedRect(1) <= 0)
                croppedRect(1) = 1;
            end
            if (croppedRect(2) <= 0)
                croppedRect(2) = 1;
            end
            overflowWidth = croppedRect(1) + croppedRect(3) - width;
            if (overflowWidth >= 0)
                croppedRect(3) = croppedRect(3) - overflowWidth;
            end
            overflowHeight = croppedRect(2) + croppedRect(4) - width;
            if (overflowHeight >= 0)
                croppedRect(4) = croppedRect(4) - overflowHeight;
            end
        end
        croppedRect
        img = imcrop(img,croppedRect);
        imshow(img);
        imgTitle = sprintf('frame %d of %d', i, nFrames);
        title(imgTitle);

        curRect = zeros(5);
        if (~isempty(rect))
            tempRect = rect(end,2:5);
            tempRect(1) = tempRect(1) - croppedRect(1);
            tempRect(2) = tempRect(2) - croppedRect(2);
            while (1)
                tempRect
                tempImg = insertShape(img, 'Rectangle', tempRect);
                imshow(tempImg);
                prompt = ['Either enter a shift to the rect by' ...
                    '[x y sizeX sizeY], or 0 to reject, or 1 to accept: '];
                x = input(prompt)
                if (x == 1)
                    tempRect(1) = tempRect(1) + croppedRect(1);
                    tempRect(2) = tempRect(2) + croppedRect(2);
                    rect = [rect; i tempRect];
                    break
                elseif(x == 0)
                    break
                else
                    if numel(x) == 4
                        tempRect = tempRect + x;
                    end
                end
            end
        else
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
                rect = [rect; i curRect];            
            end
        end
            
%     catch
%         break;
%     end
end

% Remove rows with all 0's
rect( ~any(rect,2), : ) = [];

%sort the rect on the frame number
sort(rect,1)

end

