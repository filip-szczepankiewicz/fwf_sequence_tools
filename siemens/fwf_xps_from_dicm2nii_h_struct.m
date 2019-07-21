function xps_l = fwf_xps_from_dicm2nii_h_struct(h, o_dir)
% function xps_l = fwf_xps_from_dicm2nii_h_struct(h)

% Code written to be compatible with output from dicm2nii by
% Xiangrui Li (xiangrui.li@gmail.com)
% http://www.mathworks.com/matlabcentral/fileexchange/42997

if ~isstruct(h)
    h = load(h);
    h = h.h;
end

fn_l = fieldnames(h);

if nargin < 2
    o_dir = [];
end

for i = 1:numel(fn_l)
    
    clear xps
    
    fn = fn_l{i};
    
    try
        xps = fwf_xps_from_siemens_header(h.(fn));
    catch
        warning(['Failed to create xps for ' fn]);
        continue
    end
    
    xps_l.(fn) = xps;
    
    if ~isempty(o_dir)
        xps_fn = [o_dir filesep fn '_xps.mat'];
        save(xps_fn,  'xps')
    end
end