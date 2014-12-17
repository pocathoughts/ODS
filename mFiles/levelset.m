img = imread('gs3.jpg');
radius = 80;

ln=local_mean_diff(img,50,1);
figure, imagesc(ln), title('making shit happen');