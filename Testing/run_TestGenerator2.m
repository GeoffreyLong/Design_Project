% NOTE: Need to be in Design_Project/System for this to work...
% Any file that you want to function handle also has to be in this directory

% Add all videos for testing
videos = {
    '../Test_Data/July_6_cam1_01.avi', ...
    '../Test_Data/July_6_cam1_02.avi', ...
    '../Test_Data/July_8_cam1_02.avi', ... 
    '../Test_Data/July_8_cam1_03.avi', ...
    %'Test_Data/Feb_13_cam1_5.avi', ...
    %'Test_Data/July_8_cam1_01.avi', ...
    %'Test_Data/July_8_cam1_04.avi', ...
    %'Test_Data/July_8_cam1_08.avi', ... 
    %'Test_Data/Oct_20_cam3_07.avi', ...
};

%nHoods = [strel('disk', 1), strel('diamond', 1), strel('rect',[1,3]),...
%    strel('disk', 4), strel('diamond', 4), strel('rect',[3,2]),...
%    strel('disk', 7), strel('diamond', 7), strel('rect',[3,5]),...
%    strel('disk', 15), strel('diamond', 15), strel('rect',[5,3]),...
%    strel('disk', 30), strel('diamond', 30), strel('rect',[4,10])];
%nHoodNames = {'disk1','diamond1','rect[1,3]', ...
%    'disk4','diamond4','rect[2,3]', ...
%    'disk7','diamond7','rect[3,5]', ...
%    'disk15','diamond15','rect[5,3]', ...
%    'disk30','diamond30','rect[4,10]'};
%thresholds = [0.05 0.7 0.9 0.10 0.11 0.13 0.15];

nHoods = [strel('disk', 4), strel('disk', 7), strel('disk', 15)];
nHoodNames = {'disk4','disk7','disk15'};
thresholds = [0.8 0.10 0.12];


for i = 1:size(nHoods,2)
    nHood = nHoods(i);
    nHoodName = nHoodNames{i};

    for j = 1:numel(thresholds)
        thresh = thresholds(j);

        % NOTE: Fill this in to save a description of the tests run
        testDescription = sprintf('All videos, strel: %s, thresh: %f', nHoodName, thresh);

        % Declare a detection function
        % nHood and thresh are optional parameters
        anon_detect = @(im,host,height,width) initial_detections(im,host,height,width,nHood,thresh);



        % NOTE: Tracker is not anonymous
        % Any changes to tracker must be made in testgenerator


        % Make the test folder
        %folderName = datestr(now,'yyyymmddTHHMMSS');
        folderName = sprintf('All_strel_%s_thresh_%f', nHoodName, thresh);
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

    end
end