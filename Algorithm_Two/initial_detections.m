function [ detections ] = initial_detections( image, host, height, width )
%INITIAL_DETECTIONS Summary of this function goes here
%   This function will pull out the detections apart from the tracking info.
%   This will be a quick way of getting detections. We only want to return
%   a few detections, few enough that it works with the CNN (near real time)

%   This will initially bound the image by the plane location model.
%   It will only perform a CMO in a region that fits the vertical gaussian.
%   This means one or two standard deviations above and below the horizon estimation.
%   Then it will perform a CMO in this region.
%   The CMOs returned will be further vetted by ???

    %TODO get the optimal for these
    % nHood can be found through the exp_cmos
    % high/low thresh from the static CMO response model
%    nHood = ?;
%    highThresh = ?;
%    lowThresh = ?

    % PDF_Y from Static_Plane_Location_Model
    mu = 68.0164;
    sigma = 16.2477;


    detections = [];
    
        % Rotate the image
    img = imrotate(img, -curHost(3), 'crop');

    % Horizon estimation
    horizonY = rotated_horizon_detection(host, height);
    
	% This should capture 99.7 percent of the data
    midpoint = horizonY - mu;
    upper = midpoint - 3*sigma;
    %lower = midpoint + 3*sigma;
    
    image = imcrop(image, [0 upper width abs(upper-horizonY)]);
    
    % Perform a CMO
    open = imopen(image,nHood);
    close = imclose(image,nHood); 
    im = close - open;
    
    % binarize the image 
    bw = im2bw(im, thresh);
    L = bwlabel(bw);
    s = regionprops(L);

end

