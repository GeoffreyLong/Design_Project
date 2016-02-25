%TODO
%   Need to set up net.normalization
%   Need to set up net.layers
%   I don't think that the net is loading properly, or perhaps it wasn't
%       made correctly... It is better just to pass in the net after making it
%       since the algorithm does not retrain it, but has the missing info
%       if I run the train_net_from_previous


% load the pre-trained CNN
net = load('data/exp/net-epoch-5.mat') ;

vl_simplenn_display(net, 'inputSize', [224 224 2 265])

imSize = [224 224];
    
imagefiles = dir('../data/Generate_Data/v1/HeadOnPlane/*.png');      
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
    
    im_ = imresize(im_,imSize);
    %TODO find where net.meta.normalization is declared
    %im_ = imresize(im_, net.meta.normalization.imageSize(1:2)) ; 
    %im_ = im_ - net.meta.normalization.averageImage ;

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