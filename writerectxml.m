function [ isSuccess ] = writerectxml( filePath, rect )
%readrectxml: Will write the new array for a given video
%   rect: A nx4 matrix where 
%       n is the number of frames
%       Each row is the rectangle selection
%   videoPath: The location of the video in the system
%   isSuccess: Return boolean saying success or failure

isSuccess = TRUE;

% Split the filepath so that it does not contain ".mp4"
videoPathTokens = strsplit(videoPath,'.');
filePath = videoPathTokens(1);
fileName = char(filePath);
fileName = strcat(fileName, '.dat');

try
    csvwrite(fileName, rect);
catch
    % If error on write then isSuccess is false
    isSuccess = FALSE;
end

end

