function xps = fwf_xps_from_siemens_json(nii_fn)
% function xps = fwf_xps_from_siemens_json(nii_fn)

    function txt = fread_all(txt_fn)
        fid = fopen(txt_fn);
        txt = char(fread(fid, inf, 'char')');
        fclose(fid);
    end

if (nargin == 0)
    error('need to supply file name');
end

% Construct file names
[bp, name, ext] = fileparts(nii_fn);
[~,name] = fileparts(name); % for nii.gz

json_fn = fullfile(bp, [name '.json']);
bval_fn = fullfile(bp, [name '.bval']);
bvec_fn = fullfile(bp, [name '.bvec']);

assert(exist(json_fn, 'file'), 'Did not find json file: %s', json_fn);
assert(exist(bvec_fn, 'file'), 'Did not find bvec file: %s', bvec_fn);
assert(exist(bval_fn, 'file'), 'Did not find bval file: %s', bval_fn);


% Json and create raw waveforms from it
json = jsondecode(fread_all(json_fn));

gamma = json.ImagingFrequency * 1e6 * 2 * pi;

% Load bval and bvec files
b = fread_all(bval_fn);
b = str2num(b)' * 1e6;

n = sqrt(b / max(b));

u = fread_all(bvec_fn);
u = str2num(u)';

ind2 = ones(size(b));

[gwfc, rfc, dtc, ind] = fwf_gwf_list_from_siemens_json(json,gamma,u,n,ind2);


btl = zeros(numel(gwfc), 6);
for i = 1:numel(gwfc)
    bt3x3    = fwf_gwf_to_btens(gwfc{i}, rfc{i}, dtc{i}, gamma);
    btl(i,:) = tm_3x3_to_1x6(bt3x3);
end

xps           = mdm_xps_from_bt(btl);
xps.te        = ones(xps.n, 1) * json.EchoTime;
xps.tr        = ones(xps.n, 1) * json.RepetitionTime;
xps.wf_ind    = ind;

end

