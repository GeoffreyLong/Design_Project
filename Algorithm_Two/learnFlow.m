
% Take in the roll / pitch / yaw using testData/getdetailedsrt.m
% Within local windows i.e. sized 24x24 or thereabouts
%   Calculate the expected flow based on these params
%       i.e. how the local features are supposed to change based on their 
%       position in the frame and the ego motion
%       This estimation would be based on the camera intrinsics 
%       See the file Algorithm_One/estimateplanelocation.m for help
%       At any rate the projections in this script probably need to be improved
%   Search for any deviations
% In a head on collision scenario there won't be any deviations, 
%   only growth of the plane, so this won't help to much in that
% It is possible that this will allow us to remove ego motion from the
%   motion of the features though, which will allow us to estimate the
%   trajectory of the plane
% It would be best if we could learn what a 
%   combination of window location and camera motion does to the local
%   image flow... i.e. learn what adjustments need to be made in each scenario
%   to account for the ego motion



% Instantiate the video reader
v = VideoReader('/Users/Xavier/Documents/workspace/Design_Project/Algorithm_Two/cam1_01.avi');

% Get the number of frames, frame width, and frame height from the video data
nFrames = v.NumberOfFrames;
    

% Get SRT data
% srt call should go in a sepertae file, should just pass in row of data
% related to frame of interest
srt = getdetailedsrt('/Users/Xavier/Documents/workspace/Design_Project/testData/July_6_cam1_01.srt',nFrames);
% get data from row of interest
% srtData = srt(1,:); % [Frame Number, Altitude (feet), Pitch (degrees), Roll (degrees), Heading]
 
% rectangle = int32([10 10 30 30]); %[x y width height]
rectWidth = 24; %rectangle width well be ... pixels
rectHeight = 24; %rect height well be ... pixels
numRects = v.Width/rectWidth; %600/24=25

imgHeight = v.Height;

% Initiate search at top left corner of image
x_pixel = 0;
y_pixel = 0;
rectArray = [];

%translation matrix = [1 0 0; 0 1 0; x y 1]
%http://www.mathworks.com/help/images/performing-general-2-d-spatial-transformations.html
%tform_translate = affine2d([1 0 0; 0 1 0; x y 1]);
%tform = affine3d([cos(pitch) 0 -sin(pitch) 0; 0 1 0 0; sin(pitch) 0 cos(pitch) 0; 0 0 0 1 ] );
%transImage = imwarp(curImage, tform);
for i = 1:nFrames
    
    % get data from row of interest
    srtData = srt(i,:); % [Frame Number, Altitude (feet), Pitch (degrees), Roll (degrees), Heading]
    % roll is rotation around the middle of the plane (twist)
    roll = srtData(4);
    % pitch is rotation around center of gravity (flip)
    pitch = srtData(3);
    yaw = 0;
       
    curImage = read(v,i);
    
%     outputImage = imwarp(curImage,tform);
%     imshow(outputImage);
    
     if i~=1800
         
         rollImage = imrotate(curImage, -roll, 'crop');
         % diffImage = imabsdiff(compImage,pastImage);
         
         % To do: translation motion
         % shift x pixels, y pixels
         x = 0;
         % check eqn, probs not correct
         %as plane is always on the same level as target, and pitch only
         %flucuates 1-4 degrees, not much point in compensating for it
         y = sin(degtorad(pitch))*v.Height;
        
         transImage = imtranslate(rollImage, [x,y]);%, 'OutputView', 'full');
         
%          RGB = insertText(transImage, [1 50],pitch,'FontSize',40,'BoxColor','red','BoxOpacity',0.4,'TextColor','white');

         imshow(transImage);
%          pastImage = curImage;
%          C = imfuse(curImage,transImage);
%          imshow(C);
         
        
     else
%          compImage = imwarp(curImage,tform);
%          rollImage = imrotate(curImage, -roll, 'crop');
%          pastImage = curImage;
     end    
    
    
end

