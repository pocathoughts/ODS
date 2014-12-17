function ls = local_sum(op_image, oval)
%% Returns an image where each pixel is the sum of all surrounding pixels that are 1's in the convmap.

loc_sum = conv2(double(op_image), double(oval));
radius = length(oval)/2;
ls = loc_sum(1:end-(2*radius)+1,1:end-(2*radius)+1);
end