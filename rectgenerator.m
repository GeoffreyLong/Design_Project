filePath = '/home/geoffrey/Dropbox/Temps/Design_Project/Feb_13_cam1_5.avi';

rect = drawwithhelper(filePath);

readRect = readrectxml(filePath);
writeRect = averagerects(rect, readRect)
writerectxml(filePath, writeRect)
    