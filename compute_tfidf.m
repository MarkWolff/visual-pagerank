%% tfidf
function [V, hist_total] = compute_tfidf(SIFT_results, assignments, centers, files, K)

    %% Get Vd vectors
    hist_total = hist((assignments), [1:K]);
    V = zeros(length(SIFT_results), K);
    
    for j = 1 : length(SIFT_results)
        res = knnsearch(centers', single(SIFT_results{j}.d)', 'K', 1);
        d_hist = hist(reshape(res, 1, numel(res)), 1 : K);
        for i = 1 : K
            V(j,i) = (d_hist(i)/sum(d_hist))*log(length(files)/hist_total(i));
        end
    end

end
