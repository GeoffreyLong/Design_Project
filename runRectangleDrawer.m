filePath = 'testData/Feb_13_cam1_5.avi';
%filePath = 'testData/July_6_cam1_01.avi';
%filePath = 'testData/July_8_cam1_01.avi';
%filePath = 'testData/July_8_cam1_08.avi';
%filePath = 'testData/Oct_20_cam3_07.avi';

rect = drawwithhelper(filePath);

readRect = readrectxml(filePath);
writeRect = averagerects(rect, readRect)
writerectxml(filePath, writeRect)
    