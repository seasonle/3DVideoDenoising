%extract2DImages(data3,'y','A:\zuendkerze3\')

clear;
for j=1:2
    


data3 = loadQRM(j);
dims = {'x','y','z'};

minVal = min(data3(:));
maxVal = max(data3(:));

rangeA = 0;
rangeB = 255;

data3Scaled = scaleData(data3, minVal, maxVal, rangeA, rangeB);

for i=1:3
extract2DImages(data3Scaled,dims{i},strcat('A:\qrm',num2str(j),'_',num2str(i),'\'));
end
        
    
end