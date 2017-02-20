%% Bring in all images
cd('/home/rex4/Rex Storage/Harsha/12-30-16/separation2')
%f = imread('flipped_compressed.tif');
f_top = imread('top_hMEC.tif');
f_bottom = imread('bottom_hMEC.tif');

%% find compression sections
imshow(f,[0,5000])

%% find compression sections

%f_size = imresize(f,2);
imshow(imadjust(f))
section = cell(10,10);
for i = 1:10
    for j = 1:10
        x(i,j) = -1500+1900*(i)-40*(j);
        y(j) =  +1250+1900*(j)-150*(i);
        section{i,j} = [x(i,j) y(j) 1000 1000];
        r(i,j) = rectangle('Position', section{i,j},'linewidth',1, 'EdgeColor', 'm');
    end
end

%%
imshow(imadjust(f_top))


%%
compressed_crop = imcrop(f_top,[0,0,12000,12000]);
imshow(imadjust(compressed_crop))
for i = 1:10
    for j = 1:10
        x(i,j) = -1300+1890*(i)-60 *(j);
        y(j) =  -1600+1900*(j)+105*(i);
        section{i,j} = [x(i,j) y(j) 1000 1000];
        r(i,j) = rectangle('Position', section{i,j},'linewidth',1, 'EdgeColor', 'm');
    end
end

%% Image top sections

imshow(imadjust(f_top))
Blackwhite_top = im2bw(f_top, 0.01);
BWnobord = imclearborder(Blackwhite_top, 4);
BWfinal_top = bwareaopen(BWnobord,20);
[~, count_top] = bwlabel(BWfinal_top);

%% Image bottom sections

imshow(imadjust(f_bottom))
Blackwhite_bottom = im2bw(f_bottom, 0.01);
BWnobord = imclearborder(Blackwhite_bottom, 4);
BWfinal_bottom = bwareaopen(BWnobord,20);
[~, count_bottom] = bwlabel(BWfinal_bottom);

%% test sections
f_crop = imcrop(f_bottom,[4000,4000,1000,1000]);
imshow(imadjust(f_crop))
BW = im2bw(f_crop, 0.01);
BWnobord = imclearborder(BW, 4);
BWfinal_test = bwareaopen(BWnobord, 20);
imshow(BWfinal_test);
[~, count_test] = bwlabel(BWfinal_test);
disp(count_test)

%% test canny
f_crop = imcrop(f_top,[12000,7000,1000,1000]);
%f_crop = f_top;
imshow(imadjust(f_crop))
[~,threshold] = edge(f_crop, 'Canny');
BW = edge(f_crop, 'Canny', threshold);
imshow(BW)
%%
BW2 = bwmorph(BW,'bridge',10);
se90 = strel('line', 1, 90);
se0 = strel('line', 1, 0);
BWdil = imdilate(BW2, [se90 se0]);
BWfill = imfill(BWdil, 'holes');
BWnobord = imclearborder(BWfill, 4);
seD = strel('diamond',1);
BWeroded = imerode(BWnobord, seD);
BWfinal_test = bwareaopen(BWeroded,10);
    %for Hoescht nuclear stain, use eroded threshold 5
    %for Cell tracker green, use eroded threshold 10
imshow(BWfinal_test);
%% display matricies
%[~, count_top] = bwlabel(BWfinal);
disp(count_top)
disp(count_bottom)
