savePath = "A:\PROJECTS\2019_11_AIP\validation\plots";
[files,path] = uigetfile('*.mat','Select denoising results','MultiSelect', 'on');

fps= 10;

for k=1:size(files,2)
    
    data = load(fullfile(path,files{k}));
    data = data.result;

    [C,matches] = strsplit(files{k},'\d*-\d*','DelimiterType','RegularExpression')
    
    if(contains(C{1},".mat"))
       idx = strfind(C{1},".mat");
       C{1} =  C{1}(1:idx-1);
    end
    
    
    createVideo3D(data.data,savePath,C{1},fps);
end