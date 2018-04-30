function all_descriptors = addList2Descriptors(all_descriptors, fileList)
    MAX = 150;
    %% Get descriptors for MAX number of images in fileList... add each to all_descriptors
    for i = 1 : size(fileList, 1)
        if i > MAX
            return
        end
        if ~isempty(strfind(fileList{i}, '.rd'))
            MAX = MAX + 1;
            continue
        end
        disp(i)
        I = imread(fileList{i});
        if ndims(I) == 3
            I = rgb2gray(I);
        end
        I = single(I);
        [all_descriptors{end + 1}.f, all_descriptors{end + 1}.d] = vl_sift(I, 'PeakThresh', .2,'verbose');
        all_descriptors{end}.fname = fileList{i};
    end

end