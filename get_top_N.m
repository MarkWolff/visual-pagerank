function get_top_N(N, im_num, files, hist_total, SIFT_results, assignments, V, all_descriptors)

    I = imread(files{im_num});
    figure, imshow(I), rect = getrect;
    close all
    tic
    query_im = imcrop(I, rect);
    rect(3) = rect(3) + rect(1);
    rect(4) = rect(4) + rect(2);
    
    im_features = SIFT_results{im_num}.f;
    
    inrect =    (im_features(1,:) > rect(1)) & ...
                (im_features(1,:) < rect(3)) & ...
                (im_features(2,:) > rect(2)) & ...
                (im_features(2,:) < rect(4));
            
    query_des = single(SIFT_results{im_num}.d(:,inrect));
    query_loc = single(SIFT_results{im_num}.f(:,inrect));
    loc1 = single(SIFT_results{im_num}.f(:,inrect));
    
    query_hist = zeros(1, length(hist_total));
    toc
    tic;
    for i = 1 : size(query_des, 2)
        for d = 1 : size(all_descriptors, 2)
            if query_des(:,i) == all_descriptors(:,d)
                break;
            end
        end
    end
    toc
    
    %% Compute tf-idf for this query
    V_q = zeros(1, length(hist_total));
    for i = 1 : length(hist_total)
        V_q(i) = (query_hist(i)/sum(query_hist))*log(length(files)/hist_total(i));
    end
    for i = 1 : length(SIFT_results)
        scores(i) = sum(V_q .* V(i,:));
    end
    [Y_sorted, ranks] = sort(scores, 'descend');
    toc
    image1 = I;
    good_matches = [];
    bad_matches = [];
    for i = N : -1 : 1
        tic
        image2 = imread(files{ranks(i)});
        
        X1 = SIFT_results{im_num}.matches{ranks(i)}.X1;
        X2 = SIFT_results{im_num}.matches{ranks(i)}.X2;
        
        inrect =    (X1(:,1) > rect(1)) & ...
                    (X1(:,1) < rect(3)) & ...
                    (X1(:,2) > rect(2)) & ...
                    (X1(:,2) < rect(4));
        X1 = X1(inrect,:);
        X2 = X2(inrect,:);
        
        if size(X1,1) >= 4
            try
                [~ ,inlierpoints1,inlierpoints2] = estimateGeometricTransform(X1, X2, 'affine');
                % Check for at least 5 inliers and at least half of points
                % being inliers. 5 is chosen because any 3 points can
                % correspond to an affine transform. The fourth/fifth point
                % must follow this computed transform to verify it.
                if numel(inlierpoints1) > .50*numel(X1) && length(inlierpoints1) >= 5
                    
                    good_matches(end+1) = ranks(i);
                    figure, showMatchedFeatures(image1, image2, inlierpoints1, inlierpoints2, 'montage');
                end
            catch
            end
        end
        toc
    end
end