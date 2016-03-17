% The purpose of this is to time the various components of the initial detection phase.
% Definitely test: CMO, 
% Possibly test: iteration through CMOs

% The goal of this is to pair down the number of detections drastically. 
% The first 

% The goal of this is to "learn" the static data from the "truth" images
% The data to learn is as follows (for each "truth" image)
%   highThresh: The maximum CMO response value which corresponds to a plane
%       Any higher and the plane will no longer be picked up
%   lowThresh: The CMO response where non-planes begin to appear
%       1/256 higher than this value is the last threshold for which only
%       the plane appears
%   meanHist: The mean value of the response within the frame
%   eccentricity / avgEccentricity: The eccentricity of the component
%   orientation / avgOrientation: The orientation of the component
%   solidity / avgSolidity: The covex hull area divided by the area of the component

%TODO other metrics to add in?
%TODO need to generate not-plane data, model after the newest
%   generate_images script in deep learning

% filePaths = ['testData/Feb_13_cam1_5.avi' 'testData/July_6_cam1_01.avi' ...
%    'testData/July_8_cam1_01.avi' 'testData/July_8_cam1_02.avi' 'testData/July_8_cam1_03.avi' ...
%    'testData/July_8_cam1_04.avi' 'testData/July_8_cam1_08.avi' 'testData/Oct_20_cam3_07.avi']

filePath = '/home/geoffrey/Dropbox/Temps/Design_Project/testData/July_8_cam1_02.avi'

% Instantiate the video reader
v = VideoReader(filePath);
nFrames = v.NumberOfFrames;
nFrames = 100;
readRect = readrectxml(filePath);

% Type of neighborhood for CMO
%TODO May want to experiment with other nhoods (esp diff sizes)
%TOLEARN Which nHood gets best response
nHoods = [strel('diamond',1) strel('disk',1) strel('diamond',10) strel('disk',10) strel('diamond', 20) strel('disk',20)];
nHoodNames = {'diamond:1'; 'disk:1'; 'diamond:10'; 'disk:10'; 'diamond:20'; 'disk:20'};

thresholds = [0.05 0.15];

fileID = fopen('exp_timing.txt','w');
fprintf(fileID, 'Tested over %d frames \n', nFrames)
fprintf(fileID, 'On video %s \n', filePath)
formatspec = 'nHood: %s, threshold: %f, #Detections: %.1f, CMOtime: %.1f (ms), BWtime: %.1f (ms), labelTime: %.1f (ms) \n';


for j = 1:size(thresholds,2)
    thresh = thresholds(j);
    for k = 1:size(nHoods,2)
        nHood = nHoods(k);
        nHoodName = nHoodNames{k}
        
        CMOtime = 0;
        BWtime = 0;
        labelTime = 0;
        nDetections = 0;

        for i = 1:nFrames
            i
            image = read(v,i);

            % Perform a CMO
            cmo = tic;
            open = imopen(image,nHood);
            close = imclose(image,nHood); 
            im = close - open;
            CMOtime = CMOtime + toc(cmo);

            % Conversion to a black-white image
            bwt = tic;
            bw = im2bw(im, thresh);
            BWtime = BWtime + toc(bwt);
            
            % Labeling and gathering the regionProps
            lt = tic;
            L = bwlabel(bw);
            s = regionprops(L,'BoundingBox','Centroid');
            labelTime = labelTime + toc(lt);
            
            nDetections = nDetections + numel(s);
        end    
        
        fprintf(fileID, formatspec, nHoodName, thresh, nDetections/nFrames, CMOtime*1000/nFrames, BWtime*1000/nFrames, labelTime*1000/nFrames);
    end
end

fclose(fileID);