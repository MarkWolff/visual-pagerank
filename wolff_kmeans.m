function [centers, assignments] = wolff_kmeans(descriptors, K)

num_dims = size(descriptors, 1);
num_obs =  size(descriptors, 2);
max_iters = 50;
max_loc = max(descriptors(:));
descriptors = single(descriptors);

%% Initialize center locations
centers = randi([0, max_loc], num_dims, K);


%% Repeat until convergence...
assignments = [];

for i = 1 : max_iters
    fprintf('KMeans iteration: %d/%d\n', i, max_iters);
    %% Assign each observation to nearest center
    for j = 1 : size(descriptors, 2) % Loop through because it will be quicker than replicating descriptors' 3rd Dim to match K 
        temp_des = repmat(descriptors(:,j), [1, K]);
        dists = (temp_des - centers).^2;
        dist = sqrt(sum(dists, 1));
        assignments(j) = find(dist == min(dist), 1);
    end
    
    %% Shift each center to center of mass of its contained observations
    for j = 1 : K
        old_centers(:,j) = centers(:, j);
        if isempty(find(assignments == j))
            centers(:,j) = randi([0, max_loc], num_dims, 1);
        else
            centers(:,j) = round(mean(descriptors(:, assignments == j), 2));
        end
    end
    
    fprintf('Total center movement = %d pixels\n', sum(old_centers(:) - centers(:)));
    %% Finish only if centers don't change (or if we exceed maximum num of iterations)
    if old_centers == centers
        return
    end
end


end