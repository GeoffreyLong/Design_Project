% Take in the roll / pitch / yaw using testData/getdetailedsrt.m
% Within local windows i.e. sized 24x24 or thereabouts
%   Calculate the expected flow based on these params
%       i.e. how the local features are supposed to change based on their 
%       position in the frame and the ego motion
%       This estimation would be based on the camera intrinsics 
%       See the file Algorithm_One/estimateplanelocation.m for help
%       At any rate the projections in this script probably need to be improved
%   Search for any deviations
% In a head on collision scenario there won't be any deviations, 
%   only growth of the plane, so this won't help to much in that
% It is possible that this will allow us to remove ego motion from the
%   motion of the features though, which will allow us to estimate the
%   trajectory of the plane
% It would be best if we could learn what a 
%   combination of window location and camera motion does to the local
%   image flow... i.e. learn what adjustments need to be made in each scenario
%   to account for the ego motion


%TODO possibly rename this file, I don't know if this is the right name
% It is more like learning the camera intrinsics and ego motion better