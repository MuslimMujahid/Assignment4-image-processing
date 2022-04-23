function sim = TemplateMatching(image, letter)
    chars_dir = 'images/characters';
    chars_path = dir(fullfile(chars_dir, letter, '*.bmp'));
    [rows, cols] = size(image);
    
    sim = 0;
    for k = 1 : length(chars_path)
        fullpath = fullfile(chars_dir, letter, chars_path(k).name);
        f = imread(fullpath);
        r = imresize(f, [rows cols]);
        
        match = 0;
        for i = 1 : rows
            for j = 1 : cols
                if (image(i, j) == r(i, j))
                    match = match + 1;
                end
            end
        end
        
        curr_sim = double(match/(rows*cols));
        if curr_sim > sim
            sim = curr_sim;
        end
    end
end