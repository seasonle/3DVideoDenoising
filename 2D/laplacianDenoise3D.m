function data3result = laplacianDenoise3D(path, data3, sigma, alpha, beta)
data3result = zeros(size(data3),'uint8');
parfor j = 1:size(data3,3)
        output = locallapfilt(data3(:,:,j),sigma,alpha,beta);
        data3result(:,:,j) = uint8(output);
end
end

