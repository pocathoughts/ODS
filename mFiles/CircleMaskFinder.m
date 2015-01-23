% The point of this file is to try and segment out as much of the OD 
% as humanly possible based of thresholding using imfuse
% This works by creating a circular mask and only counting points within the
% circle that are left after masking it. This has many benefits because it takes away the
% human error of not being able to select all the points, however, this presents an issue
% because the od might be ouside the circle or not enough will be contained

%%%%%%%%%%%%%%%%%%%%%%Reading in Image%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
img1 = imread('10_h.jpg');
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
whyNot = entropyfilt(ln);
figure, imshow(whyNot), title('experiments');

%%%%%%%%%%%%%%%%%%%%%%Start of All the Imfuse shit%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% blurBright = imfuse(brightblurcombine, brightblurcombine, 'falsecolor', 'Scaling','joint','ColorChannels',[1,2,0]);
% figure, imshow(blurBright), title('what happened?');

weirdcombined = imfuse(ln, ln, 'falsecolor', 'Scaling','joint','ColorChannels',[1,2,0]);
figure, imshow(weirdcombined), title('what happened?');

% J = entropyfilt(weirdcombined);
% figure, imshow(J), title('what the hell, why not');
% % combined = imfuse(brightfake, fake2,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
% % figure, imshow(combined), title('red and green mixed channel');
% % 
% % newcombined = imfuse(fake1, combined,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
% % figure, imshow(newcombined), title('first iteration with another red channel fuse');
% 
% % lascom = imfuse(newcombined, fake1,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
% % figure, imshow(lascom), title('fused with redchannel again');
% % 
% % com = imfuse(lascom, brightfake,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
% % % figure, imshow(com), title('mixed with imajusted red channel');
% % 
% % a = imfuse(com, brightfake,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
% % % figure, imshow(com), title('mixed with imajusted red channel');
% % 
% % b = imfuse(a, brightfake,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
% % figure, imshow(b), title('final product');
% 
% supabright = imfuse(brightfake, brightfake,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
% figure, imshow(supabright), title('supabright');
% 
% gimmeSomething = imfuse(brightfake, weirdcombined);
% figure, imshow(gimmeSomething), title('hoping this works');
% weirdShit = entropyfilt(gimmeSomething);
% figure, imshow(weirdShit), title('entropy filt with bright and weird');
% 
% 
% newWeird = imfuse(brightfake, gimmeSomething);
% figure, imshow(newWeird), title('more combos');


%%%%%%%%%%%%%%%%%%%%%%Thresholding Imfuse picture%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mask = BestHSVMask(weirdcombined);
figure, imshow(mask), title('new mask');

%%%%%%%%%%%%%%%%%%%%%%Cleaning up Binary Image%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%Opening to get rid of little specks
firstopenedbw = bwareaopen(mask, 1000);
figure, imshow(firstopenedbw), title('after opening');

%%%%%%%%%%%%%%%%%%%%%%Creating Left adn Right Half to find Side to Be Processed%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
left = firstopenedbw(:, 1 : end/2);
%figure, imshow(left), title('left half');

right = firstopenedbw(:, end/2+1 : end );
%figure, imshow(right), title('right half');

%%%%%%%%%%%%%%%%%%%%%%Getting Parameters for image Splitting%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
leftWhite = 0;
rightWhite = 0;
[maskX, maskY]= size(firstopenedbw);
middle = maskY/2;
disp('this is the size of maskY');
disp(maskY);
disp('this is the size of maskX');
disp(maskX);

%%%%%%%%%%%%%%%%%%%%%%Seeing which side is brighter (SHOULD BE OD SIDE)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for n = 1:maskX-1
    for m = 1:middle-1
        if left(n, m) == 1
            leftWhite = leftWhite + 1;
        end
    end
end
 
for n = 1:maskX-1
    for m = 1:middle-1
        if right(n, m) == 1 

            rightWhite = rightWhite + 1;
        end
    end
end

disp('this is leftwhite count: ');
disp(leftWhite);

disp('this is rightwhite count: ');
disp(rightWhite);


%%%%%%%%%%%%%%%%%%%%%%Start of getting parts to work with for contours%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
selectedMask = zeros(maskX, maskY);
figure, imshow(selectedMask), title('making image with zeros');

%[a, b] = size(img1); 
% because of overused variables a and b are x and y
%%%%%%PROCESSING THE LEFT SIDE OF THE IMAGE
if (leftWhite > rightWhite)
    [rr2 cc2] = meshgrid(1:maskY, 1:maskX);
    CLeft = sqrt((rr2 - 850).^2 + (cc2 - 1100).^2) <= 240;
    figure, imshow(CLeft), title('left mask');
    
    bwContoursL = bwmorph(CLeft,'remove');
    figure, imshow(bwContoursL), title('left edges');
    
    [centerXL, centerYL] = getCenterPoint(CLeft);
    disp('this is center xcoord');
    disp(centerXL);
    disp('this is center ycoord');
    disp(centerYL);
    
    figure, imshow(img1), title('point');
    hold on;
    plot(centerXL, centerYL,'r.','MarkerSize',20);
    
%     [xContL, yContL] = getContourEdgePoints(CLeft);
%     
%     boundaryPoint = max(xContL);
%     
%     radius = abs(boundaryPoint - centerXL);
    
%     rSquared = radius*radius;
%     disp('rSquared is');
%     disp(rSquared);
    selectedMask = mask & CLeft;
    
%     for p = 1:maskX-1
%         for q = 1:maskY-1
%             answer = ((p - centerXL).^2+(q - centerYL).^2);
%             disp(answer);
%             if and((firstopenedbw(p, q) == 1), answer <= rSquared)
%                 disp('did we make it here?');
%                 selectedMask(p, q) = 1;
%             end  
%         end
%     end
    
    figure, imshow(selectedMask), title('final mask');

%%%%%%PROCESSING THE RIGHT SIDE OF THE IMAGE
elseif (rightWhite > leftWhite)
    [rr2 cc2] = meshgrid(1:maskY, 1:maskX);
    CRight = sqrt((rr2 - 2770).^2 + (cc2-1150).^2) <= 240;
    figure, imshow(CRight), title('right mask');
    
%     bwContoursR = bwmorph(CRight,'remove');
%     %bwContoursR = bwperim(CRight);
%     figure, imshow(bwContoursR), title('right edges');
%     
%     [centerXR, centerYR] = getCenterPoint(CRight);
% %     figure, imshow(CRight), title('plot point');
% %     hold on
% %     plot(centerXR, centerYR,'r.','MarkerSize',20);
%     
%     [xContR, yContR] = getContourEdgePoints(CRight);
%     
%     boundaryPoint = max(xContR);
%     radius = abs(boundaryPoint - centerXR);
%     
%     rSquared = radius*radius;
%     disp('this is the size of the radius');
%     disp(rSquared);
    selectedMask = mask & CRight;
   figure, imshow(selectedMask), title('making image with zeros');
    
    disp('made it here!!!!!!!!!');
%     for p = 1:maskX-1
%         for q = 1:maskY-1
%             answer = ((p - centerXR).^2+(q - centerYR).^2);
% %             disp('this is answer value');
% %             disp(answer);
%             %if and((firstopenedbw(p, q) == 1), answer <= rSquared)
% %                 disp('this is the value of p');
% %                 disp(p);
% %                 disp('this is the vale of q');
% %                 disp(q);
%                    
%                 selectedMask(p, q) = 1;
%             end  
%         end
%     end
%     
    figure, imshow(selectedMask), title('final mask');

end


% C = imfuse(img1,img3,'falsecolor','Scaling','joint','ColorChannels',[1 2 0]);
% figure, imshow(C), title('wtf does this do');

% row = [2576, 1020, 956, 950, 968, 2672, 1120,1140, 904, 893, 964, 740, 772, 800, 820, 792, 916, 724, 2916, 2832, 2856, 2752, 2908, 2704, 2764, 2700, 2608, 2696, 2736, 2780, 1270, 1150, 1106,1118, 1178, 1090, 958, 946, 946, 1074, 888, 884, 944, 1040, 936, 2896, 2884];
% column = [1133, 1133, 929, 930, 929, 1017, 925, 1217, 989, 1141, 821, 1045, 1137, 985, 1217, 1161, 1253, 1013, 1253, 969, 1325, 1341, 1013, 985, 1053, 1337, 1329, 1301, 1261, 1241, 1046, 1166,1094, 1006, 942, 842, 902, 1006,1142, 1002, 1069, 1113, 1001, 1277, 929, 1069, 941]
%                    

% disp(size(column));
% disp(size(row));

% newbw = bwselect(mask, row, column, 8);
% figure, imshow(newbw), title('just od');

% se = strel('disk', 5);
% bigger = imdilate(newbw, se);
% figure, imshow(bigger), title('dilated image');

% perim_contours = bwperim(bigger); %gets only outside edge points of what we masked, to make ellipse
% 
% [x_array, y_array] = getContourEdgePoints(perim_contours); %gets us the points of our contour that we need
% mask2 = zeros(size(img1));
% mask(900:end-1000,2600:end-500) = 1;
%   
% figure, imshow(mask2);
% title('Initial Contour Location');

BESTBW = DisplayODContour(img1, rc, selectedMask);
figure, imshow(BESTBW), title('Display od contour return');

%FOR THE SECOND PASS THROUGH WE NEED MUCH FEWER POINTS.... MAKE NEW X Y
%ARRAY
% fRow = [1097, 2716];
% fCol = [992,1069];

% useThis = bwselect(BESTBW, row, column, 8);
% figure,imshow(useThis), title('Use this');

better_Perim = bwperim(BESTBW);
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

% Christine: Look at...
% logical indexing
% find function
% bwmorph