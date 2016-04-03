% filePaths = ['testData/Feb_13_cam1_5.avi' 'testData/July_6_cam1_01.avi' ...
%    'testData/July_8_cam1_01.avi' 'testData/July_8_cam1_02.avi' 'testData/July_8_cam1_03.avi' ...
%    'testData/July_8_cam1_04.avi' 'testData/July_8_cam1_08.avi' 'testData/Oct_20_cam3_07.avi']

filePath = '/home/geoffrey/Dropbox/Temps/Design_Project/testData/July_8_cam1_02.avi'

% Instantiate the video reader
v = VideoReader(filePath);
nFrames = v.NumberOfFrames;
readRect = readrectxml(filePath, 'tightBound_');

% Type of neighborhood for CMO
%TODO May want to experiment with other nhoods (esp diff sizes)
%TOLEARN Which nHood gets best response
nHoods = [strel('disk', 1), strel('diamond', 1), strel('rect',[1,3]),...
    strel('disk', 2), strel('diamond', 2), strel('rect',[3,1]), ...
    strel('disk', 3), strel('diamond', 3), strel('rect',[2,3]),...
    strel('disk', 5), strel('diamond', 5), strel('rect',[3,2]),...
    strel('disk', 10), strel('diamond', 10), strel('rect',[3,5]),...
    strel('disk', 25), strel('diamond', 25), strel('rect',[5,3]),...
    strel('disk', 100), strel('diamond', 100), strel('rect',[4,10])];
nHoodNames = {'disk1','diamond1','rect[1,3]', ...
    'disk2','diamond2','rect[3,1]', ...
    'disk3','diamond3','rect[2,3]', ...
    'disk5','diamond5','rect[3,2]', ...
    'disk10','diamond10','rect[3,5]', ...
    'disk25','diamond25','rect[5,3]', ...
    'disk100','diamond100','rect[4,10]'};
thresholds = [0.07 0.09 0.11 0.13 0.15];
% nHoodDilate = ones(3,3);


fileID = fopen('exp_cmo.txt','w');
formatspec = 'nHood: %s, threshold: %f, totalDetections: %d, planes: %d/%d, time: %d \n';


for j = 1:size(thresholds,2)
    thresh = thresholds(j);
    for k = 1:size(nHoods,2)
        nHood = nHoods(k);
        nHoodName = nHoodNames{k}
        
        positives = 0;
        total = 0;
        frames = 0;
        tstart = tic;
        for i = 1:nFrames
            i
            curRect = readRect(readRect(:,1)==i,:);
            if (isempty(curRect))
                continue;
            end
            
            image = read(v,i);

            % Perform a CMO
            open = imopen(image,nHood);
            close = imclose(image,nHood); 
            im = close - open;

            bw = im2bw(im, thresh);
            L = bwlabel(bw);

            s = regionprops(L,'BoundingBox');

            plane = 0;
            for l=1:numel(s)
                newBound = s(l).BoundingBox;
                
                % Value of 0.50 arbitrarily set
                if (bboxOverlapRatio(newBound,curRect(2:5)) >= 0.50)
                    plane = 1;
                end
                total = total + 1;
            end
            
            positives = positives + plane;
            frames = frames + 1;
        end    
        
        time = toc(tstart)
        fprintf(fileID, formatspec, nHoodName, thresh, total, positives, frames, time);
    end
end

fclose(fileID);