%%% Clear workspace
clear;


%%% All data
imds1 = imageDatastore(fullfile('set_1'), 'IncludeSubfolders', true, 'LabelSource', 'foldernames');

imds2 = imageDatastore(fullfile('set_2'), 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
[imds2Train, imds2Rest] = splitEachLabel(imds2, 140, 'randomize');
[imds2Validation, imds2Test] = splitEachLabel(imds2Rest, 30, 'randomize');

imds3 = imageDatastore(fullfile('set_3'), 'IncludeSubfolders', true, 'LabelSource', 'foldernames');

imds123 = imageDatastore({fullfile('set_1'), fullfile('set_2'), fullfile('set_3')}, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');

imdsCustom = imageDatastore(fullfile('set_custom'), 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
[imdsCustomTrain, imdsCustomTest] = splitEachLabel(imdsCustom, 15, 'randomize');

labelsAmount = length(imds1.Labels);



% Layers presets
% Activation Layers

% reluLayer
% A ReLU layer performs a threshold operation to each element of the input, where any value less than zero is set to zero.

% leakyReluLayer
% A leaky ReLU layer performs a threshold operation, where any input value less than zero is multiplied by a fixed scalar.

% clippedReluLayer
% A clipped ReLU layer performs a threshold operation, where any input value less than zero is set to zero and any value above the clipping ceiling is set to that clipping ceiling.

% reluLayer
% An ELU activation layer performs the identity operation on positive inputs and an exponential nonlinearity on negative inputs.

% tanhLayer
% A hyperbolic tangent (tanh) activation layer applies the tanh function on the layer inputs.

% preluLayer (Custom layer example)
% A PReLU layer performs a threshold operation, where for each channel, any input value less than zero is multiplied by a scalar learned at training time.

convolutialNetwork = [
    imageInputLayer([28 28 1])
    
    convolution2dLayer(3, 8, 'Padding', 'same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2, 'Stride', 2)
    
    convolution2dLayer(3, 16, 'Padding', 'same')
    batchNormalizationLayer
    reluLayer
    
    fullyConnectedLayer(labelsAmount)
    softmaxLayer
    classificationLayer];

deepConvolutialNetwork = [
    imageInputLayer([28 28 1])
    
    convolution2dLayer(3, 32, 'Padding', 'same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2, 'Stride', 2)
    
    convolution2dLayer(3, 64, 'Padding', 'same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2, 'Stride', 2)
    
    convolution2dLayer(3, 64, 'Padding', 'same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2, 'Stride', 2)
    
    convolution2dLayer(3, 32, 'Padding', 'same')
    batchNormalizationLayer
    reluLayer

    
    fullyConnectedLayer(labelsAmount)
    softmaxLayer
    classificationLayer];


feedForwardNetwork10 = [
    imageInputLayer([28 28 1])
    
    fullyConnectedLayer(10)
    reluLayer
    
    fullyConnectedLayer(labelsAmount)
    softmaxLayer
    classificationLayer];


feedForwardNetwork32 = [
    imageInputLayer([28 28 1])
    
    fullyConnectedLayer(32)
    reluLayer
    
    fullyConnectedLayer(labelsAmount)
    softmaxLayer
    classificationLayer];


deepFeedForwardNetwork = [
    imageInputLayer([28 28 1])
    
    fullyConnectedLayer(1024)
    reluLayer
    
    fullyConnectedLayer(1024)
    reluLayer
    
    fullyConnectedLayer(1024)
    reluLayer
    
    fullyConnectedLayer(labelsAmount)
    softmaxLayer
    classificationLayer];


layerSet10Neurons1Layer = [
    imageInputLayer([28 28 1])
    
    convolution2dLayer(5, 10, 'Padding', 'same')
    batchNormalizationLayer
    reluLayer
    
    fullyConnectedLayer(labelsAmount)
    softmaxLayer
    classificationLayer];


layerSet10Neurons2Layer = [
    imageInputLayer([28 28 1])
    
    convolution2dLayer(5, 10, 'Padding', 'same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2, 'Stride', 2)
    
    convolution2dLayer(5, 20, 'Padding', 'same')
    batchNormalizationLayer
    reluLayer
    
    
    fullyConnectedLayer(labelsAmount)
    softmaxLayer
    classificationLayer];


%%% Option presets
% trainlm, trainru, trainb, trainr, trainc, trains, trainbu, trainscg, traingdx
% traingdm, traingd, trainbr, traingda
optionSetPkt1 = trainingOptions('sgdm', ...
    'InitialLearnRate', 0.01, ...
    'MaxEpochs', 30, ...
    'Shuffle', 'every-epoch', ...
    'ValidationData', imds1, ...
    'ValidationFrequency', 1, ...
    'Verbose', false, ...
    'Plots', 'training-progress');

optionSetPkt2 = trainingOptions('sgdm', ...
    'InitialLearnRate', 0.01, ...
    'MaxEpochs', 5, ...
    'Shuffle', 'every-epoch', ...
    'ValidationData', imds2Validation, ...
    'ValidationFrequency', 10, ...
    'Verbose', false, ...
    'Plots', 'training-progress');


optionSetPkt3 = trainingOptions('sgdm', ...
    'InitialLearnRate', 0.01, ...
    'MaxEpochs', 5, ...
    'Shuffle', 'every-epoch', ...
    'Verbose', false, ...
    'Plots', 'training-progress');


% % Pkt a 
% 
% disp('Train network netPkt1');
% netPkt1 = trainNetwork(imds1, convolutialNetwork, optionSetPkt1);
% disp('Check all the prediction values and calculate final accuracy'); 
% imds1Prediction = predict(netPkt1, imds1)
% imds1Accuracy = sum(classify(netPkt1, imds1) == imds1.Labels)/numel(imds1.Labels)
% 
% % Pkt b
% disp('Calculate accuracy ont set_2 based only on netPkt1 {out of curiosity}');
% imds2Accuracy = sum(classify(netPkt1, imds2) == imds2.Labels)/numel(imds2.Labels)
% disp('Train new network based on set_2');
% netPkt2 = trainNetwork(imds2Train, layerSet10Neurons2Layer, optionSetPkt2);
% disp('Calculate accuracy');
% imds2TestAccuracy = sum(classify(netPkt2, imds2Test) == imds2Test.Labels)/numel(imds2Test.Labels)
% disp('Check all the prediction values and calculate accuracy on set_1 {out of curiosity}');
% imds1Predistion = predict(netPkt2, imds1)
% imds1Accuracy = sum(classify(netPkt2, imds1) == imds1.Labels)/numel(imds1.Labels)
% 
% 
% % Pkt c
% disp('Calculate accuracy ont set_3 based on netPkt2 (withpout retraining)');
% imds3Accuracy = sum(classify(netPkt2, imds3) == imds3.Labels)/numel(imds3.Labels)
% disp('Retrain netPkt2 with images from set_3');
% net1Pkt3 = trainNetwork(imds3, netPkt2.Layers, optionSetPkt3);
% disp('Check accuracy of retrained network on all sets one by one');
% imds1Accuracy = sum(classify(net1Pkt3, imds1) == imds1.Labels)/numel(imds1.Labels)
% imds2Accuracy = sum(classify(net1Pkt3, imds2) == imds2.Labels)/numel(imds2.Labels)
% imds3Accuracy = sum(classify(net1Pkt3, imds3) == imds3.Labels)/numel(imds3.Labels)
% disp('Retrain netPkt2 with all images from set_1, set_2 and set_3');
% net2Pkt3 = trainNetwork(imds123, netPkt2.Layers, optionSetPkt3);
% disp('Check accuracy of retrained network on all sets one by one');
% imds1Accuracy = sum(classify(net2Pkt3, imds1) == imds1.Labels)/numel(imds1.Labels)
% imds2Accuracy = sum(classify(net2Pkt3, imds2) == imds2.Labels)/numel(imds2.Labels)
% imds3Accuracy = sum(classify(net2Pkt3, imds3) == imds3.Labels)/numel(imds3.Labels)
% 
% 
% % Pkt d
% disp('Check all the prediction values and calculate accuracy of a best network in pkt c on set_custom');
% imds1Prediction = predict(net2Pkt3, imdsCustom)
% imds1Accuracy = sum(classify(net2Pkt3, imdsCustom) == imdsCustom.Labels)/numel(imdsCustom.Labels)
% 
% %%%%
% 
% test1 = trainNetwork(imds123, deepConvolutialNetwork, optionSetPkt3);
% %test1 = trainNetwork(imdsCustomTrain, test1.Layers, optionSetPkt3);
% imds1Prediction = predict(test1, imdsCustom)
% imds1Accuracy = sum(classify(test1, imdsCustom) == imdsCustom.Labels)/numel(imdsCustom.Labels)




% https://www.mathworks.com/help/deeplearning/ug/create-simple-deep-learning-network-for-classification.html



