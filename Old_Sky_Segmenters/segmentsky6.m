function [ skyFrames, terrainFrames ] = segmentsky6( videoPath )
%segmentsky6: Based on edge detection techniques
% Other than Roberts and Canny filtering, all the techniques do a rather
% good job of segmenting

% Instantiate the video reader
v = VideoReader(videoPath);

% Get the number of frames, frame width, and frame height from the video data
nFrames = v.NumberOfFrames;

for i = 1:25:nFrames 
    image = read(v,i);  
    
    BW1 = edge(image,'Canny');
    BW2 = edge(image,'Prewitt');
    BW3 = edge(image,'log');
    BW4 = edge(image,'Roberts');
    BW5 = edge(image,'Sobel');
    BW6 = edge(image,'zerocross');
    
    
     % Smooth by morphologically closing holes in the image in a 15 pixel neighborhood
    BW1 = imclose(BW1,true(3));    
    BW2 = imclose(BW2,true(20));
    BW3 = imclose(BW3,true(5));
    BW4 = imclose(BW4,true(20));
    BW5 = imclose(BW5,true(30));
    BW6 = imclose(BW6,true(5));
    
    
    % Fill in holes, consider different type for this
    BW1 = imfill(BW1,'holes');
    BW2 = imfill(BW2,'holes');
    BW3 = imfill(BW3,'holes');
    BW4 = imfill(BW4,'holes');
    BW5 = imfill(BW5,'holes');
    BW6 = imfill(BW6,'holes');
    
    BW1 = bwareaopen(BW1,20);
    BW2 = bwareaopen(BW2,200);
    BW3 = bwareaopen(BW3,200);
    BW4 = bwareaopen(BW4,200);
    BW5 = bwareaopen(BW5,200);
    BW6 = bwareaopen(BW6,200);
    
    subplot(3,2,1), subimage(BW1)
    subplot(3,2,2), subimage(BW2)    
    subplot(3,2,3), subimage(BW3)
    subplot(3,2,4), subimage(BW4)    
    subplot(3,2,5), subimage(BW5)
    subplot(3,2,6), subimage(BW6)
    %imshowpair(BW1,BW2,'diff')
end

end

