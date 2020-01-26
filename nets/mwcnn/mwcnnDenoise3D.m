function [data3result,timed] = mwcnnDenoise3D(path, data3, Sigma, modelName, showresult)
data3result = zeros(size(data3),'uint8');

tic;

addpath(genpath('./.'));
vl_setupnn();

gpu = 1;

if gpu
    gpuDevice(gpu);
end


%%% PSNR and SSIM
PSNRs = zeros(1,size(data3,3));
SSIMs = zeros(1,size(data3,3));


%% load model
load(fullfile('models', [modelName num2str(Sigma)]));

net = dagnn.DagNN.loadobj(net) ;
net.removeLayer('objective') ;
out_idx = net.getVarIndex('prediction') ;
net.vars(net.getVarIndex('prediction')).precious = 1 ;
net.mode = 'test';
if gpu
    net.move('gpu');
end

for i = 1 : size(data3,3)
    im = data3(:,:,i);
    im  = modcrop(im, 8);
    if size(im,3)==3
        label_im = rgb2gray(im);
        label = label_im(:,:,1);
    else
        label = im;
    end
    label = im2single(label);
    input = label;
    randn('seed',0);

    output = Processing_Im(input, net, gpu, out_idx);

    [PSNRCur, SSIMCur] = Cal_PSNRSSIM(im2uint8(label),im2uint8(output), 0, 0);
    
    if showresult
        imshow(cat(2,im2uint8(input),im2uint8(output)));
        title([num2str(i),'    ',num2str(PSNRCur,'%2.2f'),'dB','    ',num2str(SSIMCur,'%2.4f')])
        drawnow;
    end
    
    data3result(1:size(output,1),1:size(output,2),i) = im2uint8(output);
    PSNRs(i) = PSNRCur;
    SSIMs(i) = SSIMCur;
end
fprintf('PSNR / SSIM : %.02f / %0.4f\n', mean(PSNRs),mean(SSIMs));
timed = toc;
end

