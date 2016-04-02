% NOTE: Need to be in Design_Project/System for this to work...
% Any file that you want to function handle also has to be in this directory

% Add all videos for testing
videos = {
    'Test_Data/Feb_13_cam1_5.avi', ...
    'Test_Data/July_6_cam1_01.avi', ...
    'Test_Data/July_8_cam1_01.avi', ...
    'Test_Data/July_8_cam1_02.avi', ... 
    'Test_Data/July_8_cam1_03.avi', ...
    'Test_Data/July_8_cam1_04.avi', ...
    'Test_Data/July_8_cam1_08.avi', ... 
    'Test_Data/Oct_20_cam3_07.avi', ...
};

% Declare a detection function
anon_detect = @(im,host,height,width) initial_detections(im,host,height,width);

% Run the test generator
testgenerator(videos, anon_detect);

