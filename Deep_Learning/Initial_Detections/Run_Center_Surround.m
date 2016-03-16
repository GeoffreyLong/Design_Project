% This is an attempt to use a center surround type of detection mechanism

% filePaths = ['testData/Feb_13_cam1_5.avi' 'testData/July_6_cam1_01.avi' ...
%    'testData/July_8_cam1_01.avi' 'testData/July_8_cam1_02.avi' 'testData/July_8_cam1_03.avi' ...
%    'testData/July_8_cam1_04.avi' 'testData/July_8_cam1_08.avi' 'testData/Oct_20_cam3_07.avi']

filePath = '/home/geoffrey/Dropbox/Temps/Design_Project/testData/July_8_cam1_02.avi'

% Instantiate the video reader
v = VideoReader(filePath);
nFrames = v.NumberOfFrames;
% readRect = readrectxml(filePath);

%fileID = fopen('exp_cmo.txt','w');

block = [20 20];
fun = @(block_struct) centersurround(block_struct.data, block);


for i = 2600:nFrames
    i
    % curRect = readRect(readRect(:,1)==i,:);
    %if (isempty(curRect))
    %    continue;
    %end

    image = read(v,i);    
    %imshow(image)

    newIm = blockproc(image, block, fun);
    imshow(newIm, []);
    %bw = im2bw(im, thresh);
    %L = bwlabel(bw);

    %s = regionprops(L,'BoundingBox');

%    for l=1:numel(s)
 %       newBound = s(l).BoundingBox;
  %  end

end    
        

%fclose(fileID);