img = imread('gs10.jpg');

%Lets the channels we care about
%red
RC = img(:,:,1);
%green
GC = img(:,:,2);

%let's get rid of some more blood vessels in the red image
H3 = fspecial('gaussian',5, 5);
RC = imfilter(RC, H3, 'circular');


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


BW2 = bwareaopen(bw, 250);
figure, imshow(BW2), title('after opening');

SE = strel('disk', 10);
BW2 = imdilate(BW2,SE);
figure, imshow(BW2), title('after dilating');

imshow(BW2);
title('after opening function and dilate function');
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



Z = edge(BW2,'canny',0.89);

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

DisplayODContour(img, butter, butterbw)

toc;
BUTTER = imdilate(butterbw, se);
BUTTER = butterbw & ~bwareaopen(butterbw, 90000);

figure, imshow(BUTTER), title('BUTTER');



% %J = imadjust(gray);
% im = im2bw(img);
% 
% imwrite(uint8(BW2),'Fblurred image.png');