% The goal of this script is to learn the location of a plane in an image
% This will be used to attach a probability to a possible detection
% based purely on the location of the detection.
% NOTE: This could be hugely speed optimized, 
%   but performance is not an issue for this script 

%%%%%%%%%% RESULTS %%%%%%%%%%
% PDF_X
%       mu = -243.46   [-249.342, -237.578]
%    sigma = 105.535   [101.537, 109.863]
% PDF_Y
%       mu = -450.014   [-452.065, -447.964]
%    sigma =  36.7863   [35.3928, 38.2949]


% APPROACH
%   Get all the detections from all the videos
%       Focus on the videos with IMU data first... those without might have to wait
%       Use the center of the detection box as the plane approximation
%   Filter out close planes (those in the last ~40 detections)
%       These will be where the plane is veering off to avoid a collision
%       Will likely skew the data
%   Get the IMU data for the corresponding frames
%   Approach 1
%       Rotate the image using the IMU roll
%       Then adjust for the new image using the pitch info (vertical adjustment)
%   Approach 2
%       Use estimatehorizon
%       This will give the (estimated) line of the horizon
%       Adjust for pitch along the orthoganol to the line
%   Subtract the plane position from the center and save in vector
%   Assume the x-pos and y-pos are independent
%       Fit a 1d gaussian to both the x and y data sets
%       NOTE: only the y is really important... x is less so 
%           (unless assuming head on)


% Horizon
%   Typically the plane locations are close to the horizon. 
%   However, this probability must be quickly estimated in an image.
%   So instead of using a robust horizon estimation technique, the location
%   of the horizon will be estimated using the IMU data. 


%QUESTION: Should I do this fit to the rotated image? 
%   I think so... the fit should be pixel distance from the plane to horizon
%   This will be independent of the distance to the target plane
%   The vertical offset will probably be far more important than horizontal
%   Though the horizontal could probably give a clue for headon approach



% All the files for the videos
filePaths = {
    '/home/geoffrey/Dropbox/Temps/Design_Project/testData/Feb_13_cam1_5.avi', ...
    '/home/geoffrey/Dropbox/Temps/Design_Project/testData/July_6_cam1_01.avi', ...
    '/home/geoffrey/Dropbox/Temps/Design_Project/testData/July_8_cam1_01.avi', ...
    '/home/geoffrey/Dropbox/Temps/Design_Project/testData/July_8_cam1_02.avi', ... 
    '/home/geoffrey/Dropbox/Temps/Design_Project/testData/July_8_cam1_03.avi', ...
    '/home/geoffrey/Dropbox/Temps/Design_Project/testData/July_8_cam1_04.avi', ...
    '/home/geoffrey/Dropbox/Temps/Design_Project/testData/July_8_cam1_08.avi', ... 
    '/home/geoffrey/Dropbox/Temps/Design_Project/testData/Oct_20_cam3_07.avi', ...
};

% Create the plane offset matrix
% This is what the regression will be performed on
planeOffset = [];

for filePath = filePaths
    % Instantiate the video reader
    % If it fails then skip the video
    filePath = char(filePath);
    try
        v = VideoReader(filePath);
        nFrames = v.NumberOfFrames;
    catch
        continue;
    end
        
    % Get the truth rects if they exist
    % If they don't then skip the video
    readRect = readrectxml(filePath);
    if (~readRect)
        continue
    end
    
    
    % Get the IMU Data
    % We are really only concerned about the host, so make sure that exists
    [host, target] = getdetailedsrt(filePath, v.NumberOfFrames);
    if (~isempty(host))
%       host: All of the own-ship information
%       [Frame Number, Altitude (feet), Pitch (degrees), Roll (degrees), Heading]

        % Don't include last 50 image points?
        for i = 1:size(readRect,1)-50
            % Get correct instances of host and curRect
            curRect = readRect(i,:);
            frameNum = curRect(1);
            curHost = host(host(:,1)==frameNum,:);
            
            % Estimate the horizon line
            % NOTE this might be a bit off, won't be too bad though (I think)
            % If the error is consistent, then the error
            % might just be filtered out by the gaussian
            [horizX, horizY] = estimatehorizon(curHost);
            
            
            % Find frame center [x y]
            %TODO check if additional adjustment is needed
            frameCenter = [mean(horizX)/2 mean(horizY)/2];
            
            % Find plane center [x y]
            planeCenter = [curRect(2)+curRect(4)/2 curRect(3)+curRect(5)/2]; 
            
            % Get the offset of the plane and add to the dataset
            planeOffset = [planeOffset; ...
                frameCenter(1)-planeCenter(1) frameCenter(2)-planeCenter(2)];
        end
    end
end

% Decompose points into respective axis
xPoints = planeOffset(:,1);
yPoints = planeOffset(:,2);

% A scatter plot to visualize the data
%scatter(xPoints, yPoints);

% Might be best to have a histogram?
%hist(yPoints);
%histogram(yPoints,'Normalization','pdf')
%histfit(yPoints);

% Fit a pdf to the data
pdfY = fitdist(yPoints, 'Normal')
pdfX = fitdist(xPoints, 'Normal')

hold on;
% PLOT the PDF of Y
y_values = -1025:1:1025;
y = pdf(pdfY,y_values);
plot(y_values,y,'LineWidth',2)

% PLOT the PDF of X
x_values = -1224:1:1224;
x = pdf(pdfX,x_values);
plot(x_values,x,'LineWidth',2)

