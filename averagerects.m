function [ rect ] = averagerects( rect1, rect2 )
%averagerects: Takes two rect objects and averages their contents
%   rect1, rect 2: nx5 matrices where 
%       n is the number of detections
%       Each row is the frame number with the 4 dimensional rectangle selection


%TODO
%   Iterate through loop on rect1's rows
%   
rectIdx = 0;
curRect2Idx = 0;
for i = 1:numel(rect1(:,5))
    curRect1Row = rect1(i,:)
    curRect2Row = rect2(curRect2Idx,:)
    
    % If the "frame number" of a rectangle is less than another's "frame number"
    % Simply add that row to to the rect and increment the necessary counters
    if (curRect2Row(1) < curRect1Row(1))
        rect(rectIdx, :) = curRect2Row;
        rectIdx = rectIdx + 1;
        curRect2Idx = curRect2Idx + 1;
    elseif (curRect2Row(1) > curRect1Row(1))
        rect(i, :) = curRect1Row;
        rectIdx = rectIdx + 1;
        
    % If the two "frame numbers" are identical 
    %   then we have two detections in the same image
    %   There are two possibilities
    %       1) The two detections correspond to the same feature
    %       2) The two detections correspond to different features
    elseif (curRect2Row(1) == curRect1Row(1))
        tempRect2Idx = curRect2Idx;
        while (curRect2Row(1) == curRect1Row(1))
            %NOTE there might be a better way to do this
            distance = norm(curRect2Row, curRect1Row);

 
            % Case (1)
            if (distance < THRESHOLD)
                % Add the average of the two
                rect(rectIdx, :) = (curRect2Row + curRect1Row) / 2;
                rectIdx = rectIdx + 1;
                curRect2Idx = curRect2Idx + 1;
                break;
            % Case (2) simply skip the current element of rect2
            else
                %TODO
            end
 
            
            tempRect2Idx = tempRect2Idx + 1;
            curRect2Row = rect2(tempRect2Idx,:);
        end        
        
    end
    
end


rect = 0;


end

