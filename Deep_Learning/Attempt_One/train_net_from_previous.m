function [net, info] = train_net_from_previous()
    %%%%% Instantiate all the opt data for cnn_train %%%%%
    opts.numEpochs = 250;
    % Set logarithmic learning rate for 250 epochs
    opts.learningRate = logspace(-3, -5, 250);
    % Set the batch size
    opts.batchSize = 256;

    %%%%% Train a new cnn from a previously trained cnn %%%%%
    net = change_existing_cnn();

    %%%%% Instantiate the IMDB %%%%%
    imdb = initialize_data();
    opts.train = find(imdb.images.set == 1);
    opts.val = find(imdb.images.set == 2);

    [net, info] = cnn_train(net, imdb, @getBatch, opts)
end

function [im, labels] = getBatch(imdb, batch)
    im = imdb.images.data(:,:,:,batch) ;
    labels = imdb.images.labels(1,batch) ;
end