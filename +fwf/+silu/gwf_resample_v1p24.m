function [gwf_out, dt_out] = gwf_resample_v1p24(gwf_in, dur_us)
% function [gwf_out, dt_out] = fwf.silu.gwf_resample_v1p24(gwf_in, dur_us)
% Output is single precision because the shape load requires float and 
% this is assumed to be the last operation performed.
% Near carbon copy of c++ code implemented in the v1.24 version of the
% FWF sequence. Also applies to older versions.

GRT_us = int32(10);
dur_us = int32(dur_us);
gwf_in = double(gwf_in);

% Prepare the number of outgoing samples and check if operation is necessary
n_samp_in = int32(size(gwf_in,1));
n_samp_out= dur_us / GRT_us;

time      = double(0);
i_in_time = double(0);
f         = double(0);
i_in      = int32(0);
i         = int32(0);

dt_in	  = double(dur_us-GRT_us) / double(n_samp_in - 1);
dt_out    = double(GRT_us);

for i = int32(0:(n_samp_out-2))
    time			= double(i * GRT_us);
    i_in			= int32(floor( time / dt_in ));
    i_in_time		= double(i_in) * dt_in;
    f				= ( time - i_in_time ) / dt_in;
    gwf_out(i+1,:)	= single((1-f) * gwf_in(i_in+1, :) + f * gwf_in(i_in+2, :));
end

gwf_out(i+2, :)		= single(gwf_in(i_in+2, :));

% 	here, i+1 should be eq to n_samp_out
if ( (i+2) ~= n_samp_out )
    warning('resampling might be weird!');
end
