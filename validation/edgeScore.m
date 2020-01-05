function y = edgeScore(path,fileext,sliceStart,sliceEnd,rotationAngle)
%image dimension config
xStart = 710;
xEnd = 725;
edgeData = zeros(sliceEnd-sliceStart+1, xEnd-xStart, 'uint32');

yStart = 675;
yEnd = 1180;

slice = 1;
for sliceIdx = sliceStart : sliceEnd

    img = imread(fullfile(path,strcat(num2str(sliceIdx),fileext)));
    img = imrotate(img,rotationAngle);

    for i=0:(xEnd-xStart)-1
        for j=0:(yEnd-yStart)
            value = img(yStart+j,xStart+i);
            edgeData(slice,i+1) = edgeData(slice,i+1)+uint32(value);
        end
    end
    slice = slice+1;
end

edgeData = edgeData / double(yEnd-yStart);

edgeData = sum(edgeData,1);

edgeData = edgeData / double(sliceEnd-sliceStart);


x = 0:((xEnd-xStart)-1);
y = edgeData;
plot(x,y);  
end


