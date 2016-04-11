function [ detections ] = initial_detections( origImg, host, height, width, nHood, thresh )
%INITIAL_DETECTIONS Summary of this function goes here
%   This function will pull out the detections apart from the tracking info.
%   This will be a quick way of getting detections. We only want to return
%   a few detections, few enough that it works with the CNN (near real time)

%   This will initially bound the image by the plane location model.
%   It will only perform a CMO in a region that fits the vertical gaussian.
%   This means one or two standard deviations above and below the horizon estimation.
%   Then it will perform a CMO in this region.
%   The CMOs returned will be further vetted by ???

%TODO make this more sophisticated
% This works, but it could be better
% We shouldn't use this "bang bang" style of filtering, should attach the probabilities
% This is a good initial iteration though

% sigma = 1 -> 0.68
% sigma = 2 -> 0.95
% sigma = 3 -> 0.997

    %TODO get the optimal for these
    % nHood can be found through the exp_cmos
    % high/low thresh from the static CMO response model
    %nHood = strel('disk', 7);
    %highThreshMU = 0.163;
    %highThreshSigma = 0.112;
    lowThreshMU = 0.116;
    %lowThreshSigma = 0.111;

    if nargin < 6
        thresh = lowThreshMU;
    end
    if nargin < 5
        nHood = strel('disk',7);
    end
    
    
    % PDF_Y from Static_Plane_Location_Model
    % TODO recheck on rotated image
    mu = 68.0164;
    sigma = 16.2477;
    
    % Rotate the image
    rotatedImage = imrotate(origImg, -host(4), 'crop');

    % Horizon estimation
    horizonY = rotated_horizon_detection(host, height);
    
	% This should capture 99.7 percent of the data
    midpoint = horizonY - mu;
    upper = midpoint - 3*sigma;
    %lower = midpoint + 3*sigma;
    
    image = imcrop(rotatedImage, [0 upper width abs(upper-horizonY)]);
    
    % Perform a CMO
    open = imopen(image,nHood);
    close = imclose(image,nHood); 
    im = close - open;
    
    % binarize the image 
    % TODO recheck the thresholds on this image subset
    bw = im2bw(im, thresh);
    bw = imdilate(bw, ones(3,3));
    L = bwlabel(bw);
    
    s = regionprops(L, 'BoundingBox', 'Centroid');
    detections = [];
    for j=1:numel(s)
        % If the bounding box has an edge within 2 pixels of the frame x axis
        % Then we expect the size of the box to be larger than 20 pixels
        % Due to the nature of headon approaches
        % Note: not sure if this is a better approach to filtering the side
        % noise than the previous iteration
        % Could alternatively do a count of number of 0 valued elements in
        % the detection box, if the count is higher than a threshold then
        % remove it.
        bound = ceil(s(j).BoundingBox);
        if (~(bound(1) <= 2 && bound(3) < 20) ...
            && ~(abs(bound(1)+bound(3) - width) <= 2 && bound(3) < 20))
            bound(2) = bound(2) + upper;
            detections = [detections; bound];
            %image = insertShape(image, 'rectangle', s(j).BoundingBox);
        end
    end
    %imshow(image);
end