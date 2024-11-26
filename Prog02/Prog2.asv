%% 1st step: Find the matrix H with the CSD histogram of every image in the database

for i=0:1999
    name = ['./UKentuckyDatabase/ukbench',sprintf('%05d.jpg', i)];
    ima = imread(name);
    
    % Transform to HMMD color space
    [Hue, diff, sum] = hmmd(ima);
    
    % Quantization
    Hmmd_q = quantification(Hue, diff, sum);
    
    % Find CSD histogram
    n_se = 8;
    histogram = CSD(Hmmd_q, n_se);
    
    % Fill H
    H(i+1,:) = histogram;
end

save('H.mat', 'H')

%% 2nd step: Read 'input.txt' and find the array of distances sorted

clear
load('H.mat')

fileID = fopen('./Test/input.txt', 'r');
fileID_output = fopen('./Test/output.txt', 'w');

precision = zeros(10, 20);
recall = zeros(10, 20);

for j = 1:20
    name = fgetl(fileID);
    name_to_find = ['./UKentuckyDatabase/' name];

    ima_to_find = imread(name_to_find);
    
    % Transform to HMMD color space
    [Hue, diff, sum] = hmmd(ima_to_find);
    
    % Quantization
    Hmmd_q = quantification(Hue, diff, sum);
    
    % Find CSD histogram
    n_se = 8;
    histogram = CSD(Hmmd_q, n_se);
    
    indices = (1:2000)';
    distances = zeros(2000, 1);

    for i = 1:2000
        hist_i = H(i,:);
        distances(i) = distance2(hist_i', histogram, 'bhattacharyya');
    end

    [sorted_distances, sorted_indices] = sort(distances);
    
%     figure;
%     subplot(5,1,1);
%     plot(histogram);
%     title('Histogram');
%     hold on;
%     subplot(5,1,2);
%     plot(H(sorted_indices(1), :));
%     title('1');
%     hold on;
%     subplot(5,1,3);
%     plot(H(sorted_indices(2), :));
%     title('2');
%     hold on;
%     subplot(5,1,4);
%     plot(H(sorted_indices(3), :));
%     title('3');
%     hold on;
%     subplot(5,1,5);
%     plot(H(sorted_indices(4), :));
%     title('4');
%     hold off;
    
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