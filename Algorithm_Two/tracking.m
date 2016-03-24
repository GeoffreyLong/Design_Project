function [ posTrack, sizeTrack  ] = tracking(rect, host, target)
%   tracking function should take in a detection and perform
%   operations on it, and output results to a seperate file for 
%   further analysis

    x = rect(1)+0.5*rect(3);
    y = rect(2)+0.5*rect(4);
    area = rect(3)*rect(4);
    
    midPoint = [x y];
%     trackingStatement = 'Midpoint is [%f, %f]\n';
%     fprintf(trackingStatement,rect);
    
    % GROUND TRUTH DATA
    hostData = 'Host: Heading = %f\n';
    fprintf(hostData, host(5));
    
    targetData = 'Target: Azimuth = %f, Distance = %f\n';
    fprintf(targetData, target(2), target(4));
    % GROUND TRUTH DATA END
    
    fprintf('________________\n');
    
   
        
   
    %return midpoint and area
    posTrack = midPoint;  
    sizeTrack = area;


end

