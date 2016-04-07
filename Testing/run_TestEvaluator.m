% This script runs the tests for a given testing instance or instances
% Want to pass a folder to the test evaluator function
folderName = '20160406T201401';

% Set the name of the specific directory and get the files from it
testFileBase = strcat('../Testing/Test_Instances/',folderName,'/')
d = dir(testFileBase);
isub = [d(:).isdir]; %# returns logical vector
videoDirectories = {d(isub).name}';
videoDirectories(ismember(videoDirectories,{'.','..'})) = [];

opt_truth = [];
scramble_truth = [];
host = [];
target = [];

nFrames = 0;
height = 0;
width = 0;

detections = [];
timing = [];

% Loop over the files in the directory
for i=1:numel(videoDirectories)
    video = videoDirectories{i}

    newFileBase = strcat(testFileBase, video, '/')

    opt_truth = readrectxml(strcat(video,'.avi'),'optimized_');
    scramble_truth = readrectxml(strcat(video,'.avi'),'scramble_'); 

    % Might be a bad idea to require reading in the video
    % Might be better just to store this information somewhere
    videoFile = strcat('../Test_Data/', video, '.avi');
    v = VideoReader(videoFile);
    nFrames = v.NumberOfFrames;
    height = v.Height;
    width = v.Width;

    [host, target] = getdetailedsrt(videoFile, nFrames);
    
    files = dir(newFileBase);
    for j=1:numel(files)
        fileName = files(j).name

        % Read in the data corresponding to the file
        if strcmp(fileName,'detection.dat')
            detections = csvread(strcat(newFileBase,fileName));
        elseif strcmp(fileName,'tracking.dat')

        elseif strcmp(fileName,'ttc.dat')

        elseif strcmp(fileName,'timing.dat')
            timing = csvread(strcat(testFileBase,fileName));
        end     
    end
end
% Make a results folder
mkdir(strcat('../Testing/Test_Instances/', folderName, '/'), 'Results');
resultFileBase = strcat('../Testing/Test_Instances/', folderName, '/Results/');

% These next if statements test the detection results against the truth files
if (~isempty(detections) && ~isempty(opt_truth))
    test_DetectionVSRects(strcat(resultFileBase,'optimized_'), nFrames, detections, opt_truth);
end
if (~isempty(detections) && ~isempty(scramble_truth))
    %TODO some false positives in this case might not actually be an issue
    test_DetectionVSRects(strcat(resultFileBase,'scrambled_'), nFrames, detections, scramble_truth);    
end

% This will gather metrics such as 
%   distance of first sighting
%   estimated time to collision of first sighting 
%   timing metrics
if (~isempty(detections) && ~isempty(opt_truth) && ~isempty(target) && ~isempty(timing))
    test_DetectionMetrics(resultFileBase, detections, opt_truth, target, timing);
end
