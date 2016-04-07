%NOTE make sure this is run in Design_Project and not a subfolder

%filePath = 'testData/Feb_13_cam1_5.avi';
%filePath = 'Test_Data/July_6_cam1_01.avi';
%filePath = 'Test_Data/July_6_cam1_02.avi';
%filePath = 'testData/July_8_cam1_01.avi';
filePath = 'Test_Data/July_8_cam1_02.avi';
%filePath = 'testData/July_8_cam1_03.avi';
%filePath = 'testData/July_8_cam1_04.avi';
%filePath = 'testData/July_8_cam1_08.avi';
%filePath = 'testData/Oct_20_cam3_07.avi';

% Can alter croppedRect to zoom in on the images
xOffset = 0;
yOffset = 600;
width = 1200;
height = 700;
croppedRect = [xOffset,yOffset,width,height];

%2428,923,924,17,7
%2429,919,930,17,7
%2430,914,933,18,7
% extension=''; rect = drawwithhelper(filePath, croppedRect, true)
% extension='scrambled_'; rect = drawscramble(filePath, croppedRect, 1400)

% LastFrame is the frame you want to start at (going backwards)
%   If unsure then set to nFrames (or 0, which will default to nFrames)
% appendRect can be passed in to start at a certain point too
%   This will nullify the lastFrame
%   If this is not desired then pass in an empty []
lastFrame = 2429;
extension='optimized_'; 
appendRect = readrectxml(filePath, extension);
%extension='optimized_'; rect = drawoptimized(filePath, lastFrame)
rect = rectgeneratorV3(filePath, lastFrame, appendRect)


readRect = readrectxml(filePath, extension);
writeRect = averagerects(rect, readRect)
writerectxml(filePath, writeRect, extension)