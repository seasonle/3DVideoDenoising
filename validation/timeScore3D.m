
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
set(gca, 'YScale', 'log')
ylabel("seconds");
title("Runtime for denoising a 1339x1279x126 volume");

ax = gca;
ax.FontSize = 19; 
xlabel('Edge pixel','FontSize',40)
ylabel('Pixel value','FontSize',40)

xAX = get(gca,'XAxis');
set(xAX,'FontSize', 22)

yAX = get(gca,'YAxis');
set(yAX,'FontSize', 30)


xlabel('Denoising method','FontSize',40)
ylabel('Runtime in seconds','FontSize',40)

ax = gca;
ax.TitleFontSizeMultiplier = 1.5;

%legend(resultsName)
hold off