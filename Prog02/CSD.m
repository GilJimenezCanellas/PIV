function total_acumulated_images = CSD(image_input, window_size)
   
%     scale_factor = 2;
%     quantization = 8;

%     [M, N, ~] = size(image_input);
%     M_new = floor(M / scale_factor);
%     N_new = floor(N / scale_factor);
% 
%     indices = false(M, N); 
%     indices(1:scale_factor:M, 1:scale_factor:N) = true; 
% 
%     image_downsampled = image_input(indices); 
%     image_downsampled = reshape(image_downsampled, M_new, N_new);
% 
%     image_downsampled = image_downsampled * ((255 - 1) / (quantization - 1)); 
%     image_downsampled = round(image_downsampled); 
%     image_downsampled = max(0, min(255, image_downsampled)); 

    img_size = size(image_input);
    total_acumulated_images = zeros(128, 1);
    actual_image = zeros(128, 1);

    for i = 1:img_size(1) - window_size + 1
        for j = 1:img_size(2) - window_size + 1
            for k = i:(i + window_size - 1)
                for l = j:(j + window_size - 1)
                    actual_image(image_input(k, l) + 1) = 1; 
                end
            end
            total_acumulated_images = total_acumulated_images + actual_image; 
            actual_image = zeros(128, 1);
        end
    end
end
