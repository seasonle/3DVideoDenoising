function FFDdenoiseGray(path,imageSet,noiseAdd,useGPU)
format compact;
global sigmas; % input noise level or input noise level map

folderModel = 'models';
folderTest  = 'data';

setTestCur  = imageSet;      % current testing dataset
showResult  = 1;

imageNoiseSigma = noiseAdd;  % image noise level
inputNoiseSigma = noiseAdd;  % input noise level

folderResultCur       =  fullfile(path, ['results\FFDnet_gray_',imageSet,'_',int2str(noiseAdd),'_',datestr(now,'mm_dd_HH-MM-SS')]);
if ~isdir(folderResultCur)
    mkdir(folderResultCur)
end

load(fullfile('models','FFDNet_gray.mat'));
net = vl_simplenn_tidy(net);

% for i = 1:size(net.layers,2)
%     net.layers{i}.precious = 1;
% end

if useGPU
    net = vl_simplenn_move(net, 'gpu') ;
end

% read images
ext         =  {'*.jpg','*.png','*.bmp'};
filePaths   =  [];
for i = 1 : length(ext)
    filePaths = cat(1,filePaths, dir(fullfile(path,folderTest,setTestCur,ext{i})));
end

% PSNR and SSIM
PSNRs = zeros(1,length(filePaths));
SSIMs = zeros(1,length(filePaths));

for i = 1:length(filePaths)
    
    % read images
    label = imread(fullfile(folderTest,setTestCur,filePaths(i).name));
    [w,h,~]=size(label);
    if size(label,3)==3
        label = rgb2gray(label);
    end
    
    [~,nameCur,extCur] = fileparts(filePaths(i).name);
    label = im2double(label);
    
    % add noise
    randn('seed',0);
    noise = imageNoiseSigma/255.*randn(size(label));
    input = single(label + noise);
    
    if mod(w,2)==1
        input = cat(1,input, input(end,:)) ;
    end
    if mod(h,2)==1
        input = cat(2,input, input(:,end)) ;
    end
    
    % tic;
    if useGPU
        input = gpuArray(input);
    end
    
    % set noise level map
    sigmas = inputNoiseSigma/255; % see "vl_simplenn.m".
    
    % perform denoising
    res    = vl_simplennFFD(net,input,[],[],'conserveMemory',true,'mode','test'); % matconvnet default
    % res    = vl_ffdnet_concise(net, input);    % concise version of vl_simplenn for testing FFDNet
    % res    = vl_ffdnet_matlab(net, input); % use this if you did  not install matconvnet; very slow
    
    
    % output = input - res(end).x; % for 'model_gray.mat'
    output = res(end).x;
    
    
    if mod(w,2)==1
        output = output(1:end-1,:);
        input  = input(1:end-1,:);
    end
    if mod(h,2)==1
        output = output(:,1:end-1);
        input  = input(:,1:end-1);
    end
    
    if useGPU
        output = gather(output);
        input  = gather(input);
    end
    % toc;
    % calculate PSNR, SSIM and save results
    [PSNRCur, SSIMCur] = Cal_PSNRSSIM(im2uint8(label),im2uint8(output),0,0);
    if showResult
        
        %imshow(cat(2,im2uint8(input),im2uint8(label),im2uint8(output)));
        %title([filePaths(i).name,'    ',num2str(PSNRCur,'%2.2f'),'dB','    ',num2str(SSIMCur,'%2.4f')])
        %drawnow;
        %pause(pauseTime)
        
        imwrite(im2uint8(vertcat(input,output)), fullfile(folderResultCur, [nameCur, '_compare', extCur] ));
        imwrite(im2uint8(output), fullfile(folderResultCur, [nameCur, '_', extCur] ));

        
    end
    disp([filePaths(i).name,'    ',num2str(PSNRCur,'%2.2f'),'dB','    ',num2str(SSIMCur,'%2.4f')])
    PSNRs(i) = PSNRCur;
    SSIMs(i) = SSIMCur;
end

disp([mean(PSNRs),mean(SSIMs)]);
    
    
    end

