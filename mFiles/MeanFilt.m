% img = imread('01_dr.JPG');
% figure, imshow(img), title('original');
% 
% gray = rgb2gray(img);
% 
% h = fspecial('average', 2);
% filteredImage = filter2(h, gray);
% % filteredImage = conv2(single(img), ones(3)/29);
% % h = 1/3*ones(3,1);
% % H = h*h';
% % % im be your image
% % imfilt = filter2(H,img);
% 
% figure, imshow(filteredImage), title('filtered');

% I = imread('01_dr.jpg');
% figure, imshow(I), title('original');
% H = fspecial('average', [30 30]);
% H2 = fspecial('average', [20 20]);
% I = imfilter(I, H);
% figure, imshow(I), title('blurred');
% red = I(:,:,1);
% figure, imshow(red), title('redchannel');
% 
% i = 3;
% while(i > 0)
% blurGray = imfilter(red, H);
% figure, imshow(blurGray), title('blurred gray');
% i = i - 1;
% end
% 
% bright = adapthisteq(blurGray);
% figure, imshow(bright), title('bright');
% 
% j = 12;
% while(j > 0)
% BB = imfilter(bright, H2);
% 
% j = j - 1;
% end
% 
% figure, imshow(BB), title('blurred bright');

% % 2D FFT Demo
% clc;    % Clear the command window.
% close all;  % Close all figures (except those of imtool.)
% format longg;
% format compact;
% fontSize = 20;
% 
% % Read in image.
% grayImage = imread('badf3.jpg');
% grayImage = rgb2gray(grayImage);
% [rows columns numberOfColorChannels] = size(grayImage)
% if numberOfColorChannels > 1
% 	grayImage = rgb2gray(grayImage);
% end
% % Display original grayscale image.
% subplot(2, 2, 1);
% imshow(grayImage)
% title('Original Gray Scale Image', 'FontSize', fontSize)
% % Perform 2D FFTs
% fftOriginal = fft2(double(grayImage));
% shiftedFFT = fftshift(fftOriginal);
% subplot(2, 2, 2);
% imshow(real(shiftedFFT));
% title('Real Part of Spectrum', 'FontSize', fontSize)
% subplot(2, 2, 3);
% imshow(imag(shiftedFFT));
% title('Imaginary Part of Spectrum', 'FontSize', fontSize)
% % Display magnitude and phase of 2D FFTs
% subplot(2, 2, 4);
% imshow(log(abs(shiftedFFT)),[]);
% colormap gray
% title('Log Magnitude of Spectrum', 'FontSize', fontSize)
% % Enlarge figure to full screen.
% set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
% % Now convolve with a 2D rect function.
% figure;
% rectWidth = 60;
% rectHeight = 20;
% kernel = ones(rectHeight, rectWidth) / (rectHeight * rectWidth);
% % Display it
% subplot(2, 2, 1);
% k = padarray(kernel, [3, 3]); % Just for display.
% imshow(k, []);
% axis on;
% title('Kernel', 'FontSize', fontSize)
% % Enlarge figure to full screen.
% set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
% % Convolve kernel (box filter) with the image
% filteredImage = conv2(double(grayImage), kernel, 'same');
% % Display filtered image.
% subplot(2, 2, 2);
% imshow(filteredImage,[]);
% title('Filtered Image', 'FontSize', fontSize)
% % Perform 2D FFT on the filtered image to see its spectrum.
% % We expect to see a sinc multiplication effect.
% % It should look like the original but with a sinc pattern overlaid on it.
% fftFiltered = fft2(double(filteredImage));
% shiftedFFT = fftshift(fftFiltered);
% % Display magnitude of the 2D FFT of the filtered image.
% subplot(2, 2, 3);
% imshow(log(abs(shiftedFFT)),[]);
% colormap gray
% title('Log Magnitude of Spectrum - Note sinc multiplication', 'FontSize', fontSize)

%  Read an image
  I = imread('01_g.jpg');
 % Convert the image to double data type
  I = im2double(I); 
 % Show the image and select some points with the mouse (at least 4)
 figure, imshow(I); [y,x] = getpts;
%   y=[182 233 251 205 169];
%   x=[163 166 207 248 210];
 % Make an array with the clicked coordinates
  P=[x(:) y(:)];
 % Start Snake Process
  Options=struct;
  Options.Verbose=true;
  Options.Iterations=300;
  [O,J]=Snake2D(I,P,Options);
 % Show the result
  Irgb(:,:,1)=I;
  Irgb(:,:,2)=I;
  Irgb(:,:,3)=J;
  figure, imshow(Irgb,[]); 
  hold on; plot([O(:,2);O(1,2)],[O(:,1);O(1,1)]);
%  