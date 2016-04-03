%filePath = 'testData/Feb_13_cam1_5.avi';
filePath = 'Test_Data/July_6_cam1_01.avi';
%filePath = 'testData/July_8_cam1_01.avi';
%filePath = 'testData/July_8_cam1_02.avi';
%filePath = 'testData/July_8_cam1_03.avi';
%filePath = 'testData/July_8_cam1_04.avi';
%filePath = 'testData/July_8_cam1_08.avi';
%filePath = 'testData/Oct_20_cam3_07.avi';

% Can alter croppedRect in drawwithhelper to zoom in on the images
% rect = drawwithhelper(filePath,true)
rect = drawscramble(filePath)

readRect = readrectxml(filePath);
writeRect = averagerects(rect, readRect)
writerectxml(filePath, writeRect)