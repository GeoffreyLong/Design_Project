%filePath = 'testData/Feb_13_cam1_5.avi';
%filePath = 'testData/July_6_cam1_01.avi';
%filePath = 'testData/July_8_cam1_01.avi';
filePath = 'testData/July_8_cam1_02.avi';
%filePath = 'testData/July_8_cam1_03.avi';
%filePath = 'testData/July_8_cam1_04.avi';
%filePath = 'testData/July_8_cam1_08.avi';
%filePath = 'testData/Oct_20_cam3_07.avi';


% Instantiate the video reader
v = VideoReader(filePath);
readRect = readrectxml(filePath);


% Get the number of frames, frame width, and frame height from the video data
nFrames = v.NumberOfFrames;
[host, target] = getdetailedsrt(filePath, nFrames);
[horizX, horizY] = estimatehorizon(host(1,:));
lastHorizon = [horizX(1) horizY(1) horizX(2) horizY(2)];
for i = 1:nFrames
    image = read(v,i);
    imshow(image);    
    [sky, terrain, lastHorizon] = segmentsky10(image, lastHorizon);
    
    line([lastHorizon(1) lastHorizon(3)], [lastHorizon(2) lastHorizon(4)]);
end
