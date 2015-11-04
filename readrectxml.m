function [ rect ] = readrectxml( videoPath )
%readrectxml: Will read a previously saved rectangles array for a given video
%   rect: A nx5 matrix where 
%       n is the number of detections
%       Each row is the frame number with the 4 dimensional rectangle selection
%   videoPath: The location of the video in the system

% This function will read in a videoPath and will return a rectangle array
%   The rectangle corresponds to previously saved values for the video
%   Please note that the name of the video path should be kept consistent
%       If it is not kept consisitent then we can run into data issues

% Split the filepath so that it does not contain ".mp4"
videoPathTokens = strsplit(videoPath,'.');
filePath = videoPathTokens(1);
fileName = char(filePath);
fileName = strcat(fileName, '.dat');

try
    rect = csvread(fileName);
catch
    printString = sprintf('No file found by name "%s"', fileName);
    display(printString)
    rect = zeros(1,4);
end
    
end