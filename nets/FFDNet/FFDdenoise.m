function FFDdenoise(type,path,imageSet,noiseAdd,useGPU)
if(strcmp(type,'gray'))
    FFDdenoiseGray(path,imageSet,noiseAdd,useGPU);
elseif(strcmp(type,'grayReal'))
    FFDdenoiseGrayReal(path,imageSet,useGPU);
elseif(strcmp(type,'grayClip'))
    FFDdenoiseGrayClip(path,imageSet,noiseAdd,useGPU);
elseif(strcmp(type,'spatial'))
    FFDdenoiseSpatial(path,imageSet,noiseAdd,useGPU);
end
end

