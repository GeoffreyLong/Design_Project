% This script runs the tests for a given testing instance or instances
% Want to pass a folder to the test evaluator function
folderName = '20160406T153246';

% Set the name of the specific directory and get the files from it
testFileBase = strcat('../Testing/Test_Instances/',folderName,'/')
files = dir(testFileBase);


opt_truth = [];
scramble_truth = [];
host = [];
target = [];

nFrames = 0;
height = 0;
width = 0;

detections = [];

% Loop over the files in the directory
for i=1:numel(files)
    fileName = files(i).name
    
    % The string to the left of the first underscore is the system component
    % The string to the right of the first underscore is the video
    [component, video] = strtok(fileName, '_');
    video = video(2:end-4);
    if (isempty(video)) 
        continue;
    end

    if (nFrames == 0)
        opt_truth = readrectxml(video,'optimized_');
        scramble_truth = readrectxml(video,'scramble_'); 
        
        % Might be a bad idea to require reading in the video
        % Might be better just to store this information somewhere
        videoFile = strcat('../Test_Data/', video);
        v = VideoReader(videoFile);
        nFrames = v.NumberOfFrames;
        height = v.Height;
        width = v.Width;
        
        [host, target] = getdetailedsrt(videoFile, nFrames);
    end
    
    % Read in the data corresponding to the file
    if strcmp(component,'detection')
        detections = csvread(strcat(testFileBase,fileName));
    elseif strcmp(component,'tracking')
        
    elseif strcmp(component,'ttc')
        
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
if (~isempty(detections) && ~isempty(opt_truth) && ~isempty(target))
    
end
