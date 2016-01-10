%Horizon idea
%   Towards the horizon there should be very few vertical edges (if any)
%   As the image plane goes to infinity you should theoretically see less
%   detail, so less sharpness right?
%   This wouldn't really work for mountains though


% Next up do an dx on the image matrix and a dy on the image matrix... 
% Also heatmap for the gradient matrix

%filePath = 'testData/Feb_13_cam1_5.avi';
%filePath = 'testData/July_6_cam1_01.avi';
%filePath = 'testData/July_8_cam1_01.avi';
%filePath = 'testData/July_8_cam1_02.avi';
filePath = 'testData/July_8_cam1_03.avi';
%filePath = 'testData/July_8_cam1_04.avi';
%filePath = 'testData/July_8_cam1_08.avi';
%filePath = 'testData/Oct_20_cam3_07.avi';

BUFFER = 10;

% Instantiate the video reader
v = VideoReader(filePath);
readRect = readrectxml(filePath);


% Get the number of frames, frame width, and frame height from the video data
nFrames = v.NumberOfFrames;

[host, target] = getdetailedsrt(filePath, nFrames);



for i = 1:nFrames
    image = read(v,i);
    hostTemp = host(i,:)
    [x,y] = estimatehorizon(hostTemp);
    
    image(horizLine:v.Height, 3*v.Width/4:v.Width) = [0];
    image(v.height/2:v.Height, v.Width/2:3*v.Width/4) = [0];
    % image(645:1190,2200:v.Width) = [0];
    imshow(image)
    line(x,y)
end

%for i=[1 100 500 1000 1200 1500 2000]
%    image = read(v,i);
%    localstr = sprintf('Horizon_Oct_20_cam3_07_Frame%d', i);
%    writeString = strcat(localstr, '.png')
%    imwrite(image, writeString);
%end

% This saves the horizon images that deviate from the windowed mean
% It should save all the horizons that are hard to deal with
%{
movingAvg = 0;
for i = 1:nFrames
    image = read(v,i);
    [sky, terrain] = segmentsky8(image);
    
    localSum = sum(sum(terrain));
    
    if (sum(movingAvg) == 0)
        movingAvg = [localSum localSum localSum localSum localSum];
    end
    
    movingAvg(1:end) = [movingAvg(2:end) localSum];
    avged = mean(movingAvg);    
    if localSum < (avged - avged/5) || localSum > (avged + avged/5)
        localstr = sprintf('Horizon_Feb13_cam1_5_Frame%d', i);
        writeString = strcat(localstr, '.png')
        imwrite(image, writeString);
        
        image = read(v,i-1);
        localstr = sprintf('Horizon_Feb13_cam1_5_Frame%d', i-1);
        writeString = strcat(localstr, '.png')
        imwrite(image, writeString);
    end
end
%}

%{
for i = 1:size(readRect,1)
    curRect = readRect(i,:);
    
    if (curRect(1) == 0)
        return
    end
    
    image = read(v,curRect(1));
    
        
    startRow = curRect(3);
    endRow = curRect(3) + curRect(5);
    startCol = curRect(2);
    endCol = curRect(2) + curRect(4);
    
    image = image(startRow:endRow,startCol:endCol);
    
    BW5 = edge(image,'Sobel',0.10,'both');
    imshowpair(image,BW5,'montage');
end
%}