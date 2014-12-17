figure,
img = imread('gs3.jpg');
imshow(img);
title('original image');

%the following methods serve to
%create a nice grayscale image to threshold
gray = rgb2gray(img);
Supa_grayfundus = imadjust(gray);
betterFundus = adapthisteq(Supa_grayfundus);

%we now recreate a rgb picture of gray values using cat
rgbFundus = cat(3, Supa_grayfundus, Supa_grayfundus, Supa_grayfundus);

%threshold our gray rgb pic with an hsv filter
%strange I know, but through trial and error, seemed to work best
[bw, maskedRGBImage] = BestHSVMask(rgbFundus); 

%following serve to clean up the thresholded image
BW2 = bwareaopen(bw, 250);
SE = strel('disk', 10);
BW2 = imdilate(BW2,SE);

figure,
imshow(BW2);
title('binary image');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%NOW STARTS A CRAZY ASS HMRF%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ALGORIGHTM%%%%%%%%%%%%%%%%%%%%%%%%%%%
mex BoundMirrorExpand.cpp;
mex BoundMirrorShrink.cpp;

%canny edge on binary image
Z = edge(BW2,'canny',0.75); 

%not sure if these images need to be written/saved
imwrite(uint8(Z*255),'Fedge.png');

%Making a blurred image so that we prepare to fill in the gaps
BW2=double(BW2);
BW2=gaussianBlur(BW2,3);
imwrite(uint8(BW2),'Fblurred image.png');

%not really sure, but this is how many times it runs through the k means
%segmentation algorithm
k=2;
EM_iter=10; % max num of iterations
MAP_iter=10; % max num of iterations

tic;
fprintf('Performing k-means segmentation\n');
[X, mu, sigma]=image_kmeans(BW2,k);
imwrite(uint8(X*120),'Finitial labels.png');

[X, mu, sigma]=HMRF_EM(X,BW2,Z,mu,sigma,k,EM_iter,MAP_iter);
imwrite(uint8(X*120),'Funfinal labels.png');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%END of CRAZY ALGORITHM%%%%%%%%%%%%%%%%%%

%we want to use that final filled in picture to get our contours
hold on,

butter = imread('Funfinal labels.png');
butterbw = im2bw(butter);

%Method I made that displays the contours
DisplayODContour(img, butter, butterbw)


figure,
imshow(butter);
title('butter');
toc;

hold off,


%Currently this finds the diameters using the binary image
%less reliable than finding them with the fit ellipse
figure,
imshow(img);
title('diameters');
hold on

[width_coordH, height_coordH, approx_horiz_diameter] = HorizontalDiameter(butterbw);
[width_coordV, height_coordV, approx_vertical_diameter] = VerticalDiameter(butterbw);

plot([height_coordH(1),height_coordH(2)],[width_coordH(1),width_coordH(2)],'Color','g','LineWidth',2);
plot([width_coordV(1),width_coordV(2)],[height_coordV(1),height_coordV(2)],'Color','g','LineWidth',2);

hold off,

%as long as binary image is nicely made, this method should be foolproof
%since it is just simple algebra
[x, y] = getCenterPoint(butterbw);

%following methods prepare a circle of best fit
%to make circles, we need a radius as a parameter
radius = 0;
radius = approx_vertical_diameter /2 ;
center = cat(2, x, y); %concatenates into one 2D thing
%the circles may not be as good of a fit as ellipses, but hey its one way
viscircles(center, radius); 


%following methods are to prepare the parameters for the ellipses
%gets only outside edge points of what we masked, to make ellipse
BW3 = bwperim(butterbw); 
%getContourEdgePoints is just a method I made to get all the detected
%"edges" coordinates to use in the fit ellipse equation
[x_array, y_array] = getContourEdgePoints(BW3); 

figure,
imshow(BW3);
title('this is the edges of the contour');
hold on,

ellipse_t = fit_ellipse(x_array, y_array);

disp(ellipse_t);

% then you can do: 
if ellipse_t.long_axis > 0 
[X, Y] = calcEllipse(ellipse_t, 360); 
end
hold off,

figure,
imshow(img);
title('diameters');
hold on,


%[width_coordH, height_coordH, approx_horiz_diameter] = ellipseHorizDiameter(X, Y)
[width_coordV, height_coordV, approx_vertical_diameter] = ellipseVertDiameter(X, Y)
%imshow(plot([height_coordH(1),height_coordH(2)],[width_coordH(1),width_coordH(2)],'Color','g','LineWidth',2));
imshow(plot([width_coordV(1),width_coordV(2)],[height_coordV(1),height_coordV(2)],'Color','g','LineWidth',2));



hold off,

imagesc(img);
figure,
imshow(img);
hold on,
% To plot it the ellipse: 
plot(X, Y);
hold off,


