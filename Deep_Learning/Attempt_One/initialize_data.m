function [ imdb ] = initialize_data()
%INITIALIZE_DATA Summary of this function goes here
%   Detailed explanation goes here

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
    dataDirName = '../data/Generate_Data/v1';
    dataDir = dir(dataDirName);

    % Get each of the subfolders which is a directory, these are the categories
    % Remove all the '.' and '..'
    allSubs = [dataDir(:).isdir];
    subFolders = {dataDir(allSubs).name}';
    subFolders(ismember(subFolders,{'.','..'})) = [];

    num_ims = 1019;

    % Preallocate for speed
    imdb.images.data   = zeros(imSize(1), imSize(2), 3, num_ims, 'single');
    imdb.images.labels = zeros(1, num_ims, 'single');
    imdb.images.set    = zeros(1, num_ims, 'uint8');



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

            % Set is 1 for training, 2 for testing
            imdb.images.set(1, imgIdx) = 1;
            if (mod(imgIdx,testInterval) == 0)
                imdb.images.set(1, imgIdx) = 2;
            end
            % Increment the image index
            imgIdx = imgIdx + 1;
        end
    end

end

