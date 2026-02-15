function indl = toPartIndex(gwf, rf, ~)
% function indl = fwf.gwf.toPartIndex(gwf, rf, ~)
% By Filip Sz
% Note that this function assumes that the gwf starts and ends with zero!
% Extracts indices where gwf is on between rf-pulses

% numerical threshold for what is considered above zero.
thr = 1e-15;

% make sure rf only has two possible states
rfb = round((rf+1)/2) * 2 - 1;

% find transitions and complete them with first and last index
trans = find(diff(rfb)~=0, 100);

if ~(trans(1)==1)
    trans = [1; trans];
end

if ~(trans(end)==size(gwf,1))
    trans = [trans; size(gwf,1)];
end


for i = 2:numel(trans)
    
    ind = trans(i-1):trans(i);
    tmp = sum(abs(gwf(ind,:)),2);
    
    a   = find(tmp>thr, 1, 'first')-1;
    b   = find(tmp>thr, 1, 'last')+1;
    
    indl{i-1} = (a:b)+trans(i-1)-1;
    
end