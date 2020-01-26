function [data3result, timed] = DnCNNMatlab3D(path, data3)
    data3result = zeros(size(data3),'uint8');
    tic;
    net = denoisingNetwork('DnCNN');
        for i= 1 : size(data3,3)
            data3result(:,:,i) = denoiseImage(data3(:,:,i),net);
        end
    timed = toc;
end

