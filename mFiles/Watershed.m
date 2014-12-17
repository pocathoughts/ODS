img = imread('gs2.jpg');
figure,
imshow(img);
title('original image');
gray = rgb2gray(img);
adaptgray = adapthisteq(gray);
imadjgray = imadjust(adaptgray);

rgbcombine = cat(3, imadjgray, imadjgray, imadjgray);

bw = BestHSVMask(rgbcombine);
figure, imshow(bw), title('binary');
% 
% W=wbalance(img);
% 
% figure,
% imshow(W);
% title('color balance');
% 
normalizedGP = localnormalize(img, 100, 100);

figure,
imshow(normalizedGP);
title('please be it');

j = watershed(bw);
figure, imshow(j), title('watershed');
ln = localnormalize(j, 5, 5);
figure, imshow(ln), title('stuff?');
% % 
% greenPlane = img(:, :, 2); %now we have a grayscale image of just the green plane
% 
% figure,
% imshow(greenPlane);
% title('greenPlane of balanced image');
% 
% g = adapthisteq(greenPlane);
% figure,
% imshow(g);
% title('adapteq of W');
% 
% h = imadjust(g);
% figure,
% imshow(h);
% title('imadjest of balanced image');
% 
% rgbofBalanceIMG = cat(3, h, h, h);
% 
% binIMG = BestHSVMask(rgbofBalanceIMG);
% 
% figure,
% imshow(binIMG);
% title('binary img');
% % 
% DL = watershed(img);
% figure,
% imshow(DL);
% title('DL');

% hy = fspecial('sobel');
% hx = hy';
% Iy = imfilter(double(normalizedGP), hy, 'replicate');
% Ix = imfilter(double(normalizedGP), hx, 'replicate');
% gradmag = sqrt(Ix.^2 + Iy.^2);
% figure,
% imshow(gradmag,[]), title('Gradient magnitude (gradmag)')
% 
% L = watershed(gradmag);
% Lrgb = label2rgb(L);
% figure, imshow(Lrgb), title('Watershed transform of gradient magnitude (Lrgb)')
% % figure, 
% imshow(adaptgray);
% title('gray image after adapt');
% 
% figure,
% imshow(imadjgray);
% title('gray image after imadjust');
% 
% 
% greenPlane = img(:, :, 2); %now we have a grayscale image of just the green plane
% %green plane shows better contrast
% 
% figure,
% imshow(greenPlane);
% title('green Plane');
% 
% GPadaptgray = adapthisteq(greenPlane);
% GPimadjgray = imadjust(GPadaptgray);
% 
% figure,
% imshow(GPadaptgray);
% title('adapthisteq on greenPlane image');
% 
% figure,
% imshow(GPimadjgray);
% title('imadjust on greenPlane image');
% 
% normalizedGP = localnormalize(GPimadjgray, 100, 100);
% 
% figure,
% imshow(normalizedGP);
% title('normalized GP');
% 
% rgbGrayIMG = cat(3, greenPlane, greenPlane, greenPlane);
% 
% 
% 
% %not 100 percent sure how its gonna help, but something to mess with
% ln= localnormalize(greenPlane,100,100);
% 
% 
% %newln = adapthisteq(ln);
% %using imadjust on ln doesnt do much same goes for adapthisteq
% % BetterBW = imadjust(ln);
% % 
% % figure,
% % imshow(BetterBW);
% % title('betterbw');
% 
% 
