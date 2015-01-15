img1 = imread('07_g.jpg');
figure, imshow(img1), title('original');

% [xVal,yVal] = ginput(10);
% disp(xVal);
% disp('this is xVal');
% disp(yVal);
% disp('this is yVal');
% mask = zeros(size(I));
% mask(25:end-25,25:end-25) = 1;
%   
% figure, imshow(mask);
% title('Initial Contour Location');


% img2 = imread('03_h.jpg');
% img3 = imread('05_h.jpg');
grey = rgb2gray(img1);
rc = img1(:,:,1);
grayrc = imadjust(rc);
figure, imshow(grayrc), title('imadjsut on red channel');
imadjgray = imadjust(grey);
gc = img1(:,:,2);

fake1 = cat(3, rc, rc, rc);
fake2 = cat(3, gc, rc, gc);
brightfake = cat(3, grayrc, grayrc, grayrc);
rgbcombine = cat(3, imadjgray, imadjgray, imadjgray);

ln=localnormalize(img1, 150, 5);
figure, imshow(ln), title('stuff to combine');

weirdcombined = imfuse(ln, ln, 'falsecolor', 'Scaling','joint','ColorChannels',[1,2,0]);
figure, imshow(combined), title('what happened?');

% combined = imfuse(brightfake, fake2,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
% figure, imshow(combined), title('red and green mixed channel');
% 
% newcombined = imfuse(fake1, combined,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
% figure, imshow(newcombined), title('first iteration with another red channel fuse');

fakegray = rgb2gray(fake2);
grayrgb = cat(3, fakegray, fakegray, fakegray);

% lascom = imfuse(newcombined, fake1,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
% figure, imshow(lascom), title('fused with redchannel again');
% 
% com = imfuse(lascom, brightfake,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
% % figure, imshow(com), title('mixed with imajusted red channel');
% 
% a = imfuse(com, brightfake,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
% % figure, imshow(com), title('mixed with imajusted red channel');
% 
% b = imfuse(a, brightfake,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
% figure, imshow(b), title('final product');

supabright = imfuse(brightfake, brightfake,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
figure, imshow(supabright), title('supabright');

mask = BestHSVMask(weirdcombined);
figure, imshow(mask), title('new mask');

% firstopenedbw = bwareaopen(mask, 1000);
% figure, imshow(firstopenedbw), title('after opening');

% C = imfuse(img1,img3,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
% figure, imshow(C), title('wtf does this do');

row = [2576, 1020, 956, 950, 968, 2672, 1120,1140, 904, 893, 964, 740, 772, 800, 820, 792, 916, 724, 2916, 2832, 2856, 2752, 2908, 2704, 2764, 2700, 2608, 2696, 2736, 2780, 1270, 1150, 1106,1118, 1178, 1090, 958, 946, 946, 1074, 888, 884, 944, 1040, 936, 2896, 2884];
column = [1133, 1133, 929, 930, 929, 1017, 925, 1217, 989, 1141, 821, 1045, 1137, 985, 1217, 1161, 1253, 1013, 1253, 969, 1325, 1341, 1013, 985, 1053, 1337, 1329, 1301, 1261, 1241, 1046, 1166,1094, 1006, 942, 842, 902, 1006,1142, 1002, 1069, 1113, 1001, 1277, 929, 1069, 941]
                   



disp(size(column));
disp(size(row));

newbw = bwselect(mask, row, column, 8);
figure, imshow(newbw), title('just od');

% se = strel('disk', 5);
% bigger = imdilate(newbw, se);
% figure, imshow(bigger), title('dilated image');

% perim_contours = bwperim(bigger); %gets only outside edge points of what we masked, to make ellipse
% 
% [x_array, y_array] = getContourEdgePoints(perim_contours); %gets us the points of our contour that we need
% mask = zeros(size(I));
% mask(25:end-25,25:end-25) = 1;
%   
% figure, imshow(mask);
% title('Initial Contour Location');


BESTBW = DisplayODContour(img1, rc, newbw);
figure, imshow(BESTBW), title('Display od contour return');

%FOR THE SECOND PASS THROUGH WE NEED MUCH FEWER POINTS.... MAKE NEW X Y
%ARRAY
% fRow = [1097, 2716];
% fCol = [992,1069];

useThis = bwselect(BESTBW, row, column, 8);
figure,imshow(useThis), title('Use this');

better_Perim = bwperim(useThis);
figure, imshow(better_Perim), title('best perimeter');

[xVal, yVal] = getContourEdgePoints(better_Perim);

% figure,
% imshow(perim_contours), title('Perimeter before');

ellipse_t = fit_ellipse( xVal,yVal);

if ellipse_t.long_axis > 0 
[X, Y] = calcEllipse(ellipse_t, 360); 
end

figure,
imshow(img1);
title('diameters');

hold on
plot(X, Y);
[width_coord, height_coord, approx_vertical_diameter] = ellipseVertDiameter(X, Y);

disp('vertical diameter is');
disp(approx_vertical_diameter);
% plot([height_coordH(1),height_coordH(2)],[width_coordH(1),width_coordH(2)],'Color','g','LineWidth',2);
imshow(plot([width_coord(1),width_coord(2)],[height_coord(1),height_coord(2)],'Color','g','LineWidth',2));




% D = imfuse(C, img3,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
% figure, imshow(D), title('combining shit');