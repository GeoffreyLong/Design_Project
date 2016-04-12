% This script is intended to be a tool in aggregating and visualizing 
%   selected videos and folders.

% So I want as the input is the 
%   folder name, 
%   possibly the videos (probs not though), (could have an agg all flag)
%   Then the attrs I want aggregated over

% Detection metrics (false positives etc) after initial detection over different thresholds
tests = struct('attributes', {{{'False Positives','False Negatives','True Positives', 'True Negatives'}}}, ...
    'attrRename', {{{'False Positives','False Negatives','True Positives', 'True Negatives'}}}, ...
    'folders', {{'strel-disk7 thresh-0.08', 'strel-disk7 thresh-0.10', 'strel-disk7 thresh-0.12'}}, ...
    'folderRename', {{'Threshold = 0.08', 'Threshold = 0.10', 'Threshold = 0.12'}}, ...
    'plotTitle', 'Detections per Video Over Various Thresholds', ...
    'yAxisLabel', 'Occurences Per Frame', ...
    'saveLocation', '../figures/DetectionVSThresh', ...
    'collapse', 1, 'byAttr', 0);

% Detection metrics (false positives etc) after initial detection over different thresholds
tests = struct('attributes', {{{'False Positives','False Negatives','True Positives', 'True Negatives'}}}, ...
    'attrRename', {{{'False Positives','False Negatives','True Positives', 'True Negatives'}}}, ...
    'folders', {{'strel-disk7 thresh-0.08', 'strel-disk7 thresh-0.10', 'strel-disk7 thresh-0.12'}}, ...
    'folderRename', {{'Threshold = 0.08', 'Threshold = 0.10', 'Threshold = 0.12'}}, ...
    'plotTitle', 'Detections per Video Over Various Thresholds', ...
    'yAxisLabel', 'Occurences Per Frame', ...
    'saveLocation', '../figures/DetectionVSThresh', ...
    'collapse', 1, 'byAttr', 0);


% Detection metrics (false positives etc) after final detection over different thresholds
tests(end+1) = struct('attributes', {{{'False Positives','False Negatives','True Positives', 'True Negatives'}}}, ...
    'attrRename', {{{'False Positives','False Negatives','True Positives', 'True Negatives'}}}, ...
    'folders', {{'strel-disk7 thresh-0.08', 'strel-disk7 thresh-0.10', 'strel-disk7 thresh-0.12'}}, ...
    'folderRename', {{'Threshold = 0.08', 'Threshold = 0.10', 'Threshold = 0.12'}}, ...
    'plotTitle', 'Detections per Video Over Various Thresholds', ...
    'yAxisLabel', 'Occurences Per Frame', ...
    'saveLocation', '../figures/DetectionVSThreshByAttr', ...
    'collapse', 1, 'byAttr', 1);

% Detection metrics (false positives etc) after initial detection over different videos
tests(end+1) = struct('attributes', {{{'False Positives','False Negatives','True Positives', 'True Negatives'}}}, ...
    'attrRename', {{{'False Positives','False Negatives','True Positives', 'True Negatives'}}}, ...
    'folders', {{'July 6 cam1 01 Test #1', 'July 8 cam1 02 Test #1', 'July 8 cam1 03 Test #1'}}, ...
    'folderRename', {{'Video #1', 'Video #2', 'video #3'}}, ...
    'plotTitle', 'Detections Over Different Videos', ...
    'yAxisLabel', 'Occurences Per Frame', ...
    'saveLocation', '../figures/DetectionVSVideo', ...
    'collapse', 1, 'byAttr', 0);

% Detection metrics (false positives etc) after initial detection over different videos
tests(end+1) = struct('attributes', {{{'False Positives','False Negatives','True Positives', 'True Negatives'}}}, ...
    'attrRename', {{{'FPeasy','False Negatives','True Positives', 'True Negatives'}}}, ...
    'folders', {{'July 6 cam1 01 Test #1', 'July 8 cam1 02 Test #1', 'July 8 cam1 03 Test #1'}}, ...
    'folderRename', {{'Video #1', 'Video #2', 'video #3'}}, ...
    'plotTitle', 'Detections Over Different Videos', ...
    'yAxisLabel', 'Occurences Per Frame', ...
    'saveLocation', '../figures/DetectionVSVideoByAttr', ...
    'collapse', 1, 'byAttr', 1);





