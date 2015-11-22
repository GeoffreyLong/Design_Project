% Matlab video stucture
%s = struct('cdata',zeros(videoHeight,videoWidth,3,'uint8'),'colormap',[]);
filePath = '/media/nrc/flight_data/Collision Avoidance Data/Jan 20 2011/cam 3/cam3_03.avi';

rect = drawrectangles(filePath);

readRect = readrectxml(filePath);
writeRect = averagerects(rect, readRect);
writerectxml(filePath, writeRect);
%displayRect(filePath,rect);

%segmentsky6(filePath);

% GETTING TEST DATA
%       When bounding the planes it is important that we are somewhat consistent
%           I say try to give a berth of a few pixels (about 3-5) around each plane
%               and try to center the plane in the box
%           We might want to alter the drawrectangles to be more exact
%               i.e. have matlab highlight the box after selecting so that it can 
%               be altered... It might be annoying if you accidentally messed up otherwise
%       Possibly change getrect in drawrectangles to imrect
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


% For segmentsky analysis need to overlay the filtered image onto original
