
function data3result = neighShrinkDenoise3D(path, data3, levels, sigma, wtype)
data3result = zeros(size(data3),'uint8');
parfor j = 1:size(data3,3)
        label = data3(:,:,j);
        input = double(label);
        output = NeighShrinkSUREdenoise(input, sigma, wtype, levels);
        data3result(:,:,j) = uint8(output);
end
end





