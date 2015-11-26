% The percent error in the placement and sizing of the rect
THRESHOLD = 0.10;

filePath = '/home/geoffrey/Dropbox/Temps/Design_Project/Feb_13_cam1_5.avi';
readRect = readrectxml(filePath);

% Instantiate the video reader
v = VideoReader(filePath);

% Get the number of frames, frame width, and frame height from the video data
nFrames = v.NumberOfFrames;
width = v.Width;
height = v.Height;

nTrueDetections = 0;
nFalsePositives = 0;
nFalseNegatives = 0;

for i = 1:nFrames
    image = read(v,i);
    truthRect = readRect(readRect(:,1)==i,:)
    % newRect = detect1(image);
    newRect = truthRect;
    
    for j = 1:size(newRect,1)
        curNew = newRect(j,:);
        
        found = false; 
        for k = 1:size(truthRect)
            curTruth = truthRect(k,:);
            errorX = THRESHOLD * curTruth(4);
            errorY = THRESHOLD * curTruth(5);
            
            % Essentially, see if the size of x and y sizes are within threshold
            % of the known and that the location of x and y are within
            % thresholds based on their respective sizes
            if (abs(curNew(4) - curTruth(4)) <= errorX && abs(curNew(5) - curTruth(5)) <= errorY ...
                    && abs(curNew(2) - curTruth(2)) <= errorX && abs(curNew(3) - curTruth(3)) <= errorY)
                nTrueDetections = nTrueDetections + 1;
                found = true;
                truthRect(k,:) = [0 0 0 0 0];
            end
        end
        
        if(~found)
            nFalsePositives = nFalsePositives + 1;
        end
    end
    
    for j = 1:size(truthRect,1)
        cur = truthRect(:,j);
        if (cur(1) ~= 0)
            nFalseNegatives = nFalseNegatives + 1;
        end
    end

        
    nFalsePositives
    nFalseNegatives
    nTrueDetections

end

