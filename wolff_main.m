close all
% clear all

run('C:\VLFEATROOT\vlfeat-0.9.19\toolbox\vl_setup.m');

files = getAllFiles('./flickr/sistinechapel');

%% Add files to matrix of SIFT features
SIFT_results = [];
SIFT_results = addList2Descriptors(SIFT_results, files);

%% K means
K = 6000;
all_descriptors = [];
for i = 1 : length(SIFT_results)
    all_descriptors = [all_descriptors, single(SIFT_results{i}.d)];
end
[centers, assignments] = wolff_kmeans(all_descriptors, K);

%% Match SIFT across each image
SIFT_results = match_SIFT(SIFT_results);

%% Compute tfidf
[V, hist_total] = compute_tfidf(SIFT_results, assignments, centers, files, K);
show_sample_visual_words(SIFT_results, centers, [12, 50, 55], 12);
get_top_N(86, 11, files, hist_total, SIFT_results, assignments, V, all_descriptors);
