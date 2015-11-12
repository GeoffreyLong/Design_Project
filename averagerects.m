function [ rect ] = averagerects( rect1, rect2 )
%averagerects: Takes two rect objects and averages their contents
%   rect1, rect 2: nx5 matrices where 
%       n is the number of detections
%       Each row is the frame number with the 4 dimensional rectangle selection

%TODO might want to consider adding a weight to the old rects
% Currently they are being averaged 1 to 1 with the new rects
 

THRESHOLD = 20; % Might want to base on vector size

inputRect = sortrows(vertcat(rect1, rect2));
inputRectSize = numel(inputRect(:,5));
rect(1,:) = inputRect(1,:);

for inputIdx = 1:inputRectSize
    inputRow = inputRect(inputIdx,:);
    rectIdx = numel(rect(:,5));
    while (true)
        if (rectIdx < 1)
            rect(numel(rect(:,5)) + 1,:) = inputRow;
            break;
        end
        
        
        rectRow = rect(rectIdx,:);
        if (rectRow(1) == inputRow(1))
            distance = norm(rectRow - inputRow);
            if (distance < THRESHOLD)
                rect(rectIdx,:) = ceil((rectRow + inputRow) / 2);
                break;
            end
        end
        rectIdx = rectIdx - 1;
   end
end