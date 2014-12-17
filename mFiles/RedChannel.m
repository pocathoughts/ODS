img = imread('gs10.jpg');

redChannel = img(:,:,1);
figure, imshow(redChannel), title('red channel');

% H2 = fspecial('gaussian',50, 50);
% rC = imfilter(redChannel, H2, 'circular');
% figure, imshow(rC), title('eye');

% newrc = histeq(rC);
% figure, imshow(newrc), title('after histeq');

greenChannel = img(:,:,2);
figure, imshow(greenChannel), title('GreenChannel');

for iteration = 1 : 4
  windowSize = iteration+4;
  se = ones(windowSize);
  mask = imclose(greenChannel, se);
  greenChannel = imopen(mask, se);
end

figure, imshow(greenChannel), title('cleaned up greenChannel');

H3 = fspecial('gaussian',5, 5);
gC = imfilter(greenChannel, H3, 'circular');
% figure, imshow(gC), title('green channel blur');

newgc = imadjust(gC);
figure, imshow(newgc), title('imadjust gC');

rgbFundus = cat(3, newgc, gC, gC);
% figure, imshow(rgbFundus), title('fake rgb');



% %# Create the gaussian filter with hsize = [5 5] and sigma = 2
% G = fspecial('gaussian',[50 50],2);
% %# Filter it
% Ig = imfilter(img, G,'same');
% %# Display
% 
% figure,
% imshow(Ig);
% title('Ig');



% B = [];
% B(:,:,2)=Supa_grayfundus;
% B(:,:,3)=Supa_grayfundus;
% B(:,:,1)=Supa_grayfundus;


% hsvfundus = rgb2hsv(rgbImage);
[bw, maskedRGBImage] = BestHSVMask(rgbFundus); 
figure, imshow(bw), title('after hsv mask');

BW2 = bwareaopen(bw, 250);
figure, imshow(BW2), title('after opening');

SE = strel('disk', 10);
BW2 = imdilate(BW2,SE);
figure, imshow(BW2), title('after dilating');

imshow(BW2);
title('after opening function and dilate function');


%%%Figure out how to connect parts that are super close



% figure,
% imshow(rgbFundus);
% title('rgbimage');

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


%we wnat to run the HMRF algorithm twice to get a filled in image

mex BoundMirrorExpand.cpp;
mex BoundMirrorShrink.cpp;



Z = edge(BW2,'canny',0.75);

imwrite(uint8(Z*255),'Fedge.png');

BW2=double(BW2);
BW2=gaussianBlur(BW2,3);
imwrite(uint8(BW2),'Fblurred image.png');

k=2;
EM_iter=10; % max num of iterations
MAP_iter=10; % max num of iterations

tic;
fprintf('Performing k-means segmentation\n');
[X, mu, sigma]=image_kmeans(BW2,k);
imwrite(uint8(X*120),'Finitial labels.png');

[X, mu, sigma]=HMRF_EM(X,BW2,Z,mu,sigma,k,EM_iter,MAP_iter);
imwrite(uint8(X*120),'Funfinal labels.png');

butter = imread('Funfinal labels.png');
butterbw = im2bw(butter);

figure, imshow(butter), title('butter');
figure, imshow(butterbw), title('butterbw');


BUTTER = butterbw & ~bwareaopen(butterbw, 90000);


BUTTER = GetCrop(BUTTER);
figure, imshow(BUTTER), title('BUTTER');

butter = GetCrop(butter);
figure, imshow(butter), title('butter');



DisplayODContour(img, butter, BUTTER);

toc;

BW3 = bwperim(BUTTER); %gets only outside edge points of what we masked, to make ellipse

[x_array, y_array] = getContourEdgePoints(BW3); %gets us the points of our contour that we need

figure,
imshow(BW3);

ellipse_t = fit_ellipse( x_array,y_array);

disp(ellipse_t);

% then you can do: 
if ellipse_t.long_axis > 0 
[X, Y] = calcEllipse(ellipse_t, 360); 
end

newY = backtoBigImage(Y, img);

figure,
imshow(img);
title('diameters');

hold on
% % To plot it the ellipse: 
% plot(X, newY);
% 
% [x, y] = getCenterPoint(butterbw);


% [width_coordV, height_coordV, approx_vertical_diameter] = VerticalDiameter(BUTTER);
% %following methods prepare a circle of best fit
% %to make circles, we need a radius as a parameter
% radius = 0;
% radius = approx_vertical_diameter /2 ;
% disp('this is the radius diameter');
% disp(radius);
% center = cat(2, x, y); %concatenates into one 2D thing
% %the circles may not be as good of a fit as ellipses, but hey its one way
% viscircles(center, radius); 

