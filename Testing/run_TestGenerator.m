% NOTE: Need to be in Design_Project/System for this to work...
% Any file that you want to function handle also has to be in this directory

% NOTE: Fill this in to save a description of the tests run
testDescription = ['Plain vanilla testing'];

% Add all videos for testing
videos = {
    '../Test_Data/July_6_cam1_01.avi', ...
    '../Test_Data/July_8_cam1_02.avi', ... 
    '../Test_Data/July_8_cam1_03.avi', ...
    %'Test_Data/Feb_13_cam1_5.avi', ...
    %'../Test_Data/July_6_cam1_02.avi', ...
    %'Test_Data/July_8_cam1_01.avi', ...
    %'Test_Data/July_8_cam1_04.avi', ...
    %'Test_Data/July_8_cam1_08.avi', ... 
    %'Test_Data/Oct_20_cam3_07.avi', ...
};

% Declare a detection function
anon_detect = @(im,host,height,width) initial_detections(im,host,height,width);



% NOTE: Tracker is not anonymous
% Any changes to tracker must be made in testgenerator


% Make the test folder
folderName = datestr(now,'yyyymmddTHHMMSS');
mkdir('../Testing/Test_Instances/', folderName);
testFileBase = strcat('../Testing/Test_Instances/',folderName,'/');

fileID = fopen(strcat(testFileBase,'Description.txt'),'w');
fprintf(fileID, testDescription);
fclose(fileID);

% Iterate through the cell of videos
for vidIdx = 1:numel(videos)
    % Select one of the videos for testing
    filePath = char(videos{vidIdx});

    filePathTokens = strsplit(filePath(1:end-4), '/');
    vidName = filePathTokens(end);
    mkdir(testFileBase, vidName{1});
    newFileBase = strcat(testFileBase, vidName{1}, '/')

    % Run the test generator
    %TODO Consider name-value pair arguments
    testgenerator(filePath, anon_detect, newFileBase);
end