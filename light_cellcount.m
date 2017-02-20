%% Bring in all images
cd('/home/rex4/Rex Storage/Harsha/02-18-17/2.5hr')
f = imread('compressed.tif');
f_top = imread('top.tif');
f_bottom = imread('bottom.tif');
order1 = [9 2 3 4 7 8 6 5 1 10];
order2 = [2 6 3 7 4 5 8 9 1 10];
order3 = [8 7 4 6 5 2 3 9 1 10];
order4 = [7 8 5 3 9 2 4 6 1 10];
order5 = [5 9 6 2 8 4 7 3 1 10];
order6 = [3 4 9 7 5 6 2 8 1 10];
order = order6;
%% find compression sections

imshow(f,[0,5000])

%% find compression sections
% This is the norm, but if we used the other striping formats, use the
% sections below (12x12 or 10x12)
%f_size = imresize(f,2);
imshow(imadjust(f))
section = cell(10,10);
for i = 1:10
    for j = 1:10
        x(i,j) = -1500+1890*(i)-20*(j);
        y(j) =  -2000+1900*(j)+100*(i);
        section{i,j} = [x(i,j) y(j) 1000 1000];
        r(i,j) = rectangle('Position', section{i,j},'linewidth',1, 'EdgeColor', 'm');
    end
end
%% find compression sections for 12x12

%f_size = imresize(f,2);
imshow(imadjust(f))
section = cell(12,12);
for i = 1:12
    for j = 1:12
        x(i,j) = -850+1570*(i)+15*(j);
        y(j) =  380+1580*(j)-110*(i);
        section{i,j} = [x(i,j) y(j) 1000 1000];
        r(i,j) = rectangle('Position', section{i,j},'linewidth',1, 'EdgeColor', 'm');
    end
end

%% find compression sections for 10x12

%f_size = imresize(f,2);
imshow(imadjust(f))
section = cell(10,12);
for i = 1:10
    for j = 1:12
        x(i,j) = -1100+1890*(i)+30*(j);
        y(j) =  -80+1580*(j)-55*(i);
        section{i,j} = [x(i,j) y(j) 1000 1000];
        r(i,j) = rectangle('Position', section{i,j},'linewidth',1, 'EdgeColor', 'm');
    end
end
%% for 12x12
compressed_crop = imcrop(f,[0,0,10000,10000]);
imshow(imadjust(compressed_crop))
for i = 1:12
    for j = 1:12
        x(i,j) = -1100+1890*(i)+10*(j);
        y(j) =  -80+1580*(j)-40*(i);
        section{i,j} = [x(i,j) y(j) 1000 1000];
        r(i,j) = rectangle('Position', section{i,j},'linewidth',1, 'EdgeColor', 'm');
    end
end
%%
imshow(imadjust(f_top))


%%
compressed_crop = imcrop(f,[0,0,12000,12000]);
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
cropped_top = cell(10,10);
Blackwhite_top = cell(10,10);
BWfinal_top = cell(10,10);
count_top = cell(10,10);
for i = 1:10
    for j = 1:10
        r(i,j) = rectangle('Position', section{i,j},'linewidth',1, 'EdgeColor', 'm');
        cropped_top{i,j} = imcrop(f_top, section{i,j});
        Blackwhite_top{i,j} = im2bw(cropped_top{i,j}, 0.04);
        BWfinal_top{i,j} = bwareaopen(Blackwhite_top{i,j},20);
        [~, count_top{i,j}] = bwlabel(BWfinal_top{i,j});
    end
end
A = cell2mat(count_top);
Unordered_top =transpose(A);


%% Image bottom sections

imshow(imadjust(f_bottom))
cropped_bottom = cell(10,10);
Blackwhite_bottom = cell(10,10);
BWfinal_bottom = cell(10,10);
count_bottom = cell(10,10);
for i = 1:10
    for j = 1:10
        r(i,j) = rectangle('Position', section{i,j},'linewidth',1, 'EdgeColor', 'm');
        cropped_bottom{i,j} = imcrop(f_bottom, section{i,j});
        Blackwhite_bottom{i,j} = im2bw(cropped_bottom{i,j}, 0.04);
        BWfinal_bottom{i,j} = bwareaopen(Blackwhite_bottom{i,j},20);
        [~, count_bottom{i,j}] = bwlabel(BWfinal_bottom{i,j});
    end
end
B = cell2mat(count_bottom);
Unordered_bottom =transpose(B);
%Ordered_bottom = Unordered_bottom(order, order); %tell it the order of your proteins

%% test sections
imshow(imadjust(cropped_top{7,9}))
BW = im2bw(cropped_top{7,9}, 0.04);
BWnobord = imclearborder(BW, 4);
BWfinal = bwareaopen(BWnobord, 20);
imshow(BWfinal);

%% display matricies
disp(Unordered_top)
%disp(Ordered_top)
disp(Unordered_bottom)
%disp(Ordered_bottom)