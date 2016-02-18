function [ net ] = change_existing_cnn()
%INITIALIZE_CNN 
%   This will initialize the cnn and change it
%   Could make it extensible by taking in the previous net as an argument

% load the pre-trained CNN
net = load('nets/imagenet-vgg-f.mat') ;

% Display the internals of a network
% vl_simplenn_display(net, 'inputSize', [224 224 2 265])


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
net.layers{end+1} = struct('type', 'conv', ...
                           'weights', {{f*randn(1,1,4096,2, 'single'), zeros(1, 2, 'single')}}, ...
                           'size', [1 1 4096 2], ...
                           'stride', 1, ...
                           'pad', 0, ...
                           'name', 'fc8') ;
net.layers{end+1} = struct('type', 'softmaxloss') ;  

% View net structure
% vl_simplenn_display(net, 'inputSize', [224 224 2 265])

end

