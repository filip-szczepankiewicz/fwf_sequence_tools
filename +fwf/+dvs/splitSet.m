function u_l = splitSet(u, n_l)
% function u_l = splitSet(u, n_l)

if size(u,1) < sum(n_l)
    error('Sum of output is larger than availabel number of directions!')
end

u_rest = u;

for i = 1:numel(n_l)

    n_rem = size(u_rest,1)-n_l(i);

    tmp = [];

    for j = 1:n_rem

        t_force = zeros(size(u_rest,1),1);

        for k = 1:size(u_rest,1)
            u_curr   = u_rest(k,:);
            dist     = [sqrt(sum((u_curr-u_rest).^2,2)) sqrt(sum((u_curr+u_rest).^2,2))];
            dist     = min(dist, [], 2);
            force    = 1./dist.^2;
            force(k) = 0;
            t_force(k) = sum(force);
        end

        [~, rem_ind] = max(t_force);

        tmp(j,:) = u_rest(rem_ind, :);
        u_rest(rem_ind, :) = [];
    end

    u_l{i} = u_rest;

    u_rest = tmp;
end

