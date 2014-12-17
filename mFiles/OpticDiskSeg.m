img = imread('gs10.jpg');

gray = rgb2gray(img);
Supa_grayfundus = imadjust(gray);

betterFundus = adapthisteq(Supa_grayfundus);

rgbFundus = cat(3, Supa_grayfundus, Supa_grayfundus, Supa_grayfundus);

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

SE = strel('disk', 10);
SE2 = strel('disk', 10);

bw = imerode(bw, SE2);

bw2 = GetCrop(bw);

BW2 = bwareaopen(bw2, 250);

BW2 = imdilate(BW2,SE);

imshow(BW2);
title('after opening function');

figure,
imshow(betterFundus);
title('adaptive hist');

figure,
imshow(Supa_grayfundus);
title('supergray img');

figure,
imshow(maskedRGBImage);
title('hsvfundus');

figure,
imshow(rgbFundus);
title('rgbimage');

%we wnat to run the HMRF algorithm twice to get a filled in image

mex BoundMirrorExpand.cpp;
mex BoundMirrorShrink.cpp;



Z = edge(BW2,'canny',0.85);

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

subplot(3,4,3);
imshow(butter);
title('butter');

%BUTTER = butterbw & ~bwareaopen(butterbw, 9000);
figure, imshow(BUTTER), title('after hug algo and opening');

BUTTER = GetCrop(BUTTER);
figure, imshow(BUTTER), title('after crop');
buttercrop = GetCrop(butter);
figure, imshow(buttercrop), title('butter after crop');
DisplayODContour(img, butter, BUTTER);

toc;

BW3 = bwperim(BUTTER); %gets only outside edge points of what we masked, to make ellipse

[x_array, y_array] = getContourEdgePoints(BW3); %gets us the points of our contour that we need

% CH = bwconvhull(BW3);
% figure, imshow(CH), title('convhull');

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
% To plot it the ellipse: 
% plot(X, newY);
% 
% [x, y] = getCenterPoint(butterbw);


% [width_coordV, height_coordV, approx_vertical_diameter] = VerticalDiameter(butterbw);
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

% hold off,
% 
% 
% imagesc(img);
% figure,
% imshow(img);
% hold on,
% % To plot it the ellipse: 
% plot(X, Y);
% 
% %# plot the points.
% %# Note that depending on the definition of the points,
% %# you may have to swap x and y
% plot([p1(2),p2(2)],[p1(1),p2(1)],'Color','r','LineWidth',2)

% %J = imadjust(gray);
% im = im2bw(img);
% 
% imwrite(uint8(BW2),'Fblurred image.png');