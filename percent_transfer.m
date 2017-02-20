%% Number cells on bottom

Bottom = [    35   153   130   158   146   222   312   308   217   270
    37    68   185   221   223   206   245   165   278    81
    42    68    92    44    28    45    40    35    24    39
    47    69   165   225   228   296    43    88    40    72
    29    23    47    55    15    35    34    15    34    39
    35    65   132   317   157   101   113    14    20    21
    33    43    63    76    47    41    14    25    20    30
    90    94   202   265   154   206   214   191   168   147
    11     3    15    32   160    31    30    61    90    56
     2     4    46    63    48   101   135    42    53   125
];

%Bottom_rotate = rot90(Bottom,3)

%order1 = [9 2 3 4 7 8 6 5 1 10];
%order2 = [3 6 1 7 4 5 8 9 2 10];
%order3 = [8 7 4 6 5 2 3 9 1 10];

%Bottom_rearrange = Bottom(order3, order3);
Bottom_total = sum(Bottom);
Bottom_total1 = sum(Bottom_total);
disp(Bottom_total1)

%% Number cells on top

Top =     [           4           3           3           0           0           0           6           2          21          52
           1           3           1           2           9          11           9           4          13          20
           5           7          15          27         281         619         308          57          21          21
           8          14           8         602         789        1763         456         464          15          75
          13          24          50        1431        1697        1813        1317         378          54          67
           7          18         387         774        1393        1647         675         593          43          11
           7          16         268        1162        1385        1425         882         380          40          11
           7           4         522         735         690         789         620         167           5           2
           3           3          17          57         178         198          45           1           5          14
           2          23           4           9           6           2           9           1           5           7];

%Top_rotate = rot90(Top,3)

%Top_rearrange = Top(order3, order3);
Top_total = sum(Top);
Top_total1 = sum(Top_total);
disp(Top_total1)
%% Percent transfer

Total = Top + Bottom;
Transfer = Top./(Total)*100;
score = ceil(Transfer/10);
csvwrite('/home/harshmallow/Documents/Lab/Lab files/data.xlsx',Total)
csvwrite('/home/harshmallow/Documents/Lab/Lab files/data1.xlsx',Transfer)

%% draw solid color squares

N = 100;
x = linspace(0,1,sqrt(N)+1)
y = linspace(0,1,sqrt(N)+1)

% Horizontal grid 
for k = 1:length(y)
  line([x(1) x(end)], [y(k) y(k)])
end

% Vertical grid
for k = 1:length(y)
  line([x(k) x(k)], [y(1) y(end)])
end

axis square

%%
for i = 0:1:0.1
      square = rect(0.1*i,0.1*j,0.1,0.1);
      fill(0.1*i, 0.1*j, 'r');
end
