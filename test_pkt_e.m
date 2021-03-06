
%%% Test
clear;
% Used: 10   5,5   10,10   10,20,30   10,20,30,40,60 
net = letter_functions.createNet('10 20 30'); 
% Used: trainlm, trainbfg, trainbr, traingda, trainr
net = letter_functions.selectTraining(net, 'trainlm'); 
% Used: tansig, purelin, hardlim, poslin, logsig, logsig
net.layers{1}.transferFcn = 'tansig';
net.layers{2}.transferFcn = 'tansig';
net.layers{3}.transferFcn = 'tansig';
net.layers{4}.transferFcn = 'purelin';

[inputs, targets] = letter_functions.getDataset('all');
net = letter_functions.segmentData(net, 0.90, 0.05, 0.05);

[net, tr] = letter_functions.trainFunction(net, inputs, targets);

[inputs, targets] = letter_functions.getDataset('custom');
net = train(net, inputs, targets);
    
save('networks\good_network', 'net');
    
    
   









