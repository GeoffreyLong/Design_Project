% Matlab video stucture
%s = struct('cdata',zeros(videoHeight,videoWidth,3,'uint8'),'colormap',[]);
filePath = '/home/geoffrey/Dropbox/Temps/Design_Project/Feb_13_cam1_5.avi';

%rect = drawrectangles(filePath);
%rect = drawwithhelper(filePath);



readRect = readrectxml(filePath);


getsubrects(readRect, filePath);



%writeRect = averagerects(rect, readRect);
%writerectxml(filePath, writeRect);
%displayRect(filePath,rect);

%segmentsky7(filePath);




% GETTING TEST DATA
%       Once we have these subgrids, we can use some sort of 
%           feature detector, descriptor extractor, descriptor matcher combination
%           to pull the features from these subimages, extract their descriptors
%           then match them in the larger images
%       It would also be cool to compose a sort of 'dictionary' of plane images
%           It might be possible to do this in an ML fashion
%           some iteration of dictionary learning through sparse representation

% TODO
%   Add a postprocessing for the rects
%       This will likely provide a way to draw a rect on the subimages
%       Then these subimage rects will be saved in a processed_XXX.dat file
%       In this we need to find a way to get the absolute rect position in
%       the original image from the new subrect, else the coordinates will
%       be largely useless.
%       When we do this we should save the processed subimages in a
%       subfolder so we can start on haar feature stuff.
%   Need a set of rects that are "not planes"
%   Need to extract the ground truth for images frame by frame 
%       This will be added to our test bed for later use with TTC and
%       trajectory estimation




