% Matlab video stucture
%s = struct('cdata',zeros(videoHeight,videoWidth,3,'uint8'),'colormap',[]);
filePath = 'xylophone.mp4';

rect = drawrectangles(filePath);

readRect = readrectxml(filePath);
writeRect = averagerects(rect, readRect);
writerectxml(filePath, writeRect);
%displayRect(filePath,rect);

%TODO Use this returned rectangle in further analysis
%   Now the first thing we should do is compile some sort of test suite
%       We need to go through the videos and select the locations of planes
%           This would amount from writing another method, say testsave or something
%           that would receive this rectangle and the file location
%           and save the rectangles to some sort of csv or excel spreadsheet
%           Some format that will be easily accessible at a later date
%       When bounding the planes it is important that we are somewhat consistent
%           I say try to give a berth of a few pixels (about 3-5) around each plane
%               and try to center the plane in the box
%           We might want to alter the drawrectangles to be more exact
%               i.e. have matlab highlight the box after selecting so that it can 
%               be altered... It might be annoying if you accidentally messed up otherwise
%       We shouldn't have this file destructively write to the csv
%           If we want accuracy we might want to consider going though each video
%               more than once
%           This would involve pulling the old data
%               and averaging the non-zero old rects with the non-zero new rects
%           Non descructive write is also important if we miss some frames
%               and have to go back to reselect in the video
%               This also likely negates the need to alter the drawrectangles
%               to be more accurate
%   After we have some test data, another thing we could do is extract the subimages
%       Essentially just pull out the subarray of pixels from each image 
%           corresponding to the found grid 
%           The grids can be pulled out of the database we compiled in the above task
%       Once we have these subgrids, we can use some sort of 
%           feature detector, descriptor extractor, descriptor matcher combination
%           to pull the features from these subimages, extract their descriptors
%           then match them in the larger images
%       It would also be cool to compose a sort of 'dictionary' of plane images
%           It might be possible to do this in an ML fashion
%           some iteration of dictionary learning through sparse representation
