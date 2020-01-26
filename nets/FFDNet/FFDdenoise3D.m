function [data3result, timed] = FFDdenoise3D(path, data3,useGPU)
    
    data3result = zeros(size(data3),'uint8');

    tic;
    format compact;
    global sigmas; % input noise level or input noise level map
 
    inputNoiseSigma = 15;  % input noise level
    % -****************************************************-
    % Building.png        (inputNoiseSigma = 20); i = 1
    % Chupa_Chups.png     (inputNoiseSigma = 10); i = 2
    % David_Hilbert.png   (inputNoiseSigma = 15); i = 3
    % Marilyn.png         (inputNoiseSigma = 7);  i = 4
    % Old_Tom_Morris.png  (inputNoiseSigma = 15); i = 5
    % Vinegar.png         (inputNoiseSigma = 20); i = 6
    % -****************************************************-
    
 
    load(fullfile('models','FFDNet_gray.mat'));
    net = vl_simplenn_tidy(net);
    
    % for i = 1:size(net.layers,2)
    %     net.layers{i}.precious = 1;
    % end
    
    if useGPU
        net = vl_simplenn_move(net, 'gpu') ;
    end
    

    for i= 1 : size(data3,3)

        
        % read images
        label = data3(:,:,i);
        [w,h,~]=size(label);
        if size(label,3)==3
            label = rgb2gray(label);
        end
        
        input = im2single(label);
        
        if mod(w,2)==1
            input = cat(1,input, input(end,:)) ;
        end
        if mod(h,2)==1
            input = cat(2,input, input(:,end)) ;
        end
        
        % tic;
        if useGPU
            input = gpuArray(input);
        end
        
        % set noise level map
        sigmas = inputNoiseSigma/255; % see "vl_simplenn.m".
        
        % perform denoising
        res    = vl_simplennFFD(net,input,[],[],'conserveMemory',true,'mode','test'); % matconvnet default
        % res    = vl_ffdnet_concise(net, input);    % concise version of vl_simplenn for testing FFDNet
        % res    = vl_ffdnet_matlab(net, input); % use this if you did  not install matconvnet; very slow
        
        % output = input - res(end).x; % for 'model_gray.mat'
        output = res(end).x;
        
        if mod(w,2)==1
            output = output(1:end-1,:);
            input  = input(1:end-1,:);
        end
        if mod(h,2)==1
            output = output(:,1:end-1);
            input  = input(:,1:end-1);
        end
        
        % convert to CPU
        if useGPU
            output = gather(output);
        end

        data3result(:,:,i) = im2uint8(output);
    
    end
    
    timed = toc;
   
    end