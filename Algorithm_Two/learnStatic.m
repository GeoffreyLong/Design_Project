% The goal of this is to "learn" the static data from the "truth" images
% The data to learn is as follows (for each "truth" image)
%   highThresh: The maximum CMO response value which corresponds to a plane
%       Any higher and the plane will no longer be picked up
%   lowThresh: The CMO response where non-planes begin to appear
%       1/256 higher than this value is the last threshold for which only
%       the plane appears
%   meanHist: The mean value of the response within the frame
%   eccentricity / avgEccentricity: The eccentricity of the component
%   orientation / avgOrientation: The orientation of the component
%   solidity / avgSolidity: The covex hull area divided by the area of the component

%TODO other metrics to add in?

% Shows the bw images
VISUALIZE = 0;

imagefiles = dir('/home/geoffrey/Dropbox/Temps/Design_Project/testData/Generated_Detections/truth_images/*.png');
nFrames = length(imagefiles)    % Number of files found

% Type of neighborhood for CMO
%TODO May want to experiment with other nhoods (esp diff sizes)
%TOLEARN Which nHood gets best response
nHood = strel('disk',4);
nHoodDilate = ones(3);

% Initialize the matrix
importantVectors = zeros(nFrames, 9);

for i = 1:nFrames
    % Read in the image
    curFilename = imagefiles(i).name;
    image = imread(curFilename);    
    image = im2double(image);
    
    % Perform a CMO
    open = imopen(image,nHood);
    close = imclose(image,nHood); 
    im = close - open;

    % Seed the initial threshold evaluation
    thresh = 256/256;
    bw = im2bw(im, thresh);
    L = bwlabel(bw);
    s = regionprops(L);
    
    while (numel(s) <= 0 && thresh >= 0)
        % Threshold evaluation with new threshold
        bw = im2bw(im, thresh);
        bw = imdilate(bw, nHoodDilate);
        L = bwlabel(bw);
        s = regionprops(L,'BoundingBox', 'Centroid');
        
        for j=1:numel(s)
            %TODO should probably check the centroid to ensure that the
            % value is towards the center
            centroid = round(s(j).Centroid);
            newBound = s(j).BoundingBox;
        end
        
        % Reduce the threshold
        thresh = thresh - 1/256;
    end 

    % The first threshold where the plane appears
    highThresh = thresh;
    
    if (VISUALIZE == 1)
        imshow(bw);    
        pause(1);
    end
        
    while (numel(s) <= 1 && thresh >= 0)
        % Threshold evaluation with new threshold
        bw = im2bw(im, thresh);
        bw = imdilate(bw, nHoodDilate);
        L = bwlabel(bw);
        s = regionprops(L);

        % Reduce the threshold
        thresh = thresh - 1/256;
    end
    
    % The first threshold where a non-plane appears
    % Could potentially reset this to an actual low thresh by lowThresh = thresh + 1/256;
    lowThresh = thresh;
    [counts,binLocations] = imhist(im);
    
    % The mean of all possible thresholds
    histMean = sum(counts .* binLocations) / sum(counts);
    if (VISUALIZE == 1)
        imshow(bw);    
        pause(1);
    end

    % Get some regionprops of the averaged threshold count
    avgThresh = (highThresh + lowThresh) / 2;
    bw = im2bw(im, avgThresh);
    bw = imdilate(bw, nHoodDilate);
    L = bwlabel(bw);
    s = regionprops(L, 'Eccentricity', 'Orientation', 'Solidity');
    avgEccentricty = s(1).Eccentricity;
    avgOrientation = s(1).Orientation;
    avgSolidity = s(1).Solidity;
    
    % Get some regionprops of the low threshold count
    thresh = highThresh + 1/256;
    bw = im2bw(im, thresh);
    bw = imdilate(bw, nHoodDilate);
    L = bwlabel(bw);
    s = regionprops(L, 'Eccentricity', 'Orientation', 'Solidity');
    eccentricty = s(1).Eccentricity;
    orientation = s(1).Orientation;
    solidity = s(1).Solidity;
    
    
    % Are eccentricity, orientation, solidity measures desired?
    % Solidity seems pretty solid, the other two might be too finnicky
    importantVectors(i,:) = [highThresh lowThresh histMean ...
        eccentricty avgEccentricty orientation avgOrientation ...
        solidity avgSolidity];
end

%TODO might be able to run some sort of SVM on this data
importantVectors