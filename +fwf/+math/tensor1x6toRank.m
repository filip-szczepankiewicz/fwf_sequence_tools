function rnk = tensor1x6toRank(T)
% function rnk = fwf.math.tensor1x6toRank(T)

rnk = zeros(size(T,1), 1);

for i = 1:size(T,1)
    rnk(i) = rank( tm_1x6_to_3x3(T(i,:)) );
end

end