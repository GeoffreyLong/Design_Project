% filePaths = ['testData/Feb_13_cam1_5.avi' 'testData/July_6_cam1_01.avi' ...
%    'testData/July_8_cam1_01.avi' 'testData/July_8_cam1_02.avi' 'testData/July_8_cam1_03.avi' ...
%    'testData/July_8_cam1_04.avi' 'testData/July_8_cam1_08.avi' 'testData/Oct_20_cam3_07.avi']

filePath = '/home/geoffrey/Dropbox/Temps/Design_Project/testData/July_8_cam1_02.avi'

% Instantiate the video reader
v = VideoReader(filePath);
nFrames = v.NumberOfFrames;
readRect = readrectxml(filePath);

% Type of neighborhood for CMO
%TODO May want to experiment with other nhoods (esp diff sizes)
%TOLEARN Which nHood gets best response
nHoods = [strel('disk', 75), strel('diamond', 75), ...
    strel('disk', 100), strel('diamond', 100)];
nHoodNames = {'disk75','diamond75','disk100','diamond100'};
thresholds = [0.10 0.12 0.15];
nHoodDilate = ones(3);


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
                if (bboxOverlapRatio(newBound,curRect(2:5)))
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