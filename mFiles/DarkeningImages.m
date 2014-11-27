img = imread('gs9.jpg');
%imshow(img);
%title('original image');
gray = rgb2gray(img);
Supa_grayfundus = imadjust(gray);

betterFundus = adapthisteq(Supa_grayfundus);

rgbFundus = cat(3, Supa_grayfundus, Supa_grayfundus, Supa_grayfundus);

[bw, maskedRGBImage] = BestHSVMask(rgbFundus); 

BW2 = bwareaopen(bw, 280);

%newmap = brighten(Supa_grayfundus, -.7 );

SE = strel('disk', 10);
BW2 = imdilate(BW2,SE);

figure,
imshow(BW2);
title('binary image');

figure,
imshow(img);
title('original image');
hold on,

[width_coordH, height_coordH, approx_horiz_diameter] = HorizontalDiameter(BW2);
[width_coordV, height_coordV, approx_vertical_diameter] = VerticalDiameter(BW2);

plot([height_coordH(1),height_coordH(2)],[width_coordH(1),width_coordH(2)],'Color','g','LineWidth',2);
plot([width_coordV(1),width_coordV(2)],[height_coordV(1),height_coordV(2)],'Color','g','LineWidth',2);

[x, y] = getCenterPoint(BW2);

radius = 0;
radius = approx_vertical_diameter /2 ;

center = cat(2, x, y); %concatenates into one 2D thing


viscircles(center, radius); %plots the circles, isnt best way, but hey, its a way
hold off,

BW3 = bwperim(BW2); %gets only outside edge points of what we masked, to make ellipse

[x_array, y_array] = getContourEdgePoints(BW3); %gets us the points of our contour that we need


ellipse_t = fit_ellipse( x_array,y_array);

disp(ellipse_t);

% then you can do: 
if ellipse_t.long_axis > 0 
[X, Y] = calcEllipse(ellipse_t, 360); 
end

imagesc(img);
figure,
imshow(img);
hold on,
% To plot it the ellipse: 
plot(X, Y);
hold off,

figure,
imshow(BW3);
title('edges');
