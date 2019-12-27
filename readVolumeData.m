
zundkerze = 'A:\PROJECTS\2019_11_AIP\dataVol\zuendkerze_01';




qrm1 = 'A:\PROJECTS\2019_11_AIP\data\R000957-QRM_Daniel\QRM_Daniel_01';
qrm2 = 'A:\PROJECTS\2019_11_AIP\data\R000957-QRM_Daniel\QRM_Daniel_02';

qrmFile = 'QRM_Daniel';
qrmDim = 'x133912791371';

data3 = load3D(qrm2,'QRM_Daniel',qrmDim);

%show2DImage(data3,'x',199)