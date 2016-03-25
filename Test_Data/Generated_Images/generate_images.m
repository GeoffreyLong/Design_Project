%TODO
%   Consider a better metric for splitting the detections from not detections
%       Right now I might miss some that are detections
%       I doubt I will get any false positives though
%   Consider blowing out the bounds of the bounding box
%       This should be similar to how the truth images were aggregated
%       In those the size of the largest dimension is tripled
%       Then it is recentered. If I want to add those images to the
%       training set, that is what I have to do
%   IMPORTANT:: Really, though, I will want to run the detections here the same way
%       I would run detections normally. If I do it this way, then the cnn
%       will be trained effectively for actual use. So if I use a CMO with
%       a certain threshold during the actual run, then I should do the
%       same for training. I want the training images to be as similar to
%       the detection windows as possible. This is the only way I will get
%       good results.
%   From now on, this should be the image generator I use... At least for
%       post processing after the original detection rectangles are
%       generated. 
%   One thing to think about is whether I want to force the detections to 
%       be square as I do in runImagePostProcessor2...


% The purpose of this is to generate the plane and not plane image sets
% It might be wise to redo this if we don't get good results, for now it is
% more of a test than anything

%filePath = 'testData/July_8_cam1_02.avi'; saveFormat = '/home/geoffrey/Dropbox/Temps/Design_Project/Deep_Learning/data/Generate_Data/v1/%s/July_8_cam1_02_im_%d_%d.png';
filePath = 'testData/July_8_cam1_03.avi'; saveFormat = '/home/geoffrey/Dropbox/Temps/Design_Project/Deep_Learning/data/Generate_Data/v1/%s/July_8_cam1_03_im_%d_%d.png';

% Instantiate the video reader
v = VideoReader(filePath);

readRect = readrectxml(filePath, 'postProcess_');
se = strel('disk',5);
newRect = [0 0 0 0 0];

write = false; 
buffer = true;

for i=1:size(readRect,1)
    curRect = readRect(i,:);
    imageNumber = curRect(1);
    image = read(v,imageNumber);
    
    %image(curRect(2):curRect(2)+curRect(4), curRect(3):curRect(3)+curRect(5)) = 0;
    %image = imcrop(image,curRect(2:5));
    open = imopen(image,se);
    close = imclose(image,se); 
    im = close - open;
    im = imdilate(im,se);

    bw = im2bw(im, 0.08);
    L = bwlabel(bw);
    
    % There are a lot of cool regionprops that could be useful
    % Particularly userprops
 
    s = regionprops(L,'BoundingBox', 'Centroid');

    bound = [0 0 0 0];
    largestObjSize = 0;
    for j=1:numel(s)
        centroid = round(s(j).Centroid);
        newBound = s(j).BoundingBox;
        
        % Add a buffer if desired
        if (buffer)    
            upperDim = ceil(max(newBound(3),newBound(4)));
            newBound(1) = centroid(1) - ceil(1.5*upperDim);
            newBound(2) = centroid(2) - ceil(1.5*upperDim);
            newBound(3) = 3*upperDim;
            newBound(4) = 3*upperDim;
            if (newBound(1) < 0 || newBound(2) < 0 ...
                    || newBound(1)+newBound(3) > v.Height ...
                    || newBound(2)+newBound(4) > v.Width)
                % [newBound(1) newBound(2) newBound(3) newBound(4)]
                continue;
            end
        end
        newImg = imcrop(image,newBound);
        imshow(newImg)
        
        %[centroid(1) curRect(2) centroid(2) curRect(3)]
        if (bboxOverlapRatio(newBound,curRect(2:5)) <= 0 ...
            || norm(curRect(4:5) - newBound(3:4)) > 2*(newBound(3)+newBound(4)))
            
            % Sanity Check
            %image = insertShape(image, 'Rectangle', newBound, 'LineWidth', 5, 'color', 'red');
            
             % Too many if all written
             % Second bbox overlap to ensure no false writes
            if (rand() < 3/numel(s) && bboxOverlapRatio(newBound,curRect(2:5)) <= 0)
                writeString = sprintf(saveFormat,'notPlane',imageNumber,j);
                if (write)
                    imwrite(newImg, writeString);
                end
            end
            
        else
            %TODO might want to put another check to ensure that the
            % detection is close enough in size... for now... w/e
            %image = insertShape(image, 'Rectangle', newBound, 'LineWidth', 5, 'color', 'yellow');
            writeString = sprintf(saveFormat,'plane',imageNumber,j);
            
            if (write)
                imwrite(newImg, writeString);
            end
        end
        

        %CH = getkey;
        %if CH == 121 % Corresponds to a 'y', will save the image
        %    if newRect
        %        newRect = [newRect; [imageNumber bound]];
        %    else
        %        newRect = [imageNumber bound];
        %    end
        %elseif CH == 3 % A ctrl-c command will exit the program
        %   break;
        %end

    end
    % Sanity Check
    %image = insertShape(image, 'Rectangle', curRect(2:5), 'LineWidth', 5, 'color', 'blue');
    %imshow(image)

end