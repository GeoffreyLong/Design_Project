function [im, labels] = getBatch(imdb, batch)
%GETBATCH Summary of this function goes here
%   Detailed explanation goes here

    im = imdb.images.data;
    labels = imdb.images.labels;
end