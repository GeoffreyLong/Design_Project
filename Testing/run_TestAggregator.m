% This script is intended to be a tool in aggregating and visualizing 
%   selected videos and folders.

% So I want as the input is the 
%   folder name, 
%   possibly the videos (probs not though), (could have an agg all flag)
%   Then the attrs I want aggregated over

% folders = {'folder1', 'folder2', ...}
% separateVideos = boolean
%   If true then do not average / sum values across videos
tests = {{'attr1','attr2','attr3'},{'attr1','attr3'}}


masterFolders = {'20160406T203250'};

testData = struct('folderName', {}, 'videoName', {}, 'fileName', {}, 'attribute', {}, 'value', {});

% Aggregation phase... get all the data into the testData structure
for i = 1:numel(masterFolders)
    masterFolderName = masterFolders{i};
    
    testFileBase = strcat('../Testing/Test_Instances/',masterFolderName,'/')
    d = dir(testFileBase);
    isub = [d(:).isdir];
    videoDirectories = {d(isub).name}';
    videoDirectories(ismember(videoDirectories,{'.','..'})) = [];
    
    for j = 1:numel(videoDirectories)
        videoName = videoDirectories{j};
        resultBase = strcat(testFileBase, videoName, '/Results/')
        resultDir = dir(resultBase);
        
        for k = 1:numel(resultDir)
            extension = strsplit(resultDir(k).name,'.');
            if strcmp(extension(2), 'txt')
                fileID = fopen(resultDir(k).name);
                line = fgetl(fileID);
                while(ischar(line))
                    try
                        tokens = strsplit(line, ':');
                        newStruct = struct('folderName', masterFolderName, ...
                            'videoName', videoName, 'fileName', extension(1), ...
                            'attribute', strtrim(tokens(1)), 'value', strtrim(tokens(2)));
                        testData(end+1) = newStruct;
                    catch
                        % Just go to the next attr
                        % Possibly a formatting issue
                    end
                    line = fgetl(fileID);
                end
            end
        end
    end
end

