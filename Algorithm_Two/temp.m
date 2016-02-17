%filePath = 'testData/Feb_13_cam1_5.avi';
%filePath = 'testData/July_6_cam1_01.avi';
%filePath = 'testData/July_8_cam1_01.avi';
%filePath = 'testData/July_8_cam1_02.avi';
filePath = 'testData/July_8_cam1_03.avi';
%filePath = 'testData/July_8_cam1_04.avi';
%filePath = 'testData/July_8_cam1_08.avi';
%filePath = 'testData/Oct_20_cam3_07.avi';


% Instantiate the video reader
v = VideoReader(filePath);

% Get the number of frames, frame width, and frame height from the video data
nFrames = v.NumberOfFrames;
height = v.Height;
width = v.Width;

readRect = readrectxml(filePath, 'postProcess_');
%[host, target] = getdetailedsrt(filePath, nFrames);


%imagefiles = dir('/home/geoffrey/Dropbox/Temps/Design_Project/testData/Generated_Detections/truth_images/*.png');
%nFrames = length(imagefiles)    % Number of files found

% Type of neighborhood for CMO
%TODO May want to experiment with other nhoods (esp diff sizes)
%TOLEARN Which se gets best response
se = strel('disk',4);

%curFilename = imagefiles(1).name;
%prevImage = imread(curFilename);    
%prevImage = im2double(image);
prevImage = read(v,1);
open = imopen(prevImage,se);
close = imclose(prevImage,se); 
prevIm = close - open;


for i = 3000:nFrames
    image = read(v,i);
    %curFilename = imagefiles(i).name;
    %image = imread(curFilename);    
    %image = im2double(image);
    
    % Perform a CMO or Sobel 
    open = imopen(image,se);
    close = imclose(image,se); 
    im = close - open;

    thresh = graythresh(im);
    thresh = 0.06;
    bw = im2bw(im, thresh);
    L = bwlabel(bw);
    s = regionprops(L,'BoundingBox', 'Centroid');

    for j=1:numel(s)
        centroid = round(s(j).Centroid);
        newBound = s(j).BoundingBox;
    end

    curRect = readRect(readRect(:,1) == i,2:5)
    bw = im2double(bw);
    bw = insertShape(bw, 'Rectangle', curRect, 'LineWidth', 5, 'color', 'blue');
    imshow(bw)
    
    
    pause(1);
    
    %%%%% Get dynamic props %%%%% 
    %%%%% (How the response changes over time (changes to the static vector)) %%%%%
    % - Anything else
    
    prevImage = image;
    prevIm = im;
end