I = imread('gs1.png');
 % Convert the image to double data type
 gP = I(:,:,2);
 gP = imadjust(gP);
 H3 = fspecial('gaussian',15, 15);
 gP = imfilter(gP, H3, 'circular');
 
 
 % Show the image and select some points with the mouse (at least 4)
 %figure, imshow(I); [y,x] = getpts;
 rgb = cat(3, gP, gP, gP);
 mask = BestHSVMask(rgb);
 se = strel('disk', 4);
figure, imshow(mask), title('after threshold');


bw = mask & ~bwareaopen(mask, 90000);
figure, imshow(bw), title('after reverse open');
bw = imerode(bw, se);
figure, imshow(bw), title('after eroding');
 
 
 CH = bwconvhull(bw);
figure, imshow(CH), title('convex hull');

Z = edge(CH,'canny',0.85);
 [x_array, y_array] = getContourEdgePoints(Z);
 
 
%  ID = im2double(I); 
%  Make an array with the clicked coordinates
%   P=[y_array(:) x_array(:)];
%  Start Snake Process
%   Options=struct;
%   Options.Verbose=true;
%   Options.Iterations=300;
%   [O,J]=Snake2D(ID,P, Options);
%  Show the result
%     I = Irgb;
%    Irgb(:,:,1)=ID;
%    Irgb(:,:,2)=ID;
%    Irgb(:,:,3)=J;
% figure, imshow(ID); 
% hold on; plot([O(:,2);O(1,2)],[O(:,1);O(1,1)]);
 


% Img = imread('gs7.jpg');
% % iterNum = 100;
% RC = Img(:,:,1);
% figure, imshow(RC), title('red channel');
% %green
% GC = Img(:,:,2);
% figure, imshow(GC), title('green channel');
% 
% %let's get rid of some more blood vessels in the red image
% H3 = fspecial('gaussian',20, 20);
% RC = imfilter(RC, H3, 'circular');
% figure, imshow(RC), title('after blur');
% 
% GC = imadjust(GC);
% figure, imshow(GC), title('imadjusted green channel');
% 
% rgbFundus = cat(3, RC, GC, GC);
% rgbFundus = imfilter(rgbFundus, H3, 'circular');
% figure, imshow(rgbFundus), title('RC RC GC');
% 
% bw = BestHSVMask(rgbFundus);
% figure, imshow(bw), title('after mask');
% 
% se = strel('disk', 4);
% bw = imerode(bw, se);
% 
% 
% bw = bw & ~bwareaopen(bw, 90000);
% 
% figure, imshow(bw), title('after erode');
% 
% 
% CH = bwconvhull(bw);
% figure, imshow(CH), title('convex hull');
% 
% Z = edge(CH,'canny',0.85);
% [x_array, y_array] = getContourEdgePoints(Z);
% 
% P = [x_array(:) y_array(:)];
% rgbFundus = im2double(rgbFundus);
% [newP, J]=Snake2D(rgbFundus, P);
% disp(length(newP));
% figure, imshow(J), title('what is this?');
% u = demo_acwe(Img, iterNum);
% figure, imagesc(u), title('things');