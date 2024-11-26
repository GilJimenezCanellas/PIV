function [Hue, diff, sum] = hmmd(ima)

    [rows, cols, ~] = size(ima);

    Hue = zeros(rows, cols);    
    diff = zeros(rows, cols);
    sum = zeros(rows, cols);
    
    for row = 1:rows
        for col = 1:cols
            R = double(ima(row, col, 1));
            G = double(ima(row, col, 2));
            B = double(ima(row, col, 3));
            
            Cmax = max([R, G, B]);
            Cmin = min([R, G, B]);
            diff(row, col) = Cmax - Cmin;
            sum(row, col) = Cmax + Cmin;
            
            if diff(row, col) == 0
                Hue(row, col) = 0;
            elseif Cmax == R
                Hue(row, col) = 60 * mod((G - B) / diff(row, col), 6);
            elseif Cmax == G
                Hue(row, col) = 60 * (((B - R) / diff(row, col)) + 2);
            elseif Cmax == B
                Hue(row, col) = 60 * (((R - G) / diff(row, col)) + 4);
            end
        end
    end
end