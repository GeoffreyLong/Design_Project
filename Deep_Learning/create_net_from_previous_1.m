% load the pre-trained CNN

net = load('nets/imagenet-vgg-f.mat') ;

% Display the internals of a network
%vl_simplenn_display(net, 'inputSize', [64 64 1 50])


%   Edit the structure of the neural network: 
%       Change the output data depth to be the same number as my categories
%           For the imagenet-vgg-f this is changing the 1000 value on fc8
%           For my simple plane vs not plane this is changed to 1?
%       Should add back the dropout layers for learning
%           This dropout regularization will help avoid overfitting on small datasets
%           net.layers{layer} = struct('type', 'dropout', 'rate', 0.5)
%           For the imagenet-vgg-f we want these between fc6-fc7 and fc7-fc8
% http://www.cc.gatech.edu/~hays/compvision/results/proj6/araval8/index.html
f = 1/100;
net.layers = net.layers(1:end-2);
net.layers{end+1} = struct('type','dropout','rate',0.5);
net.layers{end + 1} = struct('type', 'conv', ...
                           'weights', {{f*randn(1,1,4096,2, 'single'), zeros(1, 2, 'single')}}, ...
                           'size', [1 1 4096 15], ...
                           'stride', 1, ...
                           'pad', 0, ...
                           'name', 'fc8') ;
net.layers{end+1} = struct('type', 'softmaxloss') ;  

% View net structure
% vl_simplenn_display(net, 'inputSize', [64 64 1 50])





%%%%% Set the IMDB (image database) %%%%%
% TODO subtract the mean of each image
%   1) Either could subtract the mean of all the pixels from the each pixel
%       within an image
%   2) Or could subtract the mean of each pixel over set of images
% TODO jitter and change images to generate more training samples
%   Could do left right flip -> im(:,:,:,i) = fliplr(im(:,:,:,i));
% TODO could use imset = imageSet('test_folder', 'recursive');
%   To load in the stuff we need instead of what I am doing now...


% The images are to be 224x224x3 as per the vgg-f network (I believe)
imSize = [224 224];

% The root directory for the images
dataDirName = 'data/testSet_1';
dataDir = dir(dataDirName);

% Get each of the subfolders which is a directory, these are the categories
% Remove all the '.' and '..'
allSubs = [dataDir(:).isdir];
subFolders = {dataDir(allSubs).name}';
subFolders(ismember(subFolders,{'.','..'})) = [];


% 1/'testInterval' of images will be for testing
% If testInteval is 10 then 1 of every 10 will be for testing
testInterval = 10;

% Index to keep track of the images across all the categories
imgIdx = 1;




for catIdx = 1 : length(subFolders)
   category = subFolders{catIdx};
   images = dir(strcat(dataDirName, '/', category, '/*.png'));
   for j = 1 : length(images)
        img = imread(images(j).name);
        % Resize the image using bicubic interpolation
        img = imresize(img,imSize);
        imdb.images.data(:,:,1,imgIdx) = img;
        imdb.images.data(:,:,2,imgIdx) = img;
        imdb.images.data(:,:,3,imgIdx) = img;
        % This corresponds to the category number I guess
        imdb.images.labels(1,imgIdx) = catIdx;
        % Do I need this for train vs test?
        % Calling 1 for training
        imdb.images.set = 2;
        % Increment the image index
        imgIdx = imgIdx + 1;
   end
end

opts.train = imdb;
opts.val = imdb;

% if we want to pass opts in
% [newNet, info] = my_cnn_train(net, imdb, @getBatch, opts);

% Having lots of issues... I'm assuming with the getBatch
[newNet, info] = my_cnn_train(net, imdb, opts);

