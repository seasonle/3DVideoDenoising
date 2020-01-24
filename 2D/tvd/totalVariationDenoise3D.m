function data3result = totalVariationDenoise3D(path, data3, lambda, iter)
data3result = zeros(size(data3),'uint8');
parfor j = 1:size(data3,3)
        output = TVL1denoise(data3(:,:,j), lambda, iter);
        output = uint8(255* output);        
        data3result(:,:,j) = uint8(output);
end
end

