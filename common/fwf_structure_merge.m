function out = fwf_structure_merge(in1, in2, mode)
% function out = fwf_structure_merge(in1, in2, mode)

if nargin < 3
    mode = 0;
end

out = in1;

fn = fieldnames(in2);


for i = 1:numel(fn)

    if isfield(out, fn{i})
        switch mode
            case 0 % Do not overwrite
                error(['Field already present (' fn{i} ')! Aborting merge!'])
            case 1 % keep left
                continue
            case 2 % keep right
                % nothing
            otherwise
                error('Mode not recognized!')
        end

        out.(fn{i}) = in2.(fn{i});

    end
end