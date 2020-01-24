clc;
clear;

homePath = 'A:\PROJECTS\2019_11_AIP\';
load('A:\PROJECTS\2019_11_AIP\data\qrm2.mat');
formatOut = 'yy-mm-dd_HH_MM_SS';


%% ROI:
data3 = data3(:,:,200:300);


%% 2D Filter

%% block matching
noiseVar = 0.02;
bm3d = bm3dDenoise3D(homePath,data3,noiseVar);
save(fullfile(homePath,"results\",strcat("bm3d",datestr(now,formatOut),".mat")),'bm3d');
clear bm3d;

%% gauss
sigma = 2;
gauss = gaussDenoise3D(homePath,data3,sigma);
save(fullfile(homePath,"results\",strcat("gauss",datestr(now,formatOut),".mat")),'gauss');
clear gauss;

%% guided image filter
gif = guidedImageDenoise3D(homePath,data3);
save(fullfile(homePath,"results\",strcat("gif",datestr(now,formatOut),".mat")),'gif');
clear gif;


%% laplacian
sigma = 0.1;
alpha = 4.0;
beta = 1.0;
laplace = laplacianDenoise3D(homePath,data3, sigma, alpha, beta);
save(fullfile(homePath,"results\",strcat("laplace",datestr(now,formatOut),".mat")),'laplace');
clear laplace;

%% mean box filter
filterSizes = [3, 5, 7];
for fs = 1: length(filterSizes)
    mbox = meanBoxDenoise3D(homePath,data3, filterSizes(fs));
    save(fullfile(homePath,"results\",strcat("mbox_",num2str(filterSizes(fs)),"_",datestr(now,formatOut),".mat")),'mbox');
    clear mbox;
end


%% median filter
median2D = medianDenoise3D(homePath,data3);
save(fullfile(homePath,"results\",strcat("median2D",datestr(now,formatOut),".mat")),'median2D');
clear median2D;


%% non local means filter
value = 0;
nlm = nonLocalMeansDenoise3D(homePath,data3,value);
save(fullfile(homePath,"results\",strcat("nlm",datestr(now,formatOut),".mat")),'nlm');
clear nlm;


%% wiener filter
filterN = 3;
filterM = 3;
wiener = wienerDenoise3D(homePath,data3,filterN,filterM);
save(fullfile(homePath,"results\",strcat("wiener",datestr(now,formatOut),".mat")),'wiener');
clear wiener;


%% total variation
lambda = 1.0;
iter = 100;
tvd = wienerDenoise3D(homePath,data3,lambda,iter);
save(fullfile(homePath,"results\",strcat("tvd",datestr(now,formatOut),".mat")),'tvd');
clear tvd;

%% WAVELETS

%% neighShrink
levels = 4;
sigma = 30; 
wtype = 'sym8';
nshrink = neighShrinkDenoise3D(homePath,data3, levels, sigma, wtype);
save(fullfile(homePath,"results\",strcat("nshrink",datestr(now,formatOut),".mat")),'nshrink');
clear nshrink;

%% wavelet denoise matlab
matwav = matlabWaveletDenoise3D(homePath,data3);
save(fullfile(homePath,"results\",strcat("matwav",datestr(now,formatOut),".mat")),'matwav');
clear matwav;


%% 3D Filter

%% gauss 3D
paddings = ["replicate", "circular", "symmetric", "numeric", "scalar"];
filterSize = 5;
filterDomains = ["frequency", "spatial"];
sigma = 2;

gauss3D = imgaussfilt3(data3,sigma);
save(fullfile(homePath,"results\",strcat("gauss3D",datestr(now,formatOut),".mat")),'gauss3D');
clear gauss3D;


%% box filtering 3D
filterSize = 3;
box3D = imboxfilt3(data3,filterSize);
save(fullfile(homePath,"results\",strcat("box3D",datestr(now,formatOut),".mat")),'box3D');
clear box3D;

% median filtering 3D
filterSize = [3 3 3];
median3D = medfilt3(data3,filterSize);
save(fullfile(homePath,"results\",strcat("median3D",datestr(now,formatOut),".mat")),'median3D');
clear median3D;

%% CNNS

%% DNCNN
dncnn = DnCNNdenoise3D(homePath,data3,0,1);
save(fullfile(homePath,"results\",strcat("dncnn",datestr(now,formatOut),".mat")),'dncnn');
clear dncnn;

%% FFD
useGPU = 1;
ffd = FFDdenoise3D(homePath,data3,useGPU);
save(fullfile(homePath,"results\",strcat("ffd",datestr(now,formatOut),".mat")),'ffd');
clear ffd;

%% IRCNN
noiseImg = 0;
noiseModel = 10;
useGPU = 1;
ircnn = IRCNNdenoise3D(homePath,data3,noiseImg,noiseModel,useGPU);
save(fullfile(homePath,"results\",strcat("ircnn",datestr(now,formatOut),".mat")),'ircnn');
clear ircnn;

%% DNCNN Matlab
dncnnm = DnCNNMatlab3D(homePath,data3);
save(fullfile(homePath,"results\",strcat("dncnnm",datestr(now,formatOut),".mat")),'dncnnm');
clear dncnnm;

%% wavresnet denoise
useGPU = 1;
wrn = WaveresnetDenoise3D(homePath,data3,useGPU);
save(fullfile(homePath,"results\",strcat("wrn",datestr(now,formatOut),".mat")),'wrn');
clear wrn;

%% wavresnet RNN denoise
useGPU = 1;
wrnrnn = WaveresnetDenoiseRNN3D(homePath,data3,useGPU);
save(fullfile(homePath,"results\",strcat("wrnrnn",datestr(now,formatOut),".mat")),'wrnrnn');
clear wrnrnn;


%% AAPM challenge denoise
useGPU = 1;
aapm = AAPMChallenge3D(homePath,data3,useGPU);
save(fullfile(homePath,"results\",strcat("aapm",datestr(now,formatOut),".mat")),'aapm');
clear aapm;


%% mwcnn
Sigma = 15;
modelName = 'MWCNN_Haart_GDSigma';
displayResults = 0;
mwcnn = mwcnnDenoise3D(path, data3, Sigma, modelName, displayResults);
save(fullfile(homePath,"results\",strcat("mwcnn",datestr(now,formatOut),".mat")),'mwcnn');
clear mwcnn;


