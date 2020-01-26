function [data3result, timed] = DnCNNdenoise3D(path, data3, noiseAdd,useGPU)

data3result = zeros(size(data3),'uint8');

tic;

%% testing set
mainpath = fullfile(path,'nets\DnCNN\TrainingCodes\DnCNN_TrainingCodes_DagNN_v1.1\');
gpu         = useGPU;

noiseSigma  = noiseAdd;
% load model
epoch       = 50;
modelName   = 'DnCNN';

% case one: for the model in 'data/model'
%load(fullfile('data',folderModel,[modelName,'-epoch-',num2str(epoch),'.mat']));

% case two: for the model in 'utilities'
load(fullfile(mainpath,'utilities',[modelName,'-epoch-',num2str(epoch),'.mat']));

net = dagnn.DagNN.loadobj(net) ;

net.removeLayer('loss') ;
out1 = net.getVarIndex('prediction') ;
net.vars(net.getVarIndex('prediction')).precious = 1 ;

net.mode = 'test';

if gpu
    net.move('gpu');
end

for i= 1 : size(data3,3)
    
    % read data
    label = data3(:,:,i);
    [w,h,c]=size(label);
    if c==3
        label = rgb2gray(label);
    end
    
    % add additive Gaussian noise
    randn('seed',0);
    noise = noiseSigma/255.*randn(size(label));
    input = im2single(label) + single(noise);
    
    if gpu
        input = gpuArray(input);
    end
    net.eval({'input', input}) ;
    % output (single)
    output = gather(squeeze(gather(net.vars(out1).value)));
    
    
    data3result(:,:,i) = im2uint8(output);
end

timed = toc;

end

