function BBfinal = GetCharactersRect(B)
    % Find bounding box of remaining objects
    Iprops = regionprops(B, 'BoundingBox', 'Image');
    BB1 = cat(1, Iprops.BoundingBox);

    % remove objects that likely not a character by calculating
    % the percentage of non zero pixels in the object image
    BB2  = [];
    for k = 1 : size(BB1, 1)
        BB = BB1(k, :);
        w = BB(3);
        h = BB(4);
        pixels = w * h;
        non_zero_pixels = nnz(B(BB(2):BB(2)+h, BB(1):BB(1)+w));

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
end