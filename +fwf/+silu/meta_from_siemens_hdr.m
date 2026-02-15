function [xps_l, gps_l] = meta_from_siemens_hdr(h, o_dir)
% function [xps_l, gps_l] = fwf.silu.meta_from_siemens_hdr(h, o_dir)
%
% Code written to be compatible with output from dicm2nii by
% Xiangrui Li (xiangrui.li@gmail.com)
% https://github.com/xiangruili/dicm2nii
%
% h can be header structure or path to a header .mat file.

if nargin < 2
    o_dir = []; % if empty it will not be saved.
else
    if isstring(h)
        h = convertStringsToChars(h);
    end
    
    if ischar(h) && isnumeric(o_dir)
        if o_dir > 0
            o_dir = [fileparts(h) filesep];
        else
            o_dir = [];
        end
    end
end

if ~isstruct(h)
    h = load(h);
    h = h.h;
end



fn_l = fieldnames(h);

for i = 1:numel(fn_l)
    
    clear xps gps
    
    fn = fn_l{i};
    
    %% CREATE XPS
    try
        xps = fwf.silu.xps_from_hdr(h.(fn));
        xps_l.(fn) = xps;
        
        if ~isempty(o_dir)
            xps_fn = [o_dir filesep fn '_xps.mat'];
            save(xps_fn,  'xps')
        end
    catch me
        warning(['Failed to create xps for ' fn]);
        disp(me.message)
    end
    
    %% CREATE GPS
    try
        gps = fwf.silu.gps_from_hdr(h.(fn));
        gps_l.(fn) = gps;
        
        if ~isempty(o_dir)
            gps_fn = [o_dir filesep fn '_gps.mat'];
            save(gps_fn,  'gps')
        end
    catch me
        warning(['Failed to create gps for ' fn]);
        disp(me.message)
    end
    
end


