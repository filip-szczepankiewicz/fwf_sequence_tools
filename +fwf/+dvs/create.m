function [dvs, wfi] = create(b_list, n_list, i_list, order)
% function [dvs, wfi] = fwf.dvs.create(b_list, n_list, i_list, order)

if nargin < 1
    b_list = [0 1 2 .5  1.5];
    n_list = [6 6 6 10   10];
    i_list = [1 1 1  2    2];
    order  = 1;
end

if nargin < 3 || isempty(i_list)
    i_list = ones(size(b_list));
end

b_max = max(b_list);

%% COMPILE DVS
dvs = [];
wfi = [];
for i = 1:numel(b_list)
    if iscell(n_list)
        cur = n_list{i};
    else
        cur = uvec_elstat(n_list(i));
    end
    cur = cur./sqrt(sum(cur.^2, 2)); % Normalize
    cur = cur * sqrt(b_list(i)/b_max);
    ci  = ones(size(cur,1),1)*i_list(i);

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

    case 2 % Equidistant b-max
        tmp = fwf.dvs.shuffleEqualBmax([dvs wfi]);
        dvs = tmp(:,1:3);
        wfi = tmp(:,4);

    otherwise
        error('Order not supported!')
end