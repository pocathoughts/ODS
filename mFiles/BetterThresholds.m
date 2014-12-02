img = imread('gs7.jpg');
figure,
imshow(img);
title('original image');
gray = rgb2gray(img);
adaptgray = adapthisteq(gray);
imadjgray = imadjust(adaptgray);

figure, 
imshow(adaptgray);
title('gray image after adapt');

figure,
imshow(imadjgray);
title('gray image after imadjust');


greenPlane = img(:, :, 2); %now we have a grayscale image of just the green plane
%green plane shows better contrast

figure,
imshow(greenPlane);
title('green Plane');

GPadaptgray = adapthisteq(greenPlane);
GPimadjgray = imadjust(GPadaptgray);

figure,
imshow(GPadaptgray);
title('adapthisteq on greenPlane image');

figure,
imshow(GPimadjgray);
title('imadjust on greenPlane image');

normalizedGP = localnormalize(GPimadjgray, 100, 100);

figure,
imshow(normalizedGP);
title('normalized GP');

rgbGrayIMG = cat(3, greenPlane, greenPlane, greenPlane);



%not 100 percent sure how its gonna help, but something to mess with
ln= localnormalize(greenPlane,100,100);


%newln = adapthisteq(ln);
%using imadjust on ln doesnt do much same goes for adapthisteq
% BetterBW = imadjust(ln);
% 
% figure,
% imshow(BetterBW);
% title('betterbw');


figure,
imshow(ln);
title('ln');

Supa_grayfundus = imadjust(gray);

betterFundus = adapthisteq(Supa_grayfundus);