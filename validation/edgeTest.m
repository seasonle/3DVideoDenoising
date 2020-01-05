
path = 'A:\PROJECTS\2019_11_AIP\data\qrm1ROI\'
fileext = '.png';
imIndex = 283;
rotationAngle = 36.5;

img = imread(fullfile(path,strcat(num2str(imIndex),fileext)));
img = imrotate(img,rotationAngle);



xStart = 710;
xEnd = 725;
edgeData = zeros(1, xEnd-xStart, 'uint32');


yStart = 675;
yEnd = 1180;


for i=0:(xEnd-xStart)-1
    for j=0:(yEnd-yStart)
        value = img(yStart+j,xStart+i);
        edgeData(i+1) = edgeData(i+1)+uint32(value);
    end
end

edgeData = edgeData / double(yEnd-yStart);


x = 0:14;
y = edgeData;

plot(x,y);