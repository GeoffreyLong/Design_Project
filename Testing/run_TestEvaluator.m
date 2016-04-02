% This script runs the tests for a given testing instance or instances
% Want to pass a folder to the test evaluator function
folderName = '20160402T191901';


testFileBase = strcat('../Testing/Test_Instances/',folderName,'/');
files = dir(testFileBase);

for i=1:numel(files)
    fileName = files(i).name
    [component, video] = strtok(fileName, '_');
    video = video(2:end);
    
    if strcmp(component,'detection')
        
    elseif strcmp(component,'tracking')
        
    end
end
