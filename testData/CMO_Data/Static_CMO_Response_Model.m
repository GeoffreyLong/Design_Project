% This will fit a gaussian to the high and low thresholds of the CMO
% response. This metric is taken from the previously bounded detections.
%   Thresholds: The high and low threshold correspond to im2bw thresholds
%       If a threshold is X, then any value above X will be white, any
%       value below X will be black. Clearly, we want the object to show
%       while the background remains black. If the threshold X is too low,
%       then other objects will clutter the scene, if the threshold X is
%       too high, then the plane cannot be detected.
%   The low threshold is the binarization threshold at which other
%       detections become visible in the cropped detection image. 
%       This threshold shows the threshold at which the scene is likely to
%       be cluttered by false positives.
%   The high threshold is the binarization threshold at which the detection
%       first becomes visible in the binarization. This threshold shows the 
%       likely threshold at which we are able to pull a detection from the background.
%       This threshold actually roughly corresponds to the response strength
%   The high threshold is more important for modelling the probability that
%   a detection is a plane given the response strength. The low threshold
%   is important for the purposes of binarization (since we want to
%   binarize with a threshold as close to this as possible to ensure we
%   capture the detection while reducing the number of false positives.


imagefiles = dir('/home/geoffrey/Dropbox/Temps/Design_Project/testData/Generated_Detections/truth_images/*.png');
nFrames = length(imagefiles)    % Number of files found


% Type of neighborhood for CMO
%TODO May want to experiment with other nhoods (esp diff sizes)
%TOLEARN Which nHood gets best response
nHoods = [strel('disk', 3), strel('diamond', 3), ...
    strel('disk', 5), strel('diamond', 5), ...
    strel('disk', 7), strel('diamond', 7), ...
    strel('disk', 10), strel('diamond', 10), ...
    strel('disk', 15), strel('diamond', 15)];
nHoodNames = {'disk3','diamond3','disk5','diamond5' ...
    'disk7','diamond7','disk10','diamond10','disk15','diamond15'};
nHoodDilate = ones(3);

gaussFileID = fopen('CMO_response/gaussians.txt','w');
fprintf(gaussFileID, 'nHoodName Hmu Hsigma Lmu Lsigma \n');
gaussSpec = '%s %f %f %f %f \n';

lowThreshes = [];
highThreshes = [];


for k = 1:size(nHoods,2)
    nHoodName = nHoodNames{k}
    newFileName = strcat('CMO_response/', nHoodName, '.txt')
    rawFileID = fopen(newFileName,'w');
    fprintf(rawFileID, 'LowThresh HighThresh');

    formatspec = '%f %f \n';

    nHood = nHoods(k);


    for i = 1:nFrames
        i
        
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
        
        lowThreshes = [lowThreshes; lowThresh];
        highThreshes = [highThreshes; highThresh];
        
        fprintf(rawFileID, formatspec, lowThresh, highThresh);

    end

    % Fit a pdf to the data
    pdfLow = fitdist(lowThreshes, 'Normal')
    pdfHigh = fitdist(highThreshes, 'Normal')

    hold off;
    % PLOT the PDF of Y
    low_values = 0:0.01:0.5;
    y = pdf(pdfLow,low_values);
    plot(low_values,y,'LineWidth',2)

    hold on;
    % PLOT the PDF of X
    high_values = 0:0.01:0.5;
    x = pdf(pdfHigh,high_values);
    plot(high_values,x,'LineWidth',2)

    plotFileName = strcat('CMO_response/', nHoodName, '.png')
    saveas(gcf, plotFileName)
   
    fprintf(gaussFileID, gaussSpec, nHoodName, pdfHigh.mu, pdfHigh.sigma, pdfLow.mu, pdfLow.sigma);
    
    fclose(rawFileID);    
end

fclose(gaussFileID);