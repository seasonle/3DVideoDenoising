function DnCNNdenoise(path,imageSet,noiseAdd,useGPU)


%clear; clc;

%% testing set
%addpath(fullfile('utilities'));

mainpath = fullfile(path,'nets\DnCNN\TrainingCodes\DnCNN_TrainingCodes_DagNN_v1.1\');

folderModel = 'model';
folderTest  = 'testsets';
folderResult= 'results';
imageSets   = {'BSD68','Set12','SetZ','zuendkerze3'}; % testing datasets
setTestCur  = imageSets{4};      % current testing dataset

setTestCur = fullfile(path,'\data',imageSet);

showresult  = 1;
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

% read images
ext         =  {'*.jpg','*.png','*.bmp'};
filePaths   =  [];
for i = 1 : length(ext)
    filePaths = cat(1,filePaths, dir(fullfile(setTestCur,ext{i})));
end

folderResultCur       =  fullfile(path, ['results\DnCNN_',imageSet,'_',int2str(noiseSigma),'_',datestr(now,'mm_dd_HH-MM-SS')]);
if ~isdir(folderResultCur)
    mkdir(folderResultCur)
end


% PSNR and SSIM
PSNRs = zeros(1,length(filePaths));
SSIMs = zeros(1,length(filePaths));


for i = 1 : length(filePaths)
    
    % read image
    label = imread(fullfile(setTestCur,filePaths(i).name));
    [~,nameCur,extCur] = fileparts(filePaths(i).name);
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
    
    
    % calculate PSNR and SSIM
    [PSNRCur, SSIMCur] = Cal_PSNRSSIM(label,im2uint8(output),0,0);
    if showresult
        %imshow(cat(2,im2uint8(input),im2uint8(label),im2uint8(output)));
        c = gather(im2uint8(vertcat(input,output)));
        
        %imshow(cat(1,im2uint8(input),im2uint8(output)));
        %title([filePaths(i).name,'    ',num2str(PSNRCur,'%2.2f'),'dB','    ',num2str(SSIMCur,'%2.4f')])
        %imwrite(im2uint8(output), fullfile(mainpath,folderResultCur, [nameCur, '_' int2str(noiseSigma),'_PSNR_',num2str(PSNRCur*100,'%4.0f'), extCur] ));
        %drawnow;
        
        imwrite(c,fullfile(folderResultCur, [nameCur, '_compare_', extCur]));
        imwrite(im2uint8(output),fullfile(folderResultCur, [nameCur, extCur]));

       % pause()
    end
    %PSNRs(i) = PSNRCur;
    %SSIMs(i) = SSIMCur;
end


%disp([mean(PSNRs),mean(SSIMs)]);


end

