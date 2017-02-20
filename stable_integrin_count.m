clc;

outFile = '/home/harshmallow/Documents/Lab/Lab files/stuff.ods';

%Select directory and bring in file names
cd /home/harshmallow/Documents/Lab/Lab' files'/07-02-16/MDAlung_C1top/nuc/
fDirectory = '/home/harshmallow/Documents/Lab/Lab files/07-02-16/MDAlung_C1top/nuc';
B1dir = '/home/harshmallow/Documents/Lab/Lab files/07-02-16/MDAlung_C1top/vim';
a6dir = '/home/harshmallow/Documents/Lab/Lab files/07-02-16/MDAlung_C1top/cad';
imgFiles = dir('*.tif');

%%
%Create a numbered array
array = zeros(length(imgFiles),2);
array(:,1) = 1:size(array,1);

%%
store = cell(length(imgFiles), 1);
BWstore = cell(length(imgFiles), 1);
myDS = dataset([],'Varnames',{'MeanIntensity'});
DS_B1 = dataset([],'Varnames',{'MeanIntensity'});
DS_a6 = dataset([],'Varnames',{'MeanIntensity'});

%%label nuclei of each image
for k = 1:length(imgFiles)
    cd /home/harshmallow/Documents/Lab/Lab' files'/07-02-16/MDAlung_C1top/nuc/
    filename = [fDirectory '/' imgFiles(k).name];
    workimg = imread (filename);
    store{k} = workimg;
    thresh = 0.01;
    BWs = im2bw(workimg, thresh);
    %[~, threshold] = edge(workimg, 'sobel');
    %BWs = edge(workimg,'sobel', threshold);
    se90 = strel('line', 1, 90);
    se0 = strel('line',1, 0);
    BWdil = imdilate(BWs,[se90 se0]);
    BWfill = imfill(BWdil, 'holes');
    BWnoborders = imclearborder(BWs, 4);
    BWbig = bwareaopen(BWnoborders, 50);
    BWstore{k} = BWbig;
    %Retrieve cell count, stored in variable 'count'
    [L, count] = bwlabel(BWbig);
    array(k, 2) = count;
    intense = regionprops(L,workimg,'MeanIntensity');
    ds = struct2dataset(intense);
    myDS = vertcat(myDS,ds);
    
    cd /home/harshmallow/Documents/Lab/Lab' files'/07-02-16/MDAlung_C1top/vim/
    imgFiles_B1 = dir('*.tif');
    file_B1 = [B1dir '/' imgFiles_B1(k).name];    
    B1img = imread(file_B1);   
    B1intense = regionprops(L,B1img,'MeanIntensity');  
    ds_B1 = struct2dataset(B1intense);       
    DS_B1 = vertcat(DS_B1,ds_B1);

    
    cd /home/harshmallow/Documents/Lab/Lab' files'/07-02-16/MDAlung_C1top/cad/
    imgFiles_a6 = dir('*.tif');
    file_a6 = [a6dir '/' imgFiles_a6(k).name];   
    a6img = imread(file_a6);
    a6intense = regionprops(L,a6img,'MeanIntensity');
    ds_a6 = struct2dataset(a6intense);
    DS_a6 = vertcat(DS_a6,ds_a6);
end
DS = double(myDS);
dDS_B1 = double(DS_B1);
dDS_a6 = double(DS_a6);
avg = mean(DS);
avg_B1 = mean(dDS_B1);
avg_a6 = mean(dDS_a6);
S = std(DS);
S_B1 = std(dDS_B1);
S_a6 = std(dDS_a6);
all_results = [avg, S, avg_B1, S_B1, avg_a6, S_a6, length(DS), thresh]
csvwrite(outFile,dDS_a6);
%imshow(BWstore{7})
%%
imshow(imadjust(store{4}))
%%
imshow(BWstore{4})
%%
hold on

r = cell(length(imgFiles), 1);
stats = regionprops(BWstore{25}, 'centroid');
centroids = cat(1, stats.Centroid);
for i = 1:length(centroids)
    r{i} = rectangle('Position',[centroids(i,1)-40 centroids(i,2)-40 80 80], 'LineWidth',2, 'EdgeColor', 'm');
end

