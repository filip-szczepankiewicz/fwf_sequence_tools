% Unit Test for fwf_gwf2bin_siemens and fwf_bin2gwf_siemens
clear

% GENERATE GWF
for i = 1:200
    GWF{1,i} = randn(500,3);
    GWF{2,i} = randn(600,3);
end

% WRITE
[fno, stat, f_norm] = fwf_gwf2bin_siemens(GWF, 'test_gwf2bin_siemens.bin', 1);

% READ
GWFR = fwf_bin2gwf_siemens(fno);

% PLOT
clf
for i = 1:size(GWF,2)
    diff = [(GWF{1,i}/f_norm-GWFR{1,i}); (GWF{2,i}/f_norm-GWFR{2,i})];
    er(i) = sum(diff(:).^2);
end

plot(er)
xlabel('Shot')
ylabel('SSE')
title('Errors in gwf write-to-read process')