% This shows how the plane region bounding works
% From this (since the sigma is really small) we might want to bound from
% the horizon estimation (usually lower than the true horizon) to 3*sigma.
% This should account for any issues that may arise from improper rotation

% All the files for the videos... We actually only want the SRT ones,
%   so pare this down
filePaths = {
    '../Test_Data/Feb_13_cam1_5.avi', ...
    '../Test_Data/July_6_cam1_01.avi', ...
    '../Test_Data/July_8_cam1_01.avi', ...
    '../Test_Data/July_8_cam1_02.avi', ... 
    '../Test_Data/July_8_cam1_03.avi', ...
    '../Test_Data/July_8_cam1_04.avi', ...
    '../Test_Data/July_8_cam1_08.avi', ... 
    '../Test_Data/Oct_20_cam3_07.avi', ...
};

% Select one of the videos for testing
filePath = char(filePaths{4})

% Instantiate the video reader
v = VideoReader(filePath);
nFrames = v.NumberOfFrames;
height = v.Height;

% Read in the SRT data
[host, target] = getdetailedsrt(filePath, nFrames);
truth = readrectxml(filePath, 'optimized_');

% PDF_Y
mu = 68.0164;
sigma = 16.2477;

nHood = strel('disk',7);
highThreshMU = 0.163;
highThreshSigma = 0.112;
lowThreshMU = 0.116;
lowThreshSigma = 0.111;
width = 2448;


detections = [];
for i = 2300:nFrames
    
    % Read in necessary data
    img = read(v, i);
    curHost = host(i,:);
    curTruth = truth(truth(:,1) == i, 2:5)
    
    % Rotate the image
    image = imrotate(img, -curHost(4), 'crop');

    % Horizon estimation
    horizonY = rotated_horizon_detection(curHost, height);
    
	% This should capture >99.7 percent of the data
    midpoint = horizonY - mu;
    upper = midpoint - 5*sigma;
    %lower = midpoint + 3*sigma;

    % upper is the top part, the abs is how far down
    image = imcrop(image, [0 upper width abs(upper-horizonY)]);
    
    % Perform a CMO
    open = imopen(image,nHood);
    close = imclose(image,nHood); 
    im = close - open;
    
    % binarize the image 
    bw = im2bw(im, lowThreshMU);
    L = bwlabel(bw);
    s = regionprops(L, 'Centroid', 'BoundingBox');

    numel(s)
    detections = zeros(numel(s),4);
    for j=1:numel(s)
        round(s(j).Centroid);
        s(j).BoundingBox;
        
        detections(j,:) = s(j).BoundingBox;
        
        %TODO
        % Often times the edges get caught
        % This is especially true if the frame has been rotated
        % The regions of 0 often get picked up... don't want these
        % Could have an if statement that will check if the center of the box is 0, 
        % if it is then we don't want to pick it up
        % We might want a more sophisticated method of picking these up though
        image = insertShape(image, 'Rectangle', s(j).BoundingBox, 'LineWidth', 5, 'color', 'blue');
    end
    imshow(image)
end