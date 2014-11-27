img = imread('gs4.jpg');

imshow(img);
title('original image');
gray = rgb2gray(img);
Supa_grayfundus = imadjust(gray);

betterFundus = adapthisteq(Supa_grayfundus);

rgbFundus = cat(3, Supa_grayfundus, Supa_grayfundus, Supa_grayfundus);

[bw, maskedRGBImage] = BestHSVMask(rgbFundus); 

BW2 = bwareaopen(bw, 200);

SE = strel('disk', 10);
BW2 = imdilate(BW2,SE);



figure,

imshow(BW2);
title('binary image');

imshow(img);
title('original image');
hold on,

[width_coordH, height_coordH, approx_horiz_diameter] = HorizontalDiameter(BW2);
[width_coordV, height_coordV, approx_vertical_diameter] = VerticalDiameter(BW2);

plot([height_coordH(1),height_coordH(2)],[width_coordH(1),width_coordH(2)],'Color','g','LineWidth',2)
plot([width_coordV(1),width_coordV(2)],[height_coordV(1),height_coordV(2)],'Color','g','LineWidth',2)

[x, y] = getCenterPoint(BW2);

radius = 0;
radius = approx_vertical_diameter /2 ;

center = cat(2, x, y);


viscircles(center, radius);
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


