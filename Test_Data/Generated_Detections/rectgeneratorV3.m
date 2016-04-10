function [rect] = rectgeneratorV3( filePath, lastFrame, rect )
%RECTGENERATORV3 A quicker rect generator
%   Uses arrow keys after first selection to position the new bounding box


% Instantiate the video reader
v = VideoReader(filePath);

% Get the number of frames, frame width, and frame height from the video data
nFrames = v.NumberOfFrames;
width = v.Width;
height = v.Height;

% Read in the SRT
[host, target] = getdetailedsrt(filePath, nFrames);

% Instantiate the cropper
croppedRect = [0,0,width,height];

if (lastFrame == 0)
    lastFrame = nFrames;
end
if (~isempty(rect))
    rect = sortrows(rect,-1);
    lastFrame = rect(end,1) - 1;
end

% Iterate through the image frames
for i = lastFrame:-1:1
    try
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
        imCrop = imcrop(img,croppedRect);
        imshow(imCrop);
        imgTitle = sprintf('frame %d of %d', i, nFrames);
        title(imgTitle);

        curRect = zeros(5);
        if (~isempty(rect))
            tempRect = rect(end,2:5);
            tempRect(1) = tempRect(1) - croppedRect(1);
            tempRect(2) = tempRect(2) - croppedRect(2);
            while (1)
                tempRect
                tempImg = insertShape(imCrop, 'Rectangle', tempRect, 'Color', 'blue');
                imshow(tempImg);
                ch = getkey
                if (ch == 3)
                    return; % This seems to work
                elseif (ch == 8) % backspace, will skip frame
                    break;
                elseif (ch == 13) % enter, will add rect
                    tempRect(1) = tempRect(1) + croppedRect(1);
                    tempRect(2) = tempRect(2) + croppedRect(2);
                    rect = [rect; i tempRect];
                    break
                elseif (ch == 28) % Left arrow key, move box left
                    tempRect(1) = tempRect(1) - 1;
                elseif (ch == 30) % Up arrow key, move box up
                    tempRect(2) = tempRect(2) - 1;
                elseif (ch == 29) % Right arrow key, move box right
                    tempRect(1) = tempRect(1) + 1;
                elseif (ch == 31) % Down arrow key, move box down
                    tempRect(2) = tempRect(2) + 1;
                elseif (ch == 97) % 'a', will horizontally downscale box
                    tempRect(3) = tempRect(3) - 1;
                elseif (ch == 119) % 'w', will vertically upscale box
                    tempRect(4) = tempRect(4) + 1;
                elseif (ch == 100) % 'd', will horizontally upscale box
                    tempRect(3) = tempRect(3) + 1;
                elseif (ch == 115) % 'w', will vertically downscale box
                    tempRect(4) = tempRect(4) - 1;
                elseif (ch == 32)
                    croppedRect(1) = croppedRect(1) - 10;
                    croppedRect(2) = croppedRect(2) - 10;
                    croppedRect(3) = croppedRect(3) + 20;
                    croppedRect(4) = croppedRect(4) + 20;
                    
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
                    
                    imCrop = imcrop(img,croppedRect);
                else
                    continue
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
    
    catch
        break;
    end
end

% Remove rows with all 0's
rect( ~any(rect,2), : ) = [];

end


