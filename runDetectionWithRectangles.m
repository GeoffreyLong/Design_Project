 filePath = '/home/geoffrey/Dropbox/Temps/Design_Project/Feb_13_cam1_5.avi';
% filePath = '/home/geoffrey/Dropbox/Temps/Design_Project/July_6_cam1_01.avi';

vwr = VideoWriter('Detect__Feb_13_cam1_5.avi');
open(vwr);


% Instantiate the video reader
v = VideoReader(filePath);

readRect = readrectxml(filePath);

% Get the number of frames, frame width, and frame height from the video data
nFrames = v.NumberOfFrames;



for i = 600:nFrames 
    image = read(v,i);
    
    % This is changeable, switch out detection algorithms as needed
    detectRect = detect2(image);
    
    % If you want a fresh image every iteration leave uncommented
    % Commenting this is rather interesting from an analysis standpoint though
    im = image;
    
    for j=1:size(detectRect,1)
        im = insertShape(im, 'Rectangle', detectRect(j,:), 'LineWidth', 5, 'color', 'blue');
    end
    
    curRect = readRect(readRect(:,1)==i,:);
    %TODO make extensible to multi rect situations
    for j=1:size(curRect,1)
        im = insertShape(im, 'Rectangle', curRect(j,2:5), 'LineWidth', 5);
    end
    i
    writeVideo(vwr,im);
end

close(vwr);