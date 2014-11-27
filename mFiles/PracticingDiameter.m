img = imread('gs3.jpg');


bw = im2bw(img);
BW2 = bwareaopen(bw, 50);

figure,
imshow(BW2);
title('binary image');

hold on,

[width_coord, height_coord, approx_vertical_diameter] = VerticalDiameter(BW2);

plot([width_coord(1),width_coord(2)],[height_coord(1),height_coord(2)],'Color','r','LineWidth',2)

% %# read and display image
% img = imread('autumn.tif');
% figure,imshow(img)
% 
% %# make sure the image doesn't disappear if we plot something else
% hold on
% 
% %# define points (in matrix coordinates)
% p1 = [10,100];
% p2 = [100,20];
% 
% %# plot the points.
% %# Note that depending on the definition of the points,
% %# you may have to swap x and y
% plot([p1(2),p2(2)],[p1(1),p2(1)],'Color','r','LineWidth',2)


