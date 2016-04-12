function testaggregator( tests, masterFolders, folderNames, titleString, yAxisLabel, collapse, saveLocation, attrRename, byAttr, stage )
%TESTAGGREGATOR Will create bar charts
%   Might want to just pass in the structure
%   that might be easier at this point


    testData = struct('folderName', {}, 'videoName', {}, 'fileName', {}, 'attribute', {}, 'value', {});
    % if collapsed then this becomes struct('folderName', {}, 'attribute', {}, 'value', {});


    % When sanitizing for outputs this becomes
    % outputData = struct('attribute', {}, 'value', {});
    % And attribute is essentially a concatenated list of the earlier fields
    % So it would be like folderName_videoName_fileName_attribute 

    % Aggregation phase... get all the data into the testData structure
    for i = 1:numel(masterFolders)
        masterFolderName = masterFolders{i};

        % Get all of the video directories from the test folder
        testFileBase = strcat('../Testing/Test_Instances/',masterFolderName,'/');
        d = dir(testFileBase);
        isub = [d(:).isdir];
        videoDirectories = {d(isub).name}';
        videoDirectories(ismember(videoDirectories,{'.','..'})) = [];

        for j = 1:numel(videoDirectories)
            % Get the results folder from the video folder
            videoName = videoDirectories{j};
            resultBase = strcat(testFileBase, videoName, '/Results/')
            resultDir = dir(resultBase);


            for k = 1:numel(resultDir)
                extension = strsplit(resultDir(k).name,'.');
                if strcmp(extension(2), 'txt')
                    trackCheck = strsplit(resultDir(k).name, '_');
                    if (strcmp('track', trackCheck(1)) && strcmp('postTrack', stage)) ...
                            || (~strcmp('track', trackCheck(1)) && strcmp('preTrack', stage)) ...
                            || strcmp('all', stage) || strcmp('compare', stage)
                        strcat(resultBase,resultDir(k).name)
                        fileID = fopen(strcat(resultBase,resultDir(k).name));
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
                        fclose(fileID);
 
                    end                    
                end
            end
        end
    end

    % Collapsing the video data (collapse by both average and sum)
    collapseDataSum = struct('folderName', {}, 'attribute', {}, 'value', {});
    collapseDataAvg = struct('folderName', {}, 'attribute', {}, 'value', {});

    attrValues = unique(extractfield(testData, 'attribute'));
    folderValues = unique(extractfield(testData, 'folderName'));

    %testData(folderName)
    if (collapse)
        for i = 1:numel(folderValues)
            for j = 1:numel(attrValues)
                folderKeys = find(cellfun(@(x)strcmp(x,folderValues(i)),{testData.folderName}));
                attrKeys = find(cellfun(@(x)strcmp(x,attrValues(j)),{testData.attribute}));

                keys = intersect(folderKeys, attrKeys);

                sum = 0;
                for k = 1:numel(keys)
                    sum = sum + str2num(testData(keys(k)).value);
                end

                collapseDataSum(end+1) = struct('folderName', folderValues(i), 'attribute', attrValues(j), 'value', sum);
                collapseDataAvg(end+1) = struct('folderName', folderValues(i), 'attribute', attrValues(j), 'value', sum/numel(keys));
            end
        end
    end
    % cat(1,testData.fileName)
    struct2table(collapseDataAvg)
    struct2table(collapseDataSum)

    % Converting to human friendly format
    % Only really interesting if across several folders I think
    % Possibilities
    %   Simple bar chart generation
    %   Simple line graph generation
    %   Simple table generation
    % NOTE: there is probably a one line solution to this... would be cool to have
    %   Would also be cool to derive, but time constraints won't permit that
    for i = 1:numel(tests)
        test = tests{i};
        attrNames = attrRename{i};

        % For plotting or bar charts
        % If we want to group by test, grouping by folder is the opposite
        % zeros(numel(test), numel(folders))
        vals = [];

        for j = 1:numel(test)
            attr = test{j};

            % Currently only doing avg keys
            % Could add an aggregation type to the specific test though
            %   Some fields don't do well with sum though (like false positive rate)
            %   Avg is a safe bet
            %fullKeys = find(cellfun(@(x)strcmp(x,attrValues(j)),{testData.attribute}));
            %sumKeys = find(cellfun(@(x)strcmp(x,attrValues(j)),{collapseDataSum.attribute}));
            avgKeys = find(cellfun(@(x)strcmp(x,attr),{collapseDataAvg.attribute}));

            tempVals = [];
            for k = 1:numel(avgKeys)
                value = collapseDataAvg(avgKeys(k)).value;
                if (isempty(value))
                    value = 0
                end
                tempVals = [tempVals; value];
            end
            vals = [vals tempVals];
        end
        % Will group them by folder (I guess) with a legend of tests
        % Apparently we cannot give nonumeric labels to the xAxis
        
        if (byAttr)
            h = bar(vals')
            legend(h, folderNames)
            % Rename the x axis labels
            set(gca,'XTickLabel',attrNames)
        else
            h = bar(vals)
            legend(h, attrNames)
            % Rename the x axis labels
            set(gca,'XTickLabel',folderNames)
        end
        
        ylabel(yAxisLabel)
        title(titleString)
        % set(gca,'XTickLabel',{'apples', 'oranges', 'strawberries', 'pears'})
        saveString = sprintf('%s_%d.jpg', saveLocation, i);
        saveas(gcf, saveString);
    end
end

