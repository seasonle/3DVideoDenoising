names = { 'raw', 'aapm', 'dncnn', 'ffdnet', 'ircnn', 'mWav', 'nsWav', 'wavRes', 'wavResRNN' };
results = {};

homepath = 'A:\PROJECTS\2019_11_AIP\';
paths = { 'data\qrm1ROI\', ...
          'validation\data\AAPMChallenge\', ...
          'validation\data\DnCNN\', ...
          'validation\data\FFDnet\', ...
          'validation\data\ircNN\', ...
          'validation\data\matlabWavelet\', ...
          'validation\data\neighShrink\', ...
          'validation\data\Waveresnet\', ...
          'validation\data\WaveresnetRNN\' };
          
sliceStart= 203;
sliceEnd = 283;
rotAngle = 36.5;
   
for i=1:size(names,2)
    
   result = edgeScore(strcat(homepath,paths{i}),'.png',sliceStart,sliceEnd,rotAngle);
   results{i} = result;
    
    
end
 

T = table(transpose(names),transpose(results));
colors = distinguishable_colors(size(T,1));

x = 0:10;
for i=1:size(T,1)
    tmp =  T{i,2};
    tmp = tmp{:};
    plot(x,tmp(1:11),'LineWidth',2,'Color',colors(i,:));
    hold on
end
legend(names)
hold off
