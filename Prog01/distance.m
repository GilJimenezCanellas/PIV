function d = distance(hist1, hist2)
    hist1 = hist1 / sum(hist1);
    hist2 = hist2 / sum(hist2);

    correlation = xcorr(hist1, hist2);

    d = max(correlation);
end

% function d = distance(hist1, hist2, method)
%     hist1 = hist1 / sum(hist1);
%     hist2 = hist2 / sum(hist2);
% 
%     switch method
%         case 'intersection'
%             d = sum(min(hist1, hist2));
%         case 'bhattacharyya'
%             d = -log(sqrt(sum(sqrt(hist1 .* hist2))));
%         case 'chi-squared'
%             d = sum((hist1 - hist2).^2 ./ (hist1 + hist2 + eps));
%         case 'correlation'
%             d = sum((hist1 - mean(hist1)) .* (hist2 - mean(hist2))) / (std(hist1) * std(hist2));
%         otherwise
%             error('Invalid method specified');
%     end
% end