function [ output_args ] = finddifficulthorizons( input_args )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%filePath = 'testData/Feb_13_cam1_5.avi';
%filePath = 'testData/July_6_cam1_01.avi';
%filePath = 'testData/July_8_cam1_01.avi';
filePath = 'testData/July_8_cam1_02.avi';
%filePath = 'testData/July_8_cam1_03.avi';
%filePath = 'testData/July_8_cam1_04.avi';
%filePath = 'testData/July_8_cam1_08.avi';
%filePath = 'testData/Oct_20_cam3_07.avi';

% This saves the horizon images that deviate from the windowed mean
% It should save all the horizons that are hard to deal with
movingAvg = 0;
for i = 1:nFrames
    image = read(v,i);
    [sky, terrain] = segmentsky8(image);
    
    localSum = sum(sum(terrain));
    
    if (sum(movingAvg) == 0)
        movingAvg = [localSum localSum localSum localSum localSum];
    end
    
    movingAvg(1:end) = [movingAvg(2:end) localSum];
    avged = mean(movingAvg);    
    if localSum < (avged - avged/5) || localSum > (avged + avged/5)
        localstr = sprintf('Horizon_Feb13_cam1_5_Frame%d', i);
        writeString = strcat(localstr, '.png')
        imwrite(image, writeString);
        
        image = read(v,i-1);
        localstr = sprintf('Horizon_Feb13_cam1_5_Frame%d', i-1);
        writeString = strcat(localstr, '.png')
        imwrite(image, writeString);
    end
end



end

