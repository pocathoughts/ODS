function newY = backtoBigImage(Y, img)
newY = [];

[x,y]=size(img);

horizontal_middle = x / 2;
top_bound = horizontal_middle - 400;

for idx = 1:numel(Y)
    newY(end + 1) = Y(idx) + top_bound;
end
