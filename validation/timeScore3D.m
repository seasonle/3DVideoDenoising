
%% SCRIPT
[files,path] = uigetfile('*.mat','Select denoising results','MultiSelect', 'on');

resultsName  =[];
resultsTime = [];

for k=1:size(files,2)
    data = load(fullfile(path,files{k}));
    resultsTime = [resultsTime; data.result.time];
    
    [C,matches] = strsplit(files{k},'\d*-\d*','DelimiterType','RegularExpression');
    resultsName = [resultsName;C(1)];
end


[~, I] = sort(resultsTime, 'ascend');


bar(resultsTime(I));
set(gca,'xtick',1:24);
set(gca,'xticklabel',resultsName(I));


%legend(resultsName)
hold off