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
    
opticalFlow = vision.OpticalFlow;

for i = 1:nFrames 
    curImage = read(v,i); 
    curImage = im2double(curImage);
    V = step(opticalFlow, curImage);
    
    new = V(:,:) >= 0.0100;
    imshow(new);
    
    %imshow(V);
end

