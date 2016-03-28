function [midPoint] = getMidPoint(tempRect)

   % This function takes in a detection rectangle as an input
   % and outputs the midpoint of that detection
    x = tempRect(2)+0.5*tempRect(4);
    y = tempRect(3)+0.5*tempRect(5);
    midPoint = [x y];

end