% Detection distances (by frame) after initial detection over different videos
tests(end+1) = struct('attributes', {{{'First truth detection and detection','First truth detection and 4+ detection string','False Negatives'}}}, ...
    'attrRename', {{{'# frames before 1st detection','# frames before 1st detection string (4+)','False Negatives'}}}, ...
    'folders', {{'July 6 cam1 01 Test #1', 'July 8 cam1 02 Test #1', 'July 8 cam1 03 Test #1'}}, ...
    'folderRename', {{'Video #1', 'Video #2', 'video #3'}}, ...
    'plotTitle', 'First Detection Distance Over Different Videos', ...
    'yAxisLabel', '', ...
    'saveLocation', '../figures/FirstDetectionFrameVSVideo', ...
    'collapse', 1, 'byAttr', 0);

% Detection distances (by frame) after initial detection over different thresholds 
tests(end+1) = struct('attributes', {{{'First truth detection and detection','First truth detection and 4+ detection string','False Negatives'}}}, ...
    'attrRename', {{{'# frames before 1st detection','# frames before 1st detection string (4+)','False Negatives'}}}, ...
    'folders', {{'strel-disk7 thresh-0.08', 'strel-disk7 thresh-0.10', 'strel-disk7 thresh-0.12'}}, ...
    'folderRename', {{'Threshold = 0.08', 'Threshold = 0.10', 'Threshold = 0.12'}}, ...
    'plotTitle', 'First Detection Distance Over Different Thresholds', ...
    'yAxisLabel', 'Occurences Per Frame', ...
    'saveLocation', '../figures/FirstDetectionFrameVSThresh', ...
    'collapse', 1, 'byAttr', 0);


% Detection distances (by feet) after initial detection over different videos
tests(end+1) = struct('attributes', {{{'First truth detection (ft)','First detection (ft)','First 4+ detection string (ft)'}}}, ...
    'attrRename', {{{'Target Distance at First Possible Detection','Target Distance at First Detection','Target Distance at First Detection String (4+)'}}}, ...
    'folders', {{'July 6 cam1 01 Test #1', 'July 8 cam1 02 Test #1', 'July 8 cam1 03 Test #1'}}, ...
    'folderRename', {{'Video #1', 'Video #2', 'video #3'}}, ...
    'plotTitle', 'First Detection Distance Over Different Videos', ...
    'yAxisLabel', 'Distance (ft)', ...
    'saveLocation', '../figures/FirstDetectionDistanceVSVideo', ...
    'collapse', 1, 'byAttr', 0);

% Detection distances (by feet) after initial detection over different thresholds 
tests(end+1) = struct('attributes', {{{'First truth detection (ft)','First detection (ft)','First 4+ detection string (ft)'}}}, ...
    'attrRename', {{{'Target Distance at First Possible Detection','Target Distance at First Detection','Target Distance at First Detection String (4+)'}}}, ...
    'folders', {{'strel-disk7 thresh-0.08', 'strel-disk7 thresh-0.10', 'strel-disk7 thresh-0.12'}}, ...
    'folderRename', {{'Threshold = 0.08', 'Threshold = 0.10', 'Threshold = 0.12'}}, ...
    'plotTitle', 'First Detection Distance Over Different Thresholds', ...
    'yAxisLabel', 'Distance (ft)', ...
    'saveLocation', '../figures/FirstDetectionDistanceVSThresh', ...
    'collapse', 1, 'byAttr', 0);





for testIndex = 1:numel(tests)
    test = tests(testIndex);
    testaggregator(test.attributes, test.folders, test.folderRename, ...
        test.plotTitle, test.yAxisLabel, test.collapse, test.saveLocation, ...
        test.attrRename, test.byAttr)
end