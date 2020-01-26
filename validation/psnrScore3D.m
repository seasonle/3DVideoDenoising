[files,path] = uigetfile('*.mat','Select denoising results','MultiSelect', 'on');



load('A:\PROJECTS\2019_11_AIP\data\qrm2.mat');

data3 = data3(:,:,280:282);

resultsName  =[];
resultsPSNR = [];

for k=1:size(files,2)
    data = load(fullfile(path,files{k}));
    data = data.result.data;
    
    resultsPSNR = [resultsPSNR; psnr(data,data3)];

    [C,matches] = strsplit(files{k},'\d*-\d*','DelimiterType','RegularExpression');
    resultsName = [resultsName;C(1)];
end

[~, I] = sort(resultsPSNR, 'descend');

bar(resultsPSNR(I));
set(gca,'xtick',1:size(resultsName,1));
set(gca,'xticklabel',resultsName(I));

%legend(resultsName)
hold off