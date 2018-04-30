function show_sample_visual_words(SIFT_results, centers, word_index, N)
    SIZE_crop = 125;
    all_words = [];
    curr_cnt = zeros(1, length(word_index));
    for i = 1 : length(SIFT_results)
        for j = 1 : size(SIFT_results{i}.f, 2)
            vis_word = knnsearch(centers', single(SIFT_results{i}.d(:,j))', 'K', 1);
            I = find(vis_word == word_index, 1, 'first');
            if ~isempty(I)
                if curr_cnt(I) < N
                    curr_cnt(I) = curr_cnt(I) + 1
                    temp_I = imread(SIFT_results{i}.fname);
                    curr_feat = SIFT_results{i}.f(:,j);
                    x = curr_feat(1) - ceil(SIZE_crop/2);
                    y = curr_feat(2) - ceil(SIZE_crop/2);
                    ang1 = curr_feat(3);
                    ang2 = curr_feat(4);
                    x_len = SIZE_crop;
                    y_len = SIZE_crop;
                    temp_img = imcrop(temp_I, [x, y, x_len, y_len]);
                    all_words{I}.images{curr_cnt(I)} = imrotate(imresize(temp_img, 1/ang1), ang2*-180/pi);
                end
            end
        end
        if sum(curr_cnt) == N * length(curr_cnt)
            break;
        end
    end
    
    for i = 1 : length(word_index)
        figure, title(sprintf('Visual Word %d', word_index(i)))
        for j = 1 : min(curr_cnt(i),N)
            subplot(4, 4, j), imagesc(rgb2gray(all_words{i}.images{j}))
            colormap gray
            axis off
        end
    end

end