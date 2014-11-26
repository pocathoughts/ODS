figure,
img = imread('fundus2.png');
gray = rgb2gray(img);
J = imadjust(gray);
im = im2bw(img);

[bw, maskedRGBImage] = FMask(img); 
%calls FMask to convert to binary
%uses best thresholds

BW2 = bwareaopen(bw, 130);
%above stuff gets ride of noise, only keeps big chunks of OD

subplot(3,4,1);
imshow(BW2);
title('after');

subplot(3,4,2);
imshow(bw);
title('before');

% just to double check everything is correct
% [x,y]=size(BW2); need height and width
% disp(x);
% disp(y);

%takes our thresholded image and find the center of the OD
[x, y] = getCenterPoint(BW2);
disp(x);

% imagesc(img);
% hold on;
% imshow(plot(x, y,'*')); %shows our detected center

%NOW WE NEED TO MAKE AN ROI AROUND THE OD
%the roi is necessary because the OD finder algorithm used
%is SUPA time intensive so we only wnat it to work on the area we need!





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

subplot(3,4,3);
imshow(butter);
title('butter');

%%%%%%%END OF WORKING SHIT%%%%%%%%%%%%%%%


imbut = im2bw(butter);

Z = edge(imbut, 'canny',0.75);

imwrite(uint8(Z*255),'Fedge.png');

imbut=double(imbut);
imbut=gaussianBlur(imbut,3);
imwrite(uint8(imbut),'Fblurred image.png');

k=2;
EM_iter=10; % max num of iterations
MAP_iter=10; % max num of iterations

tic;
fprintf('Performing k-means segmentation\n');
[X, mu, sigma]=image_kmeans(imbut,k);
imwrite(uint8(X*120),'Finitial labels.png');

[X, mu, sigma]=HMRF_EM(X,imbut,Z,mu,sigma,k,EM_iter,MAP_iter);
imwrite(uint8(X*120),'FINALofallIMAGES.png');

final = imread('FINALofallIMAGES.png');
final = im2bw(final);

subplot(3,4,4);
imshow(final);
title('donezo');


toc;

