function [ output_args ] = run_detector(net)
%RUN_DETECTOR Summary of this function goes here
%   Detailed explanation goes here

% vl_simplenn_display(net, 'inputSize', [224 224 2 265])

imSize = [224 224];

filePath = '/home/geoffrey/Dropbox/Temps/Design_Project/testData/July_8_cam1_02.avi'

% Instantiate the video reader
v = VideoReader(filePath);
readRect = readrectxml(filePath);

% Get the number of frames, frame width, and frame height from the video data
nFrames = v.NumberOfFrames;
se = strel('disk',5);

WRITE = true;
if (WRITE)
    vwr = VideoWriter('Detect_July_8_cam1_02_1.avi');
    open(vwr);
end

i = 1;

result = zeros(1,2);
for i=1:nFrames
    % load and preprocess an image
    origIm = read(v,i);
    
    
    openIm = imopen(origIm,se);
    closeIm = imclose(origIm,se); 
    im = closeIm - openIm;
    im = imdilate(im,se);

    bw = im2bw(im, 0.08);
    L = bwlabel(bw);
    
    % There are a lot of cool regionprops that could be useful
    % Particularly userprops
    s = regionprops(L,'BoundingBox', 'Centroid');

    
    bound = [0 0 0 0];
    largestObjSize = 0;
    for j=1:numel(s)
        centroid = round(s(j).Centroid);
        newBound = s(j).BoundingBox;
        upperDim = ceil(max(newBound(3),newBound(4)));
        
        % TODO these bounds are likely too loose
        if upperDim > largestObjSize
            bound(1) = centroid(1) - ceil(1.5*upperDim);
            bound(2) = centroid(2) - ceil(1.5*upperDim);
            bound(3) = 3*upperDim;
            bound(4) = 3*upperDim;
            largestObjSize = upperDim;
        end
        
        im_ = imcrop(im, bound);
        im_ = single(im) ; % note: 0-255 range
        im_ = imresize(im_, imSize);

        if size(im_,3) == 1 % Grayscale image
            im_ = cat(3, im_, im_, im_) ;
        end
        
        im_ = imresize(im_, net.meta.normalization.imageSize(1:2)) ; 
        im_ = im_ - net.meta.normalization.averageImage ;

        % run the CNN
        res = vl_simplenn(net, im_) ;

        % Get the output for the i-th layer, each model has one avg image value
        % res(i).x

        % show the classification result
        scores = squeeze(gather(res(end).x)) ;
        [bestScore, best] = max(scores) ;

        if (best == 1)
            if (bestScore >= 0.5 && bestScore < 0.6)
                origIm = insertShape(origIm, 'Rectangle', bound, 'LineWidth', 5, 'color', 'red');
            end
            if (bestScore >= 0.6 && bestScore < 0.7)
                origIm = insertShape(origIm, 'Rectangle', bound, 'LineWidth', 5, 'color', 'yellow');
            end
            if (bestScore >= 0.7 && bestScore < 0.8)
                origIm = insertShape(origIm, 'Rectangle', bound, 'LineWidth', 5, 'color', 'green');
            end
            if (bestScore >= 0.8)
                origIm = insertShape(origIm, 'Rectangle', bound, 'LineWidth', 5, 'color', 'blue');
            end
        end
    end
    
    imshow(origIm)
    if WRITE
        writeVideo(vwr,origIm);
        i = i + 1
    end

end

if WRITE
    close(vwr);
end