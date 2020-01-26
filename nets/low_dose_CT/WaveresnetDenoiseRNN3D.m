function [data3result,timed] = WaveresnetDenoiseRNN3D(path,data3,useGPU)

data3result = zeros(size(data3),'uint8');

tic;
%% Parameters
lv                  = [1,2,3];              % vector of numbers of directional filter bank decomposition levels at each pyramidal level
dflt                = 'vk';                 % filter name for the directional decomposition step
patchsize           = 110;                   %55;                   % the size of patch
batchsize           = 5;                     %10;                   % the size of batch
overlap             = 10;                   % the size of overlap region to recon the whole image(512x512)
wgt                 = 1e3;                  % weight multiplied to input
gpus                = useGPU;                    % gpu on / off

load('trained_networks\net-forward-process.mat');
% test data 

if gpus > 0
    reset(gpuDevice(gpus));
    net = vl_simplenn_move(net, 'gpu');
end

%parfor j = 1:length(filePaths)
parfor j = 1:size(data3,3)
    
    %%% read images
    label = data3(:,:,j);
    input = single(label);

    input = mat2gray(input);
    input = input/20.0;

    output = cnn_CT_denoising_forward_process(net,input,lv,dflt,patchsize,batchsize,overlap,wgt,gpus);

    %%% convert to CPU
    if useGPU
        output = gather(output);
        input  = gather(input);
    end
    
    input = uint8(255*mat2gray(input,[0,0.05]));
    output = uint8(255*mat2gray(output,[0,0.05]));

    data3result(:,:,j) = output;   
end

timed = toc;
end

