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

%readRect = readrectxml(filePath);
%[host, target] = getdetailedsrt(filePath, nFrames);


% Type of neighborhood for CMO
%TODO May want to experiment with other nhoods (esp diff sizes)
%TOLEARN Which se gets best response
se = strel('disk',4);

for i = 3000:nFrames
    image = read(v,i);

    %%%%% Get static props %%%%%
    % - Response strength (absolute)
    % - Response strength WRT local neighborhood
    % - Eccentricity of Response
    % - Orientation of Response
    % - (Possibly) location of response WRT horizon
    
    
    % Perform a CMO or Sobel 
    open = imopen(image,se);
    close = imclose(image,se); 
    im = close - open;

    
    bw = im2bw(im, 0.1);
    L = bwlabel(bw);
    s = regionprops(L,'BoundingBox');

    imshow(bw)
    
    %%%%% Get dynamic props %%%%% 
    %%%%% (How the response changes over time (changes to the static vector)) %%%%%
    % - Anything else
    
    
end