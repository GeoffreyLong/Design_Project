function [ outImg ] = imageCompensation(rawImg, imgHeight, roll, pitch )
%UNTITLED2 Summary of this function goes here

    rollImage = imrotate(rawImg, -roll, 'crop');
    
    % shift x pixels, y pixels
    x = 0;
    %as plane is always on the same level as target, and pitch only
    %flucuates 1-4 degrees, not much point in compensating for it
    y = sin(degtorad(pitch))*imgHeight;

    outImg = imtranslate(rollImage, [x,y]);%, 'OutputView', 'full');
    

end

