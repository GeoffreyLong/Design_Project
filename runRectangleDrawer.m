filePath = '/home/geoffrey/Dropbox/Temps/Design_Project/testData/July_8_cam1_01.avi';

rect = drawwithhelper(filePath);

readRect = readrectxml(filePath);
writeRect = averagerects(rect, readRect)
writerectxml(filePath, writeRect)
    