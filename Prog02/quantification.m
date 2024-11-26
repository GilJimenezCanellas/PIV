function Hmmd_q = quantification(Hue, diff, sum)
    
    Hmmd_q = zeros(256,256);

    for i = 1:256
        for j = 1:256
            if (diff(i, j) < 6)
                Hmmd_q(i, j) = floor(sum(i, j)/(510/16));
            elseif (diff(i, j) >= 6 && diff(i, j) < 20)
                Hmmd_q(i, j) = (floor(sum(i, j)/(510/4)) + 16) + 4 * floor(Hue(i, j)/(360/4));
            elseif (diff(i, j) >= 20 && diff(i, j) < 60)
                Hmmd_q(i, j) = (floor(sum(i, j)/(510/4)) + 32) + 4 * floor(Hue(i, j)/(360/8));
            elseif (diff(i, j) >= 60 && diff(i, j) < 110)
                Hmmd_q(i, j) = (floor(sum(i, j)/(510/4)) + 64) + 4 * floor(Hue(i, j)/(360/8));
            elseif (diff(i, j) >= 110 && diff(i, j) < 255)
                Hmmd_q(i, j) = (floor(sum(i, j)/(510/4)) + 96) + 4 * floor(Hue(i, j)/(360/8));
            end
        end
    end
end