function dvso = shuffleEnergy(dvs, eps)
% function dvso = shuffleEnergy(dvs, eps)
% By FSz
% dvs is the diffusion vector set
% eps is the energy per shot in any unit.

% We split the measurements in two parts of equal size by thresholding on
% the median eps.

m = median(eps);

indh = eps >  m;
indl = eps <= m;

nl = sum(indl);
nh = sum(indh);

if nh > nl
    error('We need to have more (or equal) low-energy than high-energy shots')
end

dvsl = dvs(indl,:);
dvsh = dvs(indh,:);

dvsl = dvsl(randperm(nl)', :);
dvsh = dvsh(randperm(nh), :);

for i = 1:size(dvs, 1)
    
    if isEven(i)
        tmp = dvsh(1,:);
        dvsh(1,:) = [];
    else
        tmp = dvsl(1,:);
        dvsl(1,:) = [];
    end
   
    dvso(i,:) = tmp;
end