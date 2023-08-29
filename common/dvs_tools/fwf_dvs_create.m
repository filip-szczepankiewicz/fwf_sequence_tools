function [dvs, wfi] = fwf_dvs_create(b_list, n_list, i_list, order)
% function [dvs, wfi] = fwf_dvs_create(b_list, n_list, i_list, order)

if nargin < 1
    b_list = [0 1 2 .5  1.5];
    n_list = [6 6 6 10   10];
    i_list = [1 1 1  2    2];
    order  = 1;
end

b_max = max(b_list);

%% COMPILE DVS
dvs = [];
wfi = [];
for i = 1:numel(b_list)
    cur = uvec_elstat(n_list(i));
    cur = cur./sqrt(sum(cur.^2, 2)); % Normalize
    cur = cur * sqrt(b_list(i)/b_max);
    ci  = ones(n_list(i),1)*i_list(i);

    dvs = [dvs; cur];
    wfi = [wfi; ci];
end


%% REORDER
switch order
    case 0 % do nothing

    case 1 % random
        rni = randperm(size(dvs,1));
        dvs = dvs(rni,:);
        wfi = wfi(rni,:);

    otherwise
        error('Order not supported!')
end