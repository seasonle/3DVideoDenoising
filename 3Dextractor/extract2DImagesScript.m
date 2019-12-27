%extract2DImages(data3,'y','A:\zuendkerze3\')

dims = {'x','y','z'}

for i=1:3
extract2DImages(data3,dims{i},strcat('A:\qrm2_',num2str(i),'\'));
end
        
    
 