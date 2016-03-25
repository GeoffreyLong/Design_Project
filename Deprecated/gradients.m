%Horizon idea
%   Towards the horizon there should be very few vertical edges (if any)
%   As the image plane goes to infinity you should theoretically see less
%   detail, so less sharpness right?
%   This wouldn't really work for mountains though


% Next up do an dx on the image matrix and a dy on the image matrix... 
% Also heatmap for the gradient matrix

filePath = 'testData/Feb_13_cam1_5.avi';
%filePath = 'testData/July_6_cam1_01.avi';
%filePath = 'testData/July_8_cam1_01.avi';
%filePath = 'testData/July_8_cam1_02.avi';
%filePath = 'testData/July_8_cam1_03.avi';
%filePath = 'testData/July_8_cam1_04.avi';
%filePath = 'testData/July_8_cam1_08.avi';
%filePath = 'testData/Oct_20_cam3_07.avi';

% Instantiate the video reader
v = VideoReader(filePath);
readRect = readrectxml(filePath);


% Get the number of frames, frame width, and frame height from the video data
nFrames = v.NumberOfFrames;

%[host, target] = getdetailedsrt(filePath, nFrames);
imPrev = read(v,1);
imPrev = im2double(imPrev);
for i = 2:nFrames
    imNew = read(v,i);
    imNew = im2double(imNew);

    %Authors: Stefan Karlsson and Josef Bigun, 2015
    %calculates the 3D gradient from two images.
    % filters predefined:
    dg =  [1     0    -1];
    gg = [0.2163,   0.5674,   0.2163]; %normalized to sum 1

    %% Approach 1,
    % most straightforward,:what is asked for in the tutorial. Notice that we
    % have a multiplication with 2 for the dt component. We could equally well
    % have divided dx and dy with 2. The distance between 2 frames is 1, while
    % the distance in the spatial derivative mask ([1 0 -1]) is 2.
    % dx    = conv2(gg,dg,imNew,'same'); %L1
    % dy    = conv2(dg,gg,imNew,'same'); %L2
    % dt    = 2*(imNew - imPrev);        %L3

    %% Approach 2,
    % First approach corresponds to assymetrically placed 3D kernels. In related 
    % terminology, we do not use a proper 3D stencil for our differentiation.
    % For correctly centered kernels in the spatio-temporal volume with
    % kernel/stencil of size 3x3x2:
    %  dx  =   conv2(gg,dg,imNew + imPrev,'same'); 
    %  dy  =   conv2(dg,gg,imNew + imPrev,'same'); 
    %  dt  = 2*conv2(gg,gg,imNew - imPrev,'same'); 


    %%Approach 3
    % Earlier approaches suffer from edge effects when close to the x-y boundary
    % of the video. For the dx component, problems occur on the right and the left
    % boundary. We can solve this by switching to single-sided differences,
    % leftward or rightward for the dx derivative depending if we are on 
    % the left or right boundary. For the dy compenent, we do the analogous upward/downward
    % difference for top and bottom boundaries. This can be done with Matlab
    % indexation. Approach 3 is numerically identical to Approach 2 in the
    % interior of the image(3x3x2), but on the boundary we use kernels/stencils
    % that are of size 3x2x2(top/bottom) and 2x3x2(lef/right). 
    f = imNew + imPrev;
    dx = f(:,[  2:end end ]  ) - f(:,[1 1:(end-1) ]  ) ;
    dx = conv2(dx,gg','same');

    dy = f(  [  2:end end ],:) - f(  [1 1:(end-1) ],:);
    dy = conv2(dy,gg ,'same');

    dt = 2*conv2(gg,gg,imNew - imPrev,'same'); 
    
    
    imshow(dt);
    
    imPrev = imNew;
end


