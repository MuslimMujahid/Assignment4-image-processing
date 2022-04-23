f = imread('images/pic7.jpg');
f = imresize(f, [400 NaN]);

% convert image to grayscale
g = rgb2gray(f);
% apply median filter
g = medfilt2(g, [3 3]);

% find edges by subtracting result of
% dilate and erode
se = strel('disk', 1);
gd = imdilate(g, se);
ge = imerode(g, se);
gdiff = imsubtract(gd, ge);

% scale values to 0 - 1 range
gdiff = mat2gray(gdiff);
gdiff = conv2(gdiff, [1 1; 1 1]);

% binarize image
B = imbinarize(gdiff);
% eliminate pixels that connected to border
B = imclearborder(B);

% eliminate possible lines that likely not part of the region of interest
er = imerode(B, strel('line', 100, 0));
out1 = imsubtract(B, er);

% filling the regions
F = imfill(out1, 'holes');

% thinning the image
H = bwmorph(F, 'thin', 1);
H = imerode(H, strel('line', 3, 90));

% Selecting all the regions that are of pixel area more than 100
final = bwareaopen(H, 100);

% Find bounding box of remaining objects
Iprops = regionprops(final, 'BoundingBox', 'Image');
BB1 = cat(1, Iprops.BoundingBox);

% remove objects that likely not a character by calculating
% the percentage of non zero pixels in the object image
BB2  = [];
for k = 1 : size(BB1, 1)
    BB = BB1(k, :);
    w = BB(3);
    h = BB(4);
    pixels = w * h;
    non_zero_pixels = nnz(final(BB(2):BB(2)+h, BB(1):BB(1)+w));
    
    if double(non_zero_pixels/pixels) < 0.3
        continue;
    end
    
    c = BB2;
    BB2 = [c; BB];
end

% remove objects that likely not a character by using
% ratio of width and height of the object
BB3 = [];
for k = 1 : size(BB2, 1)
    BB = BB2(k, :);
    w = BB(3);
    h = BB(4);
    ratio = double(h/w);
    
    if not(ratio >= 1 && ratio < 6)
        continue;
    end
    
    c = BB3;
    BB3 = [c; BB];
end

% remove other characters that is not the plat number
% by comparing the height assuming that plat number
% will be alwayst be the tallest obect
height_max = max(BB3(:, 4));
BBfinal = [];
for k = 1 : size(BB3, 1)
    BB = BB3(k, :);
    h = BB(4);
    
    if double(h/height_max) < 0.7
        continue;
    end
    
    c = BBfinal;
    BBfinal = [c; BB];
end

% draw bounding box
imshow(f);
hold on
for k = 1 : size(BBfinal, 1)
    rectangle('Position', BBfinal(k, :), 'EdgeColor', 'r', 'LineWidth', 2); 
end