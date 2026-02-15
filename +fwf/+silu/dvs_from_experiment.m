function [dvs, wfi] = dvs_from_experiment(b_list, n_list, i_list, dvs_fn, order, bin_fn)
% function [dvs, wfi] = fwf.silu.dvs_from_experiment(b_list, n_list, i_list, dvs_fn, order, bin_fn)

if nargin < 1
    b_list = [0 1 2 .5  1.5];
    n_list = [6 6 6 10   10];
    i_list = [1 1 1  2    2];

    order = 1;

    dvs_fn = 'test.dvs';
    bin_fn = 'tester.bin';

    [dvs, wfi] = fwf.silu.dvs_from_experiment(b_list, n_list, i_list, dvs_fn, order, bin_fn);
    return
end

if nargin < 6
    bin_fn = [];
end


%% COMPILE DVS
[dvs, wfi] = fwf.dvs.create(b_list, n_list, i_list, order);


%% CREATE HEADER
header = {};

if ~isempty(bin_fn)
    header = {['# FWF_LIBRARY/' bin_fn]};
end

header = {...
    header{1};
    ['# Diffusion vector set'];
    ['# By Filip Szczepankiewicz, ' date];
    ['# For more info: https://github.com/filip-szczepankiewicz/fwf_sequence_tools']};


%% WRITE DVS
fwf.dvs.write.siemens(dvs, dvs_fn, header)

