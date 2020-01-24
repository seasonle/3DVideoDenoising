function data3result = DnCNNMatlab3D(path, data3)
    data3result = zeros(size(data3),'uint8');
    net = denoisingNetwork('DnCNN');
        for i= 1 : size(data3,3)
            data3result(:,:,i) = denoiseImage(data3(:,:,i),net);
        end
end

