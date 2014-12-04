%%Is this ok or do I need to make one single vector adding everything in?

%get training data from 1st good fundus
img_4_prop = [];
img4o = imread('TrainingIMG/4.png'); % original image
img4o = imresize(img4o, [660 660]);
im_points4o = img4o(:);
img4bw = imread('TrainingIMG/bw4.png'); % bw image
img4bw = imresize(img4bw, [660 660]);
img_points4bw = img4bw(:);
im4gray = imread('TrainingIMG/gray4.png'); %grayscale image
im4gray = imresize(im4gray, [660 660]);
im_points4gray = im4gray(:);
img_4_prop = cat(3, im_points4o, im_points4bw, im_points4gray);

%get training data from 2nd good fundus
img_9_prop = [];
img9o = imread('TrainingIMG/9.png'); % original image
img9o = imresize(img9o, [660 660]);
im_points9o = img9o(:);
img9bw = imread('TrainingIMG/bw9.png'); % bw image
img9bw = imresize(img9bw, [660 660]);
im_points9bw = img9bw(:);
img9gray = imread('TrainingIMG/gray9.png'); %grayscale image
img9gray = imresize(img9gray, [660 660]);
im_points9gray = img9gray(:);
img_9_prop = cat(3, im_points9o, im_points9bw, im_points9gray);

%get training data from 3rd good fundus
img_10_prop = [];
img10o = imread('TrainingIMG/10.png'); % original image
img10o = imresize(img10o, [660 660]);
im_points10o = img10o(:);
img10bw = imread('TrainingIMG/bw10.png'); % bw image
img10bw = imresize(img10bw, [660 660]);
im_points10bw = img10bw(:);
img10gray = imread('TrainingIMG/gray10.png'); %grayscale image
img10gray = imresize(img10gray, [660 660]);
im_points10gray = img10gray(:);
img_10_prop = cat(3, im_points10o, im_points10bw, im_points10gray);


good_fundus_features = cat(3, img_4_prop, img_9_prop, img_10_prop);

good_data = [1; 0; 1];

fitcknn(good_fundus_features, good_data);
