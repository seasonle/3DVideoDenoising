startup();
homePath = 'A:\PROJECTS\2019_11_AIP\';
%imageSet = 'zuendkerze3';
%imageSet = 'Set12';
imageSet = 'qrm1\qrm1_1';


%DnCNNdenoise(homePath,imageSet,0,1);
%FFDdenoise('grayReal',homePath,imageSet,0,1);


% noise model 1-25
%IRCNNdenoise(homePath,imageSet,0,10,1);


WaveresnetDenoise(homePath,imageSet,1)


% levels, sigma noise, wavelet type
%neighShrinkDenoise(homePath,imageSet, 4 , 30, 'sym8');
%matlabWaveletDenoise(homePath, imageSet);