function data3result = wienerDenoise3D(path, data3, filterN, filterM)
data3result = zeros(size(data3),'uint8');
parfor j = 1:size(data3,3)
        output = wiener2(data3(:,:,j),[filterN filterM]);
        data3result(:,:,j) = uint8(output);
end
end


