function [ outputVector ] = tracking(rect, host, target)
%   tracking function should take in a detection and perform
%   operations on it, and output results to a seperate file for 
%   further analysis

    x = rect(1)+0.5*rect(3);
    y = rect(2)+0.5*rect(4);
    
    midpoint = [x y];
    
%     now write to external file



end

