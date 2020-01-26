function [data3result,timed] = matlabWaveletDenoise3D(path, data3)
data3result = zeros(size(data3),'uint8');
tic;
parfor j = 1:size(data3,3)
        label = data3(:,:,j);
        input = uint8(label);
        output = wdenoise2(input)
        data3result(:,:,j) = uint8(output);
end
timed = toc;
end

