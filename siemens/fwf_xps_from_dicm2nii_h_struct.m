function xps_l = fwf_xps_from_dicm2nii_h_struct(h, o_dir)
% function xps_l = fwf_xps_from_dicm2nii_h_struct(h)
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
    
    clear xps
    
    fn = fn_l{i};
    
    try
        xps = fwf_xps_from_siemens_hdr(h.(fn));
    catch me
        warning(['Failed to create xps for ' fn]);
        disp(me.message)
        continue
    end
    
    xps_l.(fn) = xps;
    
    if ~isempty(o_dir)
        xps_fn = [o_dir filesep fn '_xps.mat'];
        save(xps_fn,  'xps')
    end
end


