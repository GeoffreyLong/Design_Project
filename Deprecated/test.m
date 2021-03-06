% Matlab video stucture
%s = struct('cdata',zeros(videoHeight,videoWidth,3,'uint8'),'colormap',[]);
filePath = 'testData/Feb_13_cam1_5.avi';
%filePath = 'testData/July_6_cam1_01.avi';
%filePath = 'testData/July_8_cam1_01.avi';
%filePath = 'testData/July_8_cam1_08.avi';
%filePath = 'testData/Oct_20_cam3_07.avi';

%rect = drawrectangles(filePath);
%rect = drawwithhelper(filePath);



readRect = readrectxml(filePath);


getsubrects(readRect, filePath);



%writeRect = averagerects(rect, readRect);
%writerectxml(filePath, writeRect);
%displayRect(filePath,rect);

%segmentsky7(filePath);




% TODO
%   Add in a way to grab the selections in July and March
%       There are the already populated rects 
%       We will want to get these so we don't have to grab them ourselves
%   Get the plane data
%       We need to be able to parse for pitch, roll, yaw, GPS, etc...
%       This should be stored in some files somewhere
%   Test bed for the horizon
%       This could be done by selecting the horizon using one of opencv's
%       selection tools, then we will need to mark all the pixels to one
%       side of the selection as sky, the other side as terrain. These
%       matrices will be our test matrices...
%       Since that seems like a lot of data to save, perhaps we should just
%       save them as straight line approximations
%       At any rate, after we get them we will "exclusive or" the test
%       horizon with the generated horizon and see how many one's pop up...
%       the fewer one's the better the horizon...
%   Cascade Classifier approach
%       We need to check the imagepostprocessor function to ensure it works
%       Then we need to postprocess the images
%           To effectively do this we need to ensure that the plane is
%           centered in the image and that it is cropped well... 
%           We might want to alter the imagepostprocessor to do this
%           semiprogrammatically, i.e. generate the new subimage then we
%           check to make sure it is correct
%       After this we need to save the postproccessed images in a folder
%       We also need a set of images that are "not planes" in a folder
%   Need to extract the GPS ground truth for images frame by frame 
%       This will be added to our test bed for later use with TTC and
%       trajectory estimation

