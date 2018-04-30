function SIFT_results = match_SIFT(SIFT_results)

    for i = 1 : length(SIFT_results)
        disp(i)
        for j = 1 : length(SIFT_results)
            [matches, ~] = vl_ubcmatch(...
                single(SIFT_results{i}.d), single(SIFT_results{j}.d));
            SIFT_results{i}.matches{j}.X1 = single(SIFT_results{i}.f(1:2,matches(1,:)))';
            SIFT_results{i}.matches{j}.X2 = single(SIFT_results{j}.f(1:2,matches(2,:)))';
%             I1 = imread(SIFT_results{i}.fname);
%             I2 = imread(SIFT_results{j}.fname);
%             pause(0.1)
%             figure(1), showMatchedFeatures(I1, I2, SIFT_results{i}.matches{j}.X1, SIFT_results{i}.matches{j}.X2, 'montage');
        end

    end

end