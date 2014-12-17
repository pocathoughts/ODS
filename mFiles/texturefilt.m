img = imread('gs3.jpg');
img = wbalance(img);
[f1,f2] = freqspace(21,'meshgrid');
Hd = ones(21); 
r = sqrt(f1.^2 + f2.^2);
Hd((r<0.1)|(r>0.5)) = 0;
colormap(jet(64))
mesh(f1,f2,Hd)

h = fwind1(Hd,hamming(21));
freqz2(h)
newimg = imfilter(img, h, 'circular');
% h = fwind1(Hd, win)
% img = GetCrop(img);
% H2 = fspecial('gaussian',150, 150);
% k = localnormalize(img, 150, 150);
% grayk = rgb2gray(k);
% figure, imshow(grayk), title('gray k');
% figure, imshow(k), title('localnormalize');
% %newk = wbalance(k);
% 
% entrop = stdfilt(grayk);
% figure, imshow(entrop), title('after entrop filt');
% 
% 
% 
% 
% newestrgb = imfilter(k, H2, 'circular');
% figure, imshow(newestrgb),  title('blurred image');