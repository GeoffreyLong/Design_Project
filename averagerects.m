function [ rect ] = averagerects( rect1, rect2 )
%averagerects: Takes two rect objects and averages their contents
%   rect1, rect 2: nx5 matrices where 
%       n is the number of detections
%       Each row is the frame number with the 4 dimensional rectangle selection
 

THRESHOLD = 20; % Should be based on vector size

newRect = sortrows(vertcat(rect1, rect2));
newRectSize = numel(newRect(:,5));
rect(1,:) = newRect(1,:);

for idx = 1:newRectSize
    oldRow = newRect(idx,:);
    idxRect = numel(rect(:,5));
    while (true)
        if (idxRect < 1)
            rect(numel(rect(:,5)) + 1,:) = oldRow;
            break;
        end
        
        
        curRow = rect(idxRect,:);
        if (curRow(1) == oldRow(1))
            distance = norm(curRow - oldRow);
            if (distance < THRESHOLD)
                rect(idxRect,:) = ceil((curRow + oldRow) / 2);
                break;
            end
        end
        idxRect = idxRect - 1;
   end
end