% setup MatConvNet
% run  'matconvnet-1.0-beta18/matlab/vl_setupnn'

% load the pre-trained CNN
net = load('nets/imagenet-vgg-f.mat') ;

imagefiles = dir('data/testSet_1/HeadOn_Plane/*.png');      
nfiles = length(imagefiles);    % Number of files found
result = zeros(1,2);
for ii=1:nfiles
    % load and preprocess an image
   currentfilename = imagefiles(ii).name;
   im = imread(currentfilename);
    if size(im,3) == 1 % Grayscale image
        im = cat(3, im, im, im) ;
    end
    im_ = single(im) ; % note: 0-255 range
    im_ = imresize(im_, net.meta.normalization.imageSize(1:2)) ;
    % size(im_)
    %size(net.meta.normalization.averageImage)
    im_ = im_ - net.meta.normalization.averageImage ;

    % run the CNN
    res = vl_simplenn(net, im_) ;
    
    % Get the output for the i-th layer, each model has one avg image value
    % res(i).x

    % show the classification result
    scores = squeeze(gather(res(end).x)) ;
    [bestScore, best] = max(scores) ;
    %figure(1) ; clf ; imagesc(im) ;
    %title(sprintf('%s (%d), score %.3f',...
    %net.meta.classes.description{best}, best, bestScore)) ;
    
    %sprintf('%s (%d), score %.3f',net.meta.classes.description{best}, best, bestScore)
    result = [result; best bestScore];
end

result
%result = sortrows(result,1)