% This script is intended to be a tool in aggregating and visualizing 
%   selected videos and folders.

% So I want as the input is the 
%   folder name, 
%   possibly the videos (probs not though), (could have an agg all flag)
%   Then the attrs I want aggregated over

% folders = {'folder1', 'folder2', ...}
% separateVideos = boolean
%   If true then do not average / sum values across videos
tests = {{'attr1','attr2','attr3'},{'attr1','attr3'}};
% Alternatively could make this a struct 
%   Could have title, type (plot, bar, etc)
%   Maybe even renaming strategies for the attributes?

% Collapse = 1 if you would like to collapse the values over videos and files
% This occurs for both average and sum
collapse = 1;


masterFolders = {'20160406T203250'};

testData = struct('folderName', {}, 'videoName', {}, 'fileName', {}, 'attribute', {}, 'value', {});
% if collapsed then this becomes
collapseData = struct('folderName', {}, 'collapseType', {}, 'attribute', {}, 'value', {});
% Where collapseType is avg or sum

% When sanitizing for outputs this becomes
% outputData = struct('attribute', {}, 'value', {});
% And attribute is essentially a concatenated list of the earlier fields
% So it would be like folderName_videoName_fileName_attribute 

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

% Collapsing the video data (collapse by both average and sum)
testCells = struct2cell(testData);
%sum(cat(1,testData.attribute))

%testData(folderName)
if (collapse)
    for i = 1:numel(testData)
        %testData.attribute
        %testData(testData.attribute == 'Detection Quality')
        %find(testData.attribute == 'Detection Quality')
        find(cellfun(@(x)isequal(x,'Detection Quality'),{testData.attribute}))
    end
    % cat(1,testData.fileName)
end

% struct2table(testData)

% Simple bar chart generation
% NOTE: there is probably a one line solution to this... would be cool to have
%   Would also be cool to derive, but time constraints won't permit that
for i = 1:numel(tests)
    test = tests{i};
    for j = 1:numel(test)
        attr = test{j};
        
        % Select the appropriate attributes
        for j = 1:numel(testData)
            % testData = struct('folderName', {}, 'videoName', {}, 'fileName', {}, 'attribute', {}, 'value', {});
            testData(i).folderName;

        end
    end
end


