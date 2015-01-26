%%TO DO 
        %make scanning circles over possible regions then do & operator

% The point of this file is to try and segment out as much of the OD 
% as humanly possible based of thresholding using imfuse
% This works by creating a circular mask and only counting points within the
% circle that are left after masking it. This has many benefits because it takes away the
% human error of not being able to select all the points, however, this presents an issue
% because the od might be ouside the circle or not enough will be contained

%%%%%%%%%%%%%%%%%%%%%%Reading in Image%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
img1 = imread('01_dr.jpg');
%figure, imshow(img1), title('original');

%%%%%%%%%%%%%%%%%%%%%%Messing with Grascale Version%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
grey = rgb2gray(img1);
rc = img1(:,:,1);
grayrc = imadjust(rc);
%figure, imshow(grayrc), title('imadjsut on red channel');
imadjgray = imadjust(grey);
gc = img1(:,:,2);


%%%%%%%%%%%%%%%%%%%%%%Combining Grayscale Images into Fake RGB%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fake1 = cat(3, rc, rc, rc);
fake2 = cat(3, gc, rc, gc);
brightfake = cat(3, grayrc, grayrc, grayrc);
rgbcombine = cat(3, imadjgray, imadjgray, imadjgray);
fakegray = rgb2gray(fake2);
grayrgb = cat(3, fakegray, fakegray, fakegray);


%%%%%%%%%%%%%%%%%%%%%%Applying averaging filter%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
H = fspecial('average', [30 30]);
i = 3;
while(i > 0)
blurGray = imfilter(grayrc, H);
i = i - 1;
end
figure, imshow(blurGray), title('blurred gray');

%%%%%%%%%%%%%%%%%%%%%%forming fake RGB with Final Blurred image%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
brightblurcombine = cat(3, blurGray, blurGray, blurGray);


%%%%%%%%%%%%%%%%%%%%%%Using Nomrmalize function%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ln=localnormalize(img1, 150, 5);
%figure, imshow(ln), title('stuff to combine');
% whyNot = entropyfilt(ln);
% figure, imshow(whyNot), title('experiments');

