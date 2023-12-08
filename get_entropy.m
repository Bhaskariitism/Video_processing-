function [entropy_code] = get_entropy (entropy_raw_matrix, n, dim1, dim2)
% go by tiles in loops to extract shortened entropy codes (without
% zeros on the end)
step = n-1; % poor stuff for entropy coding iterations, should be avoided
tile = entropy_raw_matrix(1:1+step, 1:1+step);
entropy_code = tile(1:find(tile(:),1,'last'));
for i=step+2:step+1:dim1-step
    for j=step+2:step+1:dim2-step
        tile = entropy_raw_matrix(i:i+step, j:j+step);
        entropy_code = cat(2, entropy_code, tile(1:find(tile(:),1,'last')));
    end
end