[width_coord, height_coord, approx_vertical_diameter] = ellipseVertDiameter(X, newY);

% plot([height_coordH(1),height_coordH(2)],[width_coordH(1),width_coordH(2)],'Color','g','LineWidth',2);
imshow(plot([width_coord(1),width_coord(2)],[height_coord(1),height_coord(2)],'Color','g','LineWidth',2));

% %J = imadjust(gray);
% im = im2bw(img);
% 
% imwrite(uint8(BW2),'Fblurred image.png');

% fakergb = cat(3, newgc, gC, gC);
% figure, imshow(fakergb), title('fake rgb');
% 
% hsv = BestHSVMask(fakergb);
% figure, imshow(hsv), title('hsv image');
% cc = bwconncomp(hsv);
% disp(cc);
% % %cimg = GetCrop(img);
% % gimg = rgb2gray(img);
% % figure, imshow(img), title('original');
% % H1 = fspecial('unsharp');
% % 
% % H2 = fspecial('gaussian',150, 150);
% % % newrgb = imfilter(img, H1, 'circular');
% % % text = rangefilt(newrgb);
% % % subplot(4,4,2), imshow(text), title('texture filter');
% % % newestrgb = imfilter(newrgb, H2, 'circular');
% % greenPlane = img(:,:,2);
% % % % grayImage = rgb2gray(newestrgb);
% % figure,imshow(greenPlane), title('greenPlane before');
% % 
% % for iteration = 1 : 10
% %   windowSize = iteration+5;
% %   se = ones(windowSize);
% %   greenPlane = imclose(greenPlane, se);
% %   greenPlane = imopen(greenPlane, se);
% % end
% % 
% % greenPlane = imadjust(greenPlane);
% % figure, imshow(greenPlane), title('after weird for loop');
% % 
% % fakergb = cat(3, greenPlane, greenPlane, greenPlane);
% % 
% % mask = BestHSVMask(fakergb);
% % 
% % figure, imshow(mask), title('mask before loop');
% % 
% % for iteration = 1 : 4
% %   windowSize = iteration+2;
% %   se = ones(windowSize);
% %   mask = imclose(mask, se);
% %   mask = imopen(mask, se);
% % end
% % 
% % figure, imshow(mask), title('mask after loop');
% % 
% % 
% % 
% % 
% % % subplot(4,4,3), imshow(newrgb), title('unsharp filter');
% % % subplot(4,4,4), imshow(newestrgb), title('low pass');
% % % subplot(4,4,5), imshow(greenPlane), title('greenplane');
% % 
% % % betterg = adapthisteq(greenPlane);
% % % figure, imshow(betterg), title('after adathist');
% % % betterg = imfilter(betterg, H1, 'circular');
% % % figure, imshow(betterg), title('unsharp filter after adapthist');
% % % betterg = imadjust(betterg);
% % % figure, imshow(betterg), title('afterimadj');
% % % ref = imread('gs5.jpg');
% % % %ref = ref(:,:,2);
% % % figure,imshow(ref), title('our reference photo');
% % % 
% % % B = imhistmatch(img, ref, 20);
% % % figure, imshow(B), title('after imhistmatch');
% % % fakergb = cat(3, betterg, betterg, betterg);
% % % mask = BestHSVMask(fakergb);
% % % subplot(4,4,9), imshow(mask), title('masked image');
% % % %SE = strel('disk', 8);
% % % BW2 = bwareaopen(mask, 250);
% % % subplot(4,4, 10), imshow(BW2), title('after area open');
% % % % BW2 = imerode(BW2, SE);
% % % BW2dil = imdilate(BW2, SE);
% % % subplot(4,4,11), imshow(BW2dil), title('after dilate');
% % % %edges = bwperim(BW2);
% % % 
% % % s = regionprops(BW2dil, greenPlane, {'Centroid','WeightedCentroid'});
% % % 
% % % subplot(4,4,12),
% % % imshow(img),
% % % title('Weighted (red) and Unweighted (blue) Centroid Locations');
% % % hold on
% % % numObj = numel(s);
% % % for k = 1 : numObj
% % %     plot(s(k).WeightedCentroid(1), s(k).WeightedCentroid(2), 'r*');
% % %     plot(s(k).Centroid(1), s(k).Centroid(2), 'bo');
% % % end
% % % hold off
% % % % 
% % % % % [centersBright, radiiBright, metricBright] = imfindcircles(fakergb,[120 200], ...
% % % % %     'ObjectPolarity','bright','Sensitivity',0.92,'Method','twostage');
% % % % % 
% % % % % disp(length(centers));