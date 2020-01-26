function [data3result, timed] = IRCNNdenoise3D(path,data3,noiseImg,noiseModels,useGPU)

data3result = zeros(size(data3),'uint8');
tic;
noiseImg = [noiseImg];
noiseModels = [noiseModels];
addpath('utilities');
folderModel   = 'models';
imageSigmaS   = [noiseImg];
modelSigmaS   = [noiseModels];
load(fullfile(path,'nets/ircNN/',folderModel,'modelgray.mat'));

for i = 1:length(modelSigmaS)
    
    disp([i,length(modelSigmaS)]);
    net = loadmodel(modelSigmaS(i),CNNdenoiser);
    net = vl_simplenn_tidy(net);
    % for i = 1:size(net.layers,2)
    %     net.layers{i}.precious = 1;
    % end
    %%% move to gpu
    if useGPU
        net = vl_simplenn_move(net, 'gpu');
    end
    
    for j= 1 : size(data3,3)
     
        label = data3(:,:,j);;

        label = im2double(label);
        randn('seed',0);
        input = single(label + imageSigmaS(i)/255*randn(size(label)));
        
        %%% convert to GPU
        if useGPU
            input = gpuArray(input);
        end
        res    = vl_simplenn(net,input,[],[],'conserveMemory',true,'mode','test');
        output = input - res(end).x;
        
        %%% convert to CPU
        if useGPU
            output = gather(output);
            input  = gather(input);
        end

        data3result(:,:,j) = im2uint8(output);        
    end
end

timed = toc;


end
