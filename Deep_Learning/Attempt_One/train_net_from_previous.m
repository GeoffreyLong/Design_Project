function [net, info] = train_net_from_previous()
    %%%%% Instantiate all the opt data for cnn_train %%%%%
    opts.numEpochs = 5;
    % Set logarithmic learning rate for 250 epochs
    opts.learningRate = logspace(-3, -5, opts.numEpochs);
    % Set the batch size
    opts.batchSize = 256;

    %%%%% Train a new cnn from a previously trained cnn %%%%%
    net = change_existing_cnn();

    %%%%% Instantiate the IMDB %%%%%
    imdb = initialize_data();
    opts.train = find(imdb.images.set == 1);
    opts.val = find(imdb.images.set == 2);

    %%%%% Train the new net %%%%%
    [newNet, info] = cnn_train(net, imdb, @getBatch, opts);
    newNet.layers{end}.type = 'softmax';
   
    %run_detector(newNet);
    run_detector(newNet);
end

function [im, labels] = getBatch(imdb, batch)
    im = imdb.images.data(:,:,:,batch) ;
    labels = imdb.images.labels(1,batch) ;
    
    %TODO 
    % Can add in jittering and other filters to add extra test data
    % Also consider pulling out the mean of the images
end