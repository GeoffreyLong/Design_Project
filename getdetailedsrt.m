function [ host, target ] = getdetailedsrt( filePath, nFrames )
%getdetailedsrt: Extracts the information from the SRT files
%   host: All of the own-ship information
%       [Frame Number, Altitude (feet), Pitch (degrees), Roll (degrees), Heading]
%   target: All of the intruder information
%       [Frame Number, Azimuth (degrees), Elevation (degrees), Distance (feet)]

videoPathTokens = strread(filePath,'%s','delimiter','/');
filePath = videoPathTokens(length(videoPathTokens));
fileName = char(filePath);
fileName = strsplit(fileName, '.');
fileName = strcat('testData/Detailed_SRTs/', fileName{1}, '.srt');

fileID = fopen(fileName);
host = zeros(nFrames, 5);
target = zeros(nFrames, 4);
line = fgetl(fileID);
frameNo = 0;
while(ischar(line))
    tokens = strsplit(line, {' ',':','->'}, 'CollapseDelimiters', true);
    if (size(tokens) == 1)
        frameNo = str2num(strjoin(tokens));
        if (frameNo)
            host(frameNo,1) = frameNo;
            target(frameNo,1) = frameNo;
        end
    elseif (strcmp(tokens{1}, 'Host'))
        if (strcmp(tokens{2}, 'Altitude'))
            host(frameNo,2) = (str2num(tokens{4}) + str2num(tokens{8})) / 2.0;            
        elseif (strcmp(tokens{2}, 'Pitch'))
            host(frameNo,3) = str2num(tokens{3});
            host(frameNo,4) = str2num(tokens{6});
            host(frameNo,5) = str2num(tokens{9});
        end
    elseif (strcmp(tokens{1}, 'Target'))
        target(frameNo,2) = str2num(tokens{3});
        target(frameNo,3) = str2num(tokens{6});
        target(frameNo,4) = str2num(tokens{9});
    end
    line = fgetl(fileID);
end
fclose(fileID);

end

