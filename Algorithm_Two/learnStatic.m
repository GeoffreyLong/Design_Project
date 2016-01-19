% The goal of this is to "learn" the static data from the "truth" images

VISUALIZE = 0;

imagefiles = dir('/home/geoffrey/Dropbox/Temps/Design_Project/testData/Generated_Detections/truth_images/*.png');
nFrames = length(imagefiles)    % Number of files found

% Type of neighborhood for CMO
%TODO May want to experiment with other nhoods (esp diff sizes)
%TOLEARN Which se gets best response
nHood = strel('disk',4);
nHoodDilate = ones(3);

importantVectors = zeros(nFrames, 3);

for i = 1:nFrames
    %image = read(v,i);
    curFilename = imagefiles(i).name;
    image = imread(curFilename);
    
    
    image = im2double(image);
    %%%%% Get static props %%%%%
    % - Response strength (absolute)
    % - Response strength WRT local neighborhood
    % - Eccentricity of Response
    % - Orientation of Response
    % - (Possibly) location of response WRT horizon
    
    
    % Perform a CMO or Sobel 
    open = imopen(image,nHood);
    close = imclose(image,nHood); 
    im = close - open;

    thresh = 256/256;
    bw = im2bw(im, thresh);
    L = bwlabel(bw);
    s = regionprops(L,'BoundingBox', 'Centroid');
    
    while (numel(s) <= 0 && thresh >= 0)
        bw = im2bw(im, thresh);
        bw = imdilate(bw, nHoodDilate);
        L = bwlabel(bw);
        s = regionprops(L,'BoundingBox', 'Centroid');
        
        for j=1:numel(s)
            centroid = round(s(j).Centroid);
            newBound = s(j).BoundingBox;
        end
        thresh = thresh - 1/256;
    end 

    % The first threshold where the plane appears
    highThresh = thresh;
    
    if (VISUALIZE == 1)
        imshow(bw);    
        pause(1);
    end
        
    while (numel(s) <= 1 && thresh >= 0)
        bw = im2bw(im, thresh);
        bw = imdilate(bw, nHoodDilate);
        L = bwlabel(bw);
        s = regionprops(L,'BoundingBox', 'Centroid');
        
        for j=1:numel(s)
            centroid = round(s(j).Centroid);
            newBound = s(j).BoundingBox;
        end
        thresh = thresh - 1/256;
    end
    
    % The first threshold where a non-plane appears
    lowThresh = thresh;
    [counts,binLocations] = imhist(im);
    
    % The mean of all possible thresholds
    histMean = sum(counts .* binLocations) / sum(counts);
    if (VISUALIZE == 1)
        imshow(bw);    
        pause(1);
    end

    importantVectors(i,:) = [highThresh lowThresh histMean]
end

%TODO might be able to run some sort of SVM on this data
importantVectors
