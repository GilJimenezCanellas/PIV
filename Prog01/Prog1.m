for i=0:1999
    name = ['./UKentuckyDatabase/ukbench',sprintf('%05d.jpg', i)];
    ima = imread(name);
    ima = im2gray(ima);
    H(i+1,:) = imhist(ima);
end

%%
mesh(H);
axis('tight');
%%
save('H.mat', 'H') 

clear
load('H.mat')

name_to_find = ['./UKentuckyDatabase/ukbench00018.jpg'];
ima_to_find = imread(name_to_find);
ima_to_find = im2gray(ima_to_find);
ima_hist_to_find = imhist(ima_to_find);

max_d = -Inf;
min_index = 0;

for i = 1:2000
    hist_i = H(i,:);
    d = distance(hist_i, ima_hist_to_find);
    if d > max_d
        max_d = d;
        min_index = i;
    end
end

closest_image_name = ['./UKentuckyDatabase/ukbench', sprintf('%05d.jpg', min_index)];
closest_image = imread(closest_image_name);

subplot(1,2,1)
imshow(ima_to_find)
title('Image to find')

subplot(1,2,2)
imshow(closest_image)
title('Closest Image')

%%
save('H.mat', 'H') 

clear
load('H.mat')

fileID = fopen('./Test/input.txt', 'r');
name = fgetl(fileID);
fclose(fileID);

name_to_find = ['./UKentuckyDatabase/' name];

ima_to_find = imread(name_to_find);
ima_to_find_gray = im2gray(ima_to_find);
ima_hist_to_find = imhist(ima_to_find_gray);

% distances = zeros(2000, 1);
indices = (1:2000)';

for i = 1:2000
    hist_i = H(i,:);
    distances(i) = distance2(hist_i, ima_hist_to_find', 'd2');
end
% distances = pdist2(H, ima_hist_to_find', 'hamming');

[sorted_distances, sorted_indices] = sort(distances);

figure;
subplot(3, 5, 3)
imshow(ima_to_find)
title('Input Image')

for i = 1:10
    subplot(3, 5, i+5);
    index = sorted_indices(i)-1;
    image_name = ['./UKentuckyDatabase/ukbench', sprintf('%05d.jpg', index)];
    image = imread(image_name);
    imshow(image);
    title(['Distance: ' num2str(sorted_distances(i))]);
end

%%
save('H.mat', 'H') 

clear
load('H.mat')

fileID = fopen('./Test/input.txt', 'r');
fileID_output = fopen('./Test/output_prova.txt', 'w');

precision = zeros(10, 20);
recall = zeros(10, 20);

for j = 1:20
    name = fgetl(fileID);

    name_to_find = ['./UKentuckyDatabase/' name];

    ima_to_find = imread(name_to_find);
    ima_to_find_gray = im2gray(ima_to_find);
    ima_hist_to_find = imhist(ima_to_find_gray);

    % distances = zeros(2000, 1);
    indices = (1:2000)';

    for i = 1:2000
        hist_i = H(i,:);
        distances(i) = distance2(hist_i, ima_hist_to_find', 'd2');
    end
    % distances = pdist2(H, ima_hist_to_find', 'hamming');

    [sorted_distances, sorted_indices] = sort(distances);
    
    fprintf(fileID_output, ['Retrieved list for query image ' name '\n']);
    for i = 1:10
        index = sorted_indices(i)-1;
        image_name = ['ukbench', sprintf('%05d.jpg', index)];
        fprintf(fileID_output, '%s\n', image_name);
    end
    fprintf(fileID_output, '\n');
    
    % Evaluate precision and recall
    number = regexp(name_to_find, '\d+', 'match');
    number = str2double(number);

    pos = mod(number, 4);
    tp = 0;

    for i = 1:10
        switch pos
            case 0
                if (sorted_indices(i)-1 == number || sorted_indices(i)-1 == number+1 || sorted_indices(i)-1 == number+2 || sorted_indices(i)-1 == number+3)
                    tp = tp + 1;
                end
            case 1
                if (sorted_indices(i)-1 == number-1 || sorted_indices(i)-1 == number || sorted_indices(i)-1 == number+1 || sorted_indices(i)-1 == number+2)
                    tp = tp + 1;
                end
            case 2
                if (sorted_indices(i)-1 == number-2 || sorted_indices(i)-1 == number-1 || sorted_indices(i)-1 == number || sorted_indices(i)-1 == number+1)
                    tp = tp + 1;
                end
            case 3
                if (sorted_indices(i)-1 == number-3 || sorted_indices(i)-1 == number-2 || sorted_indices(i)-1 == number-1 || sorted_indices(i)-1 == number)
                    tp = tp + 1;
                end
        end
        precision(i, j) = tp/i;
        recall(i, j) = tp/4;
    end
    
end

precision_means = mean(precision, 2);
recall_means = mean(recall, 2);

figure;
plot(recall_means, precision_means, '-o');
xlabel('Recall');
ylabel('Precision');
title('Precision-Recall Curve');
xlim([0, 1]);
ylim([0, 1]);

fclose(fileID);

%%
number = regexp(name_to_find, '\d+', 'match');
number = str2double(number);

pos = mod(number, 4);

precision = zeros(10, 1);
recall = zeros(10, 1);
tp = 0;

for i = 1:10
    switch pos
        case 0
            if (sorted_indices(i)-1 == number || sorted_indices(i)-1 == number+1 || sorted_indices(i)-1 == number+2 || sorted_indices(i)-1 == number+3)
                tp = tp + 1;
            end
        case 1
            if (sorted_indices(i)-1 == number-1 || sorted_indices(i)-1 == number || sorted_indices(i)-1 == number+1 || sorted_indices(i)-1 == number+2)
                tp = tp + 1;
            end
        case 2
            if (sorted_indices(i)-1 == number-2 || sorted_indices(i)-1 == number-1 || sorted_indices(i)-1 == number || sorted_indices(i)-1 == number+1)
                tp = tp + 1;
            end
        case 3
            if (sorted_indices(i)-1 == number-3 || sorted_indices(i)-1 == number-2 || sorted_indices(i)-1 == number-1 || sorted_indices(i)-1 == number)
                tp = tp + 1;
            end
    end
    precision(i) = tp/i;
    recall(i) = tp/4;
end

figure;
plot(recall, precision, '-o');
xlabel('Recall');
ylabel('Precision');
title('Precision-Recall Curve');
xlim([0, 1]);
ylim([0, 1]);
