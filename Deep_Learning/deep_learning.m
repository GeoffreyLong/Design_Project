%TODO
%   Test some of the stock CNNs using approach 2 for the aircraft
%       Test and evaluate
%   Run my own CNN learning for the images I have so far (only "plane")
%       Test and evaluate
%   Gather new data (images) from the roll compensated images
%   Run the CNN again 
%       Test and evaluate
%   Split the data into "helicopter" vs "plane"
%       Test and evaluate
%   Further segment into the different approaches (i.e. headon vs not)

% Note that it would be best to train the system on bounding boxes (image
% regions) that were gathered using what Xavier is working on. For now, we
% can just do it by the CMO option. So the locations of interest will be
% the CMOs and the CNN will be applied to the bounded region of the CMO.

