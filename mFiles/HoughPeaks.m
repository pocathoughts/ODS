% I  = imread('gs8.jpg');
% I = rgb2gray(I);
% BW = edge(imrotate(I,50,'crop'),'canny');
% [H,T,R] = hough(BW);
% P  = houghpeaks(H,2);
% imshow(H,[],'XData',T,'YData',R,'InitialMagnification','fit');
% xlabel('\theta'), ylabel('\rho');
% axis on, axis normal, hold on;
% plot(T(P(:,2)),R(P(:,1)),'s','color','white');
% I = imread('gs5.jpg');
% I = rgb2gray(I);
% I = imadjust(I);
% radius = 160; 
% centers = imfindcircles(I,radius)
% disp(centers);