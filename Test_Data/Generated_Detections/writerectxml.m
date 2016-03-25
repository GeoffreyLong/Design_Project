function [ isSuccess ] = writerectxml( videoPath, rect, addString )
%readrectxml: Will write the new array for a given video
%   rect: A nx5 matrix where 
%       n is the number of detections
%       Each row is the frame number with the 4 dimensional rectangle selection
%   videoPath: The location of the video in the system
%   addString: Optional string at the end of path to avoid overwrite (mostly for postprocessing)
%   isSuccess: Return boolean saying success or failure

isSuccess = true;

% Split the filepath so that it does not contain ".mp4"
% videoPathTokens = strsplit(videoPath,'.');
videoPathTokens = strread(videoPath,'%s','delimiter','/');
filePath = videoPathTokens(length(videoPathTokens));
if nargin < 3
    addString = '';
end
fileName = strcat('testData/Generated_Detections/',addString,char(filePath));
fileName = strcat(fileName, '.dat')


try
    disp(fileName);
    csvwrite(fileName, rect);
catch
    % If error on write then isSuccess is false
    isSuccess = false;
    disp('failure')
end

end

