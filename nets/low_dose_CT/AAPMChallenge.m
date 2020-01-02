function AAPMChallenge(path,imageSet,useGPU)

%% Parameters
lv                  = [1,2,3];              % vector of numbers of directional filter bank decomposition levels at each pyramidal level
dflt                = 'vk';                 % filter name for the directional decomposition step
patchsize           = 110;                   %55;                   % the size of patch
batchsize           = 5;                     %10;                   % the size of batch
overlap             = 10;                   % the size of overlap region to recon the whole image(512x512)
wgt                 = 1e3;                  % weight multiplied to input
gpus                = useGPU;                    % gpu on / off

showResult    = 1;
saveResult    = 1;

%%% folder to store results
%folderResultCur = fullfile(folderResult, [taskTestCur,'_',setTestCur]);
folderResultCur       =  fullfile(path, ['results\AAPMChallenge_',imageSet,'_',datestr(now,'mm_dd_HH-MM-SS')]);
folderTest    = 'data';
setTestCur    = imageSet;

if ~exist(folderResultCur,'file')
    mkdir(folderResultCur);
end

%%% read images
ext         =  {'*.jpg','*.png','*.bmp'};
filePaths   =  [];
folderTestCur = fullfile(path,folderTest,setTestCur);
for i = 1 : length(ext)
    filePaths = cat(1,filePaths, dir(fullfile(folderTestCur,ext{i})));
end



load('trained_networks\net-aapm-challenge.mat');
% test data 

if gpus > 0
    reset(gpuDevice(gpus));
    net = vl_simplenn_move(net, 'gpu');
end

parfor j = 1:length(filePaths)
    display(j);
    %%% read images
    label = imread(fullfile(folderTestCur,filePaths(j).name));
    [~,imageName,extCur] = fileparts(filePaths(j).name);
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
    

    if showResult
        %imshow(cat(2,im2uint8(label),im2uint8(input),im2uint8(output)));
        %title([filePaths(j).name,'    ',num2str(PSNRCur,'%2.2f'),'dB','    ',num2str(SSIMCur,'%2.4f')])
        %drawnow;
        if saveResult
            c = gather(vertcat(input,output));
            imwrite(c,fullfile(folderResultCur, [filePaths(j).name(1:end-4), '_compare', extCur]));
            imwrite(output,fullfile(folderResultCur, [filePaths(j).name]));
        end
    end

    
end

end

