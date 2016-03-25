filePath = 'testData/Feb_13_cam1_5.avi';
%filePath = 'testData/July_6_cam1_01.avi';
%filePath = 'testData/July_8_cam1_01.avi';
%filePath = 'testData/July_8_cam1_08.avi';
%filePath = 'testData/Oct_20_cam3_07.avi';


WRITE = false;
if (WRITE)
    vwr = VideoWriter('DetectXX_Feb_13_cam1_5.avi');
    open(vwr);
end

% Instantiate the video reader
v = VideoReader(filePath);
readRect = readrectxml(filePath);

% Get the number of frames, frame width, and frame height from the video data
nFrames = v.NumberOfFrames;



for i = 1:nFrames 
    image = read(v,i);
    
    % This is changeable, switch out detection algorithms as needed
    detectRect = detect2(image,i);
    
    % If you want a fresh image every iteration leave uncommented
    % Commenting this is rather interesting from an analysis standpoint though
    im = image;
    
    for j=1:size(detectRect,1)
        im = insertShape(im, 'Rectangle', detectRect(j,2:5), 'LineWidth', 5, 'color', 'blue');
    end
    
    truthRect = readRect(readRect(:,1)==i,:);
    for j=1:size(truthRect,1)
        im = insertShape(im, 'Rectangle', truthRect(j,2:5), 'LineWidth', 5);
    end
    
    if ~WRITE
        imshow(im);
    end
    
    if WRITE
        i
        writeVideo(vwr,im);
    end
    
    [nTruePositives, nFalsePositives, nFalseNegatives] = evaluatedetection(truthRect, detectRect, i);
    [nTruePositives nFalsePositives nFalseNegatives]
end

if WRITE
    close(vwr);
end