% %%%%%%%%%%%%%%%%%%%%%%Start of All the Imfuse shit%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % blurBright = imfuse(brightblurcombine, brightblurcombine, 'falsecolor', 'Scaling','joint','ColorChannels',[1,2,0]);
% % figure, imshow(blurBright), title('what happened?');
% 
weirdcombined = imfuse(ln, ln, 'falsecolor', 'Scaling','joint','ColorChannels',[1,2,0]);
figure, imshow(weirdcombined), title('what happened?');
% 
% % J = entropyfilt(weirdcombined);
% % figure, imshow(J), title('what the hell, why not');
combined = imfuse(brightfake, fake2,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
figure, imshow(combined), title('red and green mixed channel');
% % % 
% % % newcombined = imfuse(fake1, combined,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
% % % figure, imshow(newcombined), title('first iteration with another red channel fuse');
% % 
% % % lascom = imfuse(newcombined, fake1,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
% % % figure, imshow(lascom), title('fused with redchannel again');
% % % 
% % % com = imfuse(lascom, brightfake,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
% % % % figure, imshow(com), title('mixed with imajusted red channel');
% % % 
% % % a = imfuse(com, brightfake,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
% % % % figure, imshow(com), title('mixed with imajusted red channel');
% % % 
% % % b = imfuse(a, brightfake,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
% % % figure, imshow(b), title('final product');
% % 
supabright = imfuse(brightfake, brightfake,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
figure, imshow(supabright), title('supabright');
% % 
% % gimmeSomething = imfuse(brightfake, weirdcombined);
% % figure, imshow(gimmeSomething), title('hoping this works');
% % weirdShit = entropyfilt(gimmeSomething);
% % figure, imshow(weirdShit), title('entropy filt with bright and weird');
% % 
% % 
% % newWeird = imfuse(brightfake, gimmeSomething);
% % figure, imshow(newWeird), title('more combos');
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%Thresholding Imfuse picture%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mask1 = BestHSVMask(weirdcombined);
figure, imshow(mask1), title('new mask');

mask2 = BestHSVMask(supabright);
figure, imshow(mask2), title('mask2');

%%%%%%%%%%%%%%%%%%%%%%%Creating Left adn Right Half to find Side to Be Processed%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
left = mask1(:, 1 : end/2);
% figure, imshow(left), title('left half');

right = mask1(:, end/2+1 : end );
% figure, imshow(right), title('right half');

% %%%%%%%%%%%%%%%%%%%%%%Getting Parameters for image Splitting%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
leftWhite = 0;
rightWhite = 0;
[maskX, maskY]= size(mask1);
middle = maskY/2;
disp('this is the size of maskY');
disp(maskY);
disp('this is the size of maskX');
disp(maskX);



% %%%%%%%%%%%%%%%%%%%%%%Start of getting parts to work with for contours%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%LeftSides%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[r c] = meshgrid(1:maskY, 1:maskX);
CLeft = sqrt((r - 900).^2 + (c - 1100).^2) <= 200;
% figure, imshow(CLeft), title('left mask');
LeftTest = mask1 & CLeft;



% %%%%%%%%%%%%%%%%%%%%%%RightSides%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[rr cc] = meshgrid(1:maskY, 1:maskX);
CRight = sqrt((rr - 2900).^2 + (cc-1150).^2) <= 200;
figure, imshow(CRight);
RightTest = mask1 & CRight;



% %%%%%%%%%%%%%%%%%%%%%%Seeing which side is brighter (SHOULD BE OD SIDE)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for n = 1:maskX-1
    for m = 1:maskY-1
        if LeftTest(n, m) == 1
            leftWhite = leftWhite + 1;
        end
    end
end
 
for n = 1:maskX-1
    for m = 1:maskY-1
        if RightTest(n, m) == 1 
            rightWhite = rightWhite + 1;
        end
    end
end

disp('this is leftwhite count: ');
disp(leftWhite);

disp('this is rightwhite count: ');
disp(rightWhite);


% %%%%%%PROCESSING THE LEFT SIDE OF THE IMAGE
if (leftWhite > rightWhite)
   [r c] = meshgrid(1:maskY, 1:maskX);
    CLeft = sqrt((r - 900).^2 + (c - 1100).^2) <= 200;
    % figure, imshow(CLeft), title('left mask');
    imageToCompare1 = mask1 & CLeft;

    [r2 c2] = meshgrid(1:maskY, 1:maskX);
    CLeft2 = sqrt((r2 - 600).^2 + (c2 - 1100).^2) <= 200;
    % figure, imshow(CLeft), title('left mask');
    imageToCompare2 = mask1 & CLeft2;

    [r3 c3] = meshgrid(1:maskY, 1:maskX);
    CLeft3 = sqrt((r3 - 700).^2 + (c3 - 1000).^2) <= 200;
    figure, imshow(CLeft3);
    imageToCompare3 = mask1 & CLeft3;

    [r4 c4] = meshgrid(1:maskY, 1:maskX);
    CLeft4 = sqrt((r4 - 700).^2 + (c4 - 1300).^2) <= 200;
    figure, imshow(CLeft4);
    imageToCompare4 = mask1 & CLeft4;

    finalMask = imageToCompare1 | imageToCompare2 | imageToCompare3 | imageToCompare4;
    figure, imshow(finalMask), title('final maskL');
    
    [rF cF] = meshgrid(1:3504, 1:2336);
    Final = sqrt((rF - 970).^2 + (cF - 1130).^2) <= 200;
    figure, imshow(Final), title('the final of all finals');

% %%%%%%PROCESSING THE RIGHT SIDE OF THE IMAGE
elseif (rightWhite > leftWhite)
   [rr cc] = meshgrid(1:maskY, 1:maskX);
    CRight = sqrt((rr - 2900).^2 + (cc-1350).^2) <= 200;
    figure, imshow(CRight);
    itc = mask1 & CRight;

    [rr2 cc2] = meshgrid(1:maskY, 1:maskX);
    CRight2 = sqrt((rr2 - 2770).^2 + (cc2-1150).^2) <= 200;
    % figure, imshow(CRight), title('right mask');
    itc2 = mask1 & CRight2;

    [rr3 cc3] = meshgrid(1:maskY, 1:maskX);
    CRight3 = sqrt((rr3 - 2900).^2 + (cc3-1150).^2) <= 200;
    figure, imshow(CRight3);
    itc3 = mask1 & CRight3;

    [rr4 cc4] = meshgrid(1:maskY, 1:maskX);
    CRight4 = sqrt((rr4 - 2900).^2 + (cc4 - 1000).^2) <= 200;
    figure, imshow(CRight4);
    itc4 = mask1 & CRight4;

    finalMask = itc | itc2 | itc3 | itc4;
    figure, imshow(finalMask), title('finalMaskR');

    [rrF ccF] = meshgrid(1:maskY, 1:maskX);
    Final = sqrt((rrF - 2850).^2 + (ccF - 1130).^2) <= 240;
    Final = Final & finalMask;
    figure, imshow(Final), title('final mask for all time');

   
end


BESTBW = runActiveContour(img1, rc, Final);
figure, imshow(BESTBW), title('Display od contour return');

JUSTOD = bwpropfilt(BESTBW,'perimeter',1);
figure, imshow(JUSTOD), title('should just be od');

% convOD = bwconvhull(JUSTOD);
% figure, imshow(convOD), title('after od seg conv hull');
% 


DisplayODContour(img1, rc, JUSTOD);


better_Perim = bwperim(JUSTOD);
figure, imshow(better_Perim), title('best perimeter');

[xVal, yVal] = getContourEdgePoints(better_Perim);
 
figure,
imshow(better_Perim), title('better Perim');

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

% Christine: Look at...
% logical indexing
% find function
% bwmorph