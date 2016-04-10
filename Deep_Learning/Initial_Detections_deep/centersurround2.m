function [ response ] = centersurround2( subIm, blockSize )
%CENTERSURROUND Summary of this function goes here
%   This is a simple center surround subtraction
%   Subtract the sum of the outer box pixels by the middle pixels
%   Not very effective
    
    subIm = integralImage(subIm);
    scale = (20*20)/(10*10);    % Just to illustrate, this should be put in the outer fn and modularized 
                            % This is the size of the outer / size of the
                            % inner
    
    if (size(subIm, 1) == blockSize(1)+1 && size(subIm, 2) == blockSize(2)+1)
        outer = subIm(end, end) - subIm(1, end) - subIm(end, 1) + subIm(1, 1);
        inner = subIm(15,15) - subIm(5,15) - subIm(15,5) + subIm(5,5);
        response = abs(outer - inner*scale);
    else
        response = 0;
    end
end