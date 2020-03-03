%% CONFIG
%sliceStart= 203;
%sliceEnd = 283;

sliceStart= 25;
sliceEnd = 125;

rotAngle = 36.5;

xStart = 710;
xEnd = 725;
yStart = 675;
yEnd = 1180;

%% SCRIPT
[files,path] = uigetfile('*.mat','Select denoising results','MultiSelect', 'on');

resultsName  =[];
resultsX = [];
resultsY = [];


for k=1:size(files,2)
    
    data = load(fullfile(path,files{k}));
    data = data.result;

    
    
    edgeData = zeros(sliceEnd-sliceStart+1, xEnd-xStart, 'uint32');
    
    slice = 1;
    for sliceIdx = sliceStart : sliceEnd
        
        img = data.data(:,:,sliceIdx);
        img = imrotate(img,rotAngle);
        
        for i=0:(xEnd-xStart)-1
            for j=0:(yEnd-yStart)
                value = img(yStart+j,xStart+i);
                edgeData(slice,i+1) = edgeData(slice,i+1)+uint32(value);
            end
        end
        slice = slice+1;
        imshow(img);

    end
    
    edgeData = edgeData / double(yEnd-yStart);
    
    edgeData = sum(edgeData,1);
    
    edgeData = edgeData / (double(sliceEnd-sliceStart)+1.0);
    
    
    x = 0:((xEnd-xStart)-1);
    y = edgeData;
    
    
    [C,matches] = strsplit(files{k},'\d*-\d*','DelimiterType','RegularExpression')
    
    resultsName = [resultsName;C(1)];
    resultsX = [resultsX;x];
    resultsY = [resultsY;y];

    %plot(x,y);
    
end

resultsName{1} = 'original data';
colors = distinguishable_colors(size(files,2));

optimalData = [0 0 0 0 0 0 255 255 255 255 255 255 255 255 255];


%% all data plot 
x = 0:14;
for i=1:size(files,2)
    plot(x,resultsY(i,:),'LineWidth',2,'Color',colors(i,:));
    hold on
end

hold on
plot(x,optimalData,'LineWidth',2,'Color',colors(2,:));

ax = gca;
ax.FontSize = 28; 
xlabel('Edge pixel','FontSize',28)
ylabel('Pixel value','FontSize',28)
ylim([0 255])
legend(resultsName)
legend("Location","southoutside","Orientation","horizontal","NumColumns",10)

hold off


%% original data plot

plot(x,resultsY(1,:),'LineWidth',2,'Color',colors(1,:));
hold on
plot(x,optimalData,'LineWidth',2,'Color',colors(2,:));

ax = gca;
ax.FontSize = 28; 
xlabel('Edge pixel','FontSize',28)
ylabel('Pixel value','FontSize',28)
ylim([0 255])
legend("original data", "optimal data")
legend("Location","southoutside","Orientation","horizontal")

hold off


