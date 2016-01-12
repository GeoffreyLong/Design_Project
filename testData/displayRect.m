function displayRect( videoPath, rect )

% Instantiate the video reader

v = VideoReader(videoPath);
nFrames = v.NumberOfFrames;

rectIdx = 1;
maxRectIdx = size(rect,1);

mov(1:nFrames) = struct('cdata',zeros(v.Height,v.Width,3,'uint8'),'colormap',[]);


for i = 1:nFrames
%   insert the rectangle as the specified location on each frame
    if (rectIdx <= maxRectIdx && rect(rectIdx,1) == i)
        tmpIdx = 1;

        while (rectIdx <= maxRectIdx && rect(rectIdx,1) == i)
            tmpRects(tmpIdx, :) = [rect(rectIdx,2) rect(rectIdx,3) rect(rectIdx,4) rect(rectIdx,5)];
            rectIdx = rectIdx + 1;
            tmpIdx = tmpIdx + 1;
        end
        mov(i).cdata= insertShape(read(v,i), 'Rectangle', tmpRects, 'LineWidth', 1);
    else

        mov(i).cdata= insertShape(read(v,i), 'Rectangle', [0 0 0 0], 'LineWidth', 1);
    end
end

implay(mov)
% while hasFrame(v)
%     video = readFrame(v);
%     shape = insertShape(video, 'circle', [150 280 35], 'LineWidth', 5);
%     imshow(shape);
% end


