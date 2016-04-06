function [ detections ] = initial_detections( origImage, host, height, width )
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
    nHood = strel('disk', 7);
    highThreshMU = 0.163;
    highThreshSigma = 0.112;
    lowThreshMU = 0.116;
    lowThreshSigma = 0.111;

    % PDF_Y from Static_Plane_Location_Model
    % TODO recheck on rotated image
    mu = 68.0164;
    sigma = 16.2477;

    % Horizon estimation
    horizonY = rotated_horizon_detection(host, height);
    
	% This should capture 99.7 percent of the data
    midpoint = horizonY - mu;
    upper = midpoint - 3*sigma;
    %lower = midpoint + 3*sigma;
    
    image = imcrop(origImage, [0 upper width 1.25*abs(upper-horizonY)]);
    
    % Perform a CMO
    open = imopen(image,nHood);
    close = imclose(image,nHood); 
    im = close - open;
    
    % binarize the image 
    % TODO recheck the thresholds on this image subset
    bw = im2bw(im, lowThreshMU);
    bw = imdilate(bw, ones(3,3));
    L = bwlabel(bw);
    
    s = regionprops(L, 'BoundingBox', 'Centroid');
    detections = [];
    for j=1:numel(s)
        xCenter = ceil(s(j).Centroid(1));
        yCenter = ceil(s(j).Centroid(2));
        
        if (xCenter ~= 1)
            xCenter = xCenter - 1;
        end
        
        if (yCenter ~= 1)
            yCenter = yCenter - 1;
        end

        if (origImage(yCenter, xCenter) ~= 0 && s(j).BoundingBox(3) * s(j).BoundingBox(4) ~= 0)
            bound = s(j).BoundingBox;
            bound(2) = bound(2) + upper;
            detections = [detections; bound];
            %image = insertShape(image, 'rectangle', s(j).BoundingBox);
        end
    end
    %imshow(image);
end