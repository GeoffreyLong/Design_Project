function [ subrect ] = getsubrects( rect, videoPath )
%getsubrects: use the video and the rects to extract the useful part of the image
%   subrect: A cell of images
%   rect: Previously generated rectangles
%   videoPath: The path to the video associated with the rectangles

% Instantiate the video reader
v = VideoReader(videoPath);

inputRectSize = numel(rect(:,5));

% Instantiate the video reader
v = VideoReader(videoPath);

% Get the number of frames, frame width, and frame height from the video data
nFrames = v.NumberOfFrames;
width = v.Width;
height = v.Height;


for i = 1:inputRectSize
    curRect = rect(i,:)
    
    if (curRect(1) == 0)
        return
    end
    
    image = read(v,curRect(1));
    
        
    startRow = curRect(3);
    endRow = curRect(3) + curRect(5);
    startCol = curRect(2);
    endCol = curRect(2) + curRect(4);
    subrect{i} = image(startRow:endRow,startCol:endCol);
    imshow(subrect{i});
end

end

