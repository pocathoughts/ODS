img = imread('gs1.jpg');

imshow(img);
title('original image');
gray = rgb2gray(img);
Supa_grayfundus = imadjust(gray);

betterFundus = adapthisteq(Supa_grayfundus);

rgbFundus = cat(3, Supa_grayfundus, Supa_grayfundus, Supa_grayfundus);

[bw, maskedRGBImage] = BestHSVMask(rgbFundus); 

BW2 = bwareaopen(bw, 250);

SE = strel('disk', 10);
BW2 = imdilate(BW2,SE);

figure,
imshow(BW2);
title('binary image');

% figure,
% imshow(img);
% title('original image');
% hold on,



BW3 = bwperim(BW2); %gets only outside edge points of what we masked, to make ellipse

[x_array, y_array] = getContourEdgePoints(BW3); %gets us the points of our contour that we need

figure,
imshow(BW3);

ellipse_t = fit_ellipse( x_array,y_array);

disp(ellipse_t);

% then you can do: 
if ellipse_t.long_axis > 0 
[X, Y] = calcEllipse(ellipse_t, 360); 
end

figure,
imshow(img);
title('diameters');
hold on

[width_coordV, height_coordV, approx_vertical_diameter] = ellipseVertDiameter(X, Y)
% plot([height_coordH(1),height_coordH(2)],[width_coordH(1),width_coordH(2)],'Color','g','LineWidth',2);
imshow(plot([width_coordV(1),width_coordV(2)],[height_coordV(1),height_coordV(2)],'Color','g','LineWidth',2));

hold off,


imagesc(img);
figure,
imshow(img);
hold on,
% To plot it the ellipse: 
plot(X, Y);

% ellipse_t = fit_ellipse( x,y,axis_handle )
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


