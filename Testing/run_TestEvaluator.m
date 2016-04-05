% This script runs the tests for a given testing instance or instances
% Want to pass a folder to the test evaluator function
folderName = '20160402T191901';

% Set the name of the specific directory and get the files from it
testFileBase = strcat('../Testing/Test_Instances/',folderName,'/');
files = dir(testFileBase);

% Loop over the files in the directory
for i=1:numel(files)
    fileName = files(i).name
    
    % The string to the left of the first underscore is the system component
    % The string to the right of the first underscore is the video
    [component, video] = strtok(fileName, '_');
    video = video(2:end);

    
    truthRects = readrectxml(video,'optimized_')
    detections = [];
    % Read in the data corresponding to the file
    if strcmp(component,'detection')
        detections = csvread(filename);
    elseif strcmp(component,'tracking')
        
    elseif strcmp(component,'ttc')
        
    end
end
