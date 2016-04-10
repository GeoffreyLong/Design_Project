function [ output_args ] = initial_detections( input_args )
%INITIAL_DETECTIONS Seed the initial detections 
%   This will give an initial output of possible plane spots 
%   Important to pare the number of results down drastically


% Gaussian for both x and y axis based on the estimated horizon
% Could also learn this I guess... The most accurate correlation will be
% vertical, horizontal will be far less valuable. 
%   Easiest way would just be to map the
%       pixel location to a spot on the gaussian. This should take the IMU into
%       consideration.
%   Other way would be to gather the detection locations
%       Pair these with the IMU data
%       Then train it somehow


% Metrics to draw upon
%   CMO 
%       What neighborhood, what threshold?
%   




end

