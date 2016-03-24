function [ output_args ] = focused_detections( image, bound )
%FOCUSED_DETECTIONS Summary of this function goes here
%   Will accept the most recent track as input
%   Will double the size of the window, skew the window by the pose change,
%   then will search for detections within this new window.
%   The CMO performed on this window should be rather low threshold
%   We want to be sure to grab the detection, should one exist in the new window


    % Double the size of the detection window
    % I feel like there should be an easier way of doing this
    newBound(1) = bound(1) - bound(3) / 2;
    if (newBound(1) < 1) 
        newBound(1) = 1;
    end
    newBound(2) = bound(2) - bound(4) / 2;
    if (newBound(2) < 1) 
        newBound(2) = 1;
    end
    newBound(3) = 2*bound(3);
    if (newBound(1) + newBound(3) > width)
        newBound(3) = width - newBound(1);
    end
    newBound(4) = 2*bound(4);
    if (newBound(1) + newBound(4) > height)
        newBound(4) = height - newBound(4);
    end
    croppedImage = imcrop(image, newBound)


end

