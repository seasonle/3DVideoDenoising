startup();
homePath = 'A:\PROJECTS\2019_11_AIP\';
%imageSet = 'zuendkerze3';
%imageSet = 'Set12';
imageSet = 'qrm1ROI';


%%% STANDARD 2D-Filters
%gaussDenoise(homePath,imageSet);

%guidedImageDenoise()

%laplacianDenoise

%meanBoxDEnoise

%medianDenoise

%nonLocalMeansDenoise

% wienerDenoise


%totalVariationDenoise(homePath,imageSet,1.0,100);
bm3dDenoise(homePath,imageSet,0.02);

%%% GENERAL PURPOSE CNN FOR DENOISING
%DnCNNdenoise(homePath,imageSet,0,1);
%FFDdenoise('grayReal',homePath,imageSet,0,1);
% noise model 1-25
%IRCNNdenoise(homePath,imageSet,0,10,1);

%%% LOW DOSE CT NETS
%WaveresnetDenoise(homePath,imageSet,1)
%WaveresnetDenoiseRNN(homePath,imageSet,1)
%AAPMChallenge(homePath,imageSet,1)


% levels, sigma noise, wavelet type
%neighShrinkDenoise(homePath,imageSet, 4 , 30, 'sym8');
%matlabWaveletDenoise(homePath, imageSet);