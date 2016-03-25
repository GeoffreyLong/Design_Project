% I really didn't know what to call this
% This is to test responses of different algorithms on the detected rectangle sections
% i.e. previously pulled rects


% filePaths = ['testData/Feb_13_cam1_5.avi' 'testData/July_6_cam1_01.avi' ...
%    'testData/July_8_cam1_01.avi' 'testData/July_8_cam1_02.avi' 'testData/July_8_cam1_03.avi' ...
%    'testData/July_8_cam1_04.avi' 'testData/July_8_cam1_08.avi' 'testData/Oct_20_cam3_07.avi']

filePath = '/home/geoffrey/Dropbox/Temps/Design_Project/testData/July_8_cam1_02.avi'

% Instantiate the video reader
v = VideoReader(filePath);
nFrames = v.NumberOfFrames;
readRect = readrectxml(filePath);

%kern = [0 0 -10 0 0; 0 1 1 1 0; -10 1 50 1 -10; 0 1 1 1 0; 0 0 -10 0 0];
%kern = kern/30;

kernel = ones(10);

kernel(4,4) = -5;
kernel(4,5) = -5;
kernel(4,6) = -5;

kernel(5,4) = -5;
kernel(5,5) = 10;
kernel(5,6) = -5;


kernel(6,4) = -5;
kernel(6,5) = -5;
kernel(6,6) = -5;

kernel = kernel/100;

for i = 2600:nFrames
    curRect = readRect(readRect(:,1)==i,:);
    if (isempty(curRect))
        continue;
    end

    image = read(v,i);    
    subIm = image(curRect(3):curRect(3) + curRect(5), curRect(2):curRect(2)+curRect(4));
    
    convIm = imfilter(subIm, kernel);
    %convIm = abs(convIm - mean2(convIm));
    
    imshowpair(subIm, convIm, 'montage');
    %bw = im2bw(im, thresh);
    %L = bwlabel(bw);

    %s = regionprops(L,'BoundingBox');

%    for l=1:numel(s)
 %       newBound = s(l).BoundingBox;
  %  end

end    