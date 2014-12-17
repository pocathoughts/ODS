%%Is this ok or do I need to make one single vector adding everything in?
x_input = [];
y_input = [];
%get training data from 1st good fundus
img4o = imread('TrainingIMG/4.png'); % original image
img4o = imresize(img4o, [660 660]);
img4o = GetCrop(img4o);
im_points4o = img4o(:);
for i = 1:length(im_points4o)
    x_input(end+1) = im_points4o(i);
end
img4bw = imread('TrainingIMG/bw4.png'); % bw image
img4bw = imresize(img4bw, [660 660]);
img4bw = GetCrop(img4bw);
img_points4bw = img4bw(:);
for j = 1:length(img_points4bw)
    y_input(end+1) = img_points4bw(i);
end
%img_4_prop = cat(2, im_points4o, im_points4bw);


%get training data from 2nd good fundus
% img9o = imread('TrainingIMG/9.png'); % original image
% img9o = imresize(img9o, [660 660]);
% im_points9o = img9o(:);
% for k = 1:length(im_points9o)
%     x_input(end+1) = im_points9o(i);
% end
% img9bw = imread('TrainingIMG/bw9.png'); % bw image
% img9bw = imresize(img9bw, [660 660]);
% im_points9bw = img9bw(:);
% for l = 1:length(im_points9bw)
%     y_input(end+1) = im_points9bw(i);
% end
% %img_9_prop = cat(2, im_points9o, im_points9bw);
% 
% %get training data from 3rd good fundus
% img10o = imread('TrainingIMG/10.png'); % original image
% img10o = imresize(img10o, [660 660]);
% im_points10o = img10o(:);
% for m = 1:length(im_points10o)
%     x_input(end+1) = im_points10o(i);
% end
% img10bw = imread('TrainingIMG/bw10.png'); % bw image
% img10bw = imresize(img10bw, [660 660]);
% im_points10bw = img10bw(:);
% for n = 1:length(im_points10bw)
%     y_input(end+1) = im_points10bw(i);
% end
% %img_10_prop = cat(2, im_points10o, im_points10bw);



disp(size(x_input));
disp(size(y_input));

mdl = fitcknn(x_input', y_input');

disp(mdl);
% figure, imshow(img4o), title('original');
% hold on,
% plot([mdl.X, mdl.Y]);
% hold off
% 
hello = mdl.predict(x_input');
figure, imshow(reshape(hello, size(img4o))), title('donezo');
% newimg = double(img4o).*double(mdl.ScoreTransform);
% figure, imshow(newimg), title('newimg');
% im4gray = imread('TrainingIMG/gray4.png'); %grayscale image
% im4gray = imresize(im4gray, [660 660]);
% im_points4gray = im4gray(:);

% img10gray = imread('TrainingIMG/gray10.png'); %grayscale image
% img10gray = imresize(img10gray, [660 660]);
% im_points10gray = img10gray(:);

% img9gray = imread('TrainingIMG/gray9.png'); %grayscale image
% img9gray = imresize(img9gray, [660 660]);
% im_points9gray = img9gray(:);


