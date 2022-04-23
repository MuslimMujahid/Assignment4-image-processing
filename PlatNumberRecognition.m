function PlatNumberRecognition()
    % load image
    f = imread('images/plat_numbers/car3.jpg');
    
    % keep images the same size
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
    
    % Get characters bounding box
    BBs = GetCharactersRect(final);
    
    chars = ['A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I' 'J' 'K' 'L' 'M' 'N' 'O' 'P' 'Q' 'R' 'S' 'T' 'U' 'V' 'W' 'X' 'Y' 'Z' '1' '2' '3' '4' '5' '6' '7' '8' '9' '0'];
    plat_numbers = '';
    for k = 1 : size(BBs, 1)
       BB = BBs(k, :);
       letter = 'A';
       prob = TemplateMatching(imcrop(final, BB), 'A');
       for i = 2 : length(chars)
           char = chars(i);
           curr_prob = TemplateMatching(imcrop(final, BB), char);
           if curr_prob > prob
               letter = char;
               prob = curr_prob;
           end
       end
       
       plat_numbers = strcat(plat_numbers, letter);
    end
    
    % displat plat number recognition result
    disp(plat_numbers);
    
    % draw bounding box
    imshow(f);
    hold on
    for k = 1 : size(BBs, 1)
        rectangle('Position', BBs(k, :), 'EdgeColor', 'r', 'LineWidth', 2); 
    end
end