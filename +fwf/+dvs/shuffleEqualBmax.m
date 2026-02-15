function dvs_out = shuffleEqualBmax(dvs)
% function dvs_out = fwf.dvs.shuffleEqualBmax(dvs)
% By Filip Szczepankiewicz
% input is nx3 or nx4 matrix
% Randomize matrix so that all reorganization looses coherency (both low
% b-values and the maxi b-values will be randomly permuted).

% Static random seed
rng(123123123);


% Randomize order and spread out the max b-val samples evenly
numRow = size(dvs,1);

tmp  = dvs(randperm(numRow), :);
norm = sum(tmp(:,1:3).^2, 2);

[~, mini] = min(norm);
maxi = norm > max(norm)*0.9;
    

% remove and store minimum b-value so that it can be placed at the start
mindvs = tmp(mini,:);

tmp(mini, :) = [];
maxi(mini) = [];

mi = round(linspace(2, size(tmp,1), sum(maxi)));

tmp2 = zeros(size(tmp)) * nan;
tmp2(mi, :) = tmp(maxi==1, :);

res = tmp(maxi==0,:);

for i = 1:size(tmp2,1)
    if isnan(tmp2(i,1))
        tmp2(i, :) = res(1,:);
        res(1,:) = [];
    end
end


% Insert the mindir at the beginning of the table
dvs_out = mindvs;
dvs_out = cat(1, dvs_out, tmp2);


% Reset the rng
rng('shuffle');
