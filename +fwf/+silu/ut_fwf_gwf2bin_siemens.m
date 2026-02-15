% Unit Test for  fwf.silu.gwf_to_bin and fwf.silu.bin_read
clear

% GENERATE GWF
for i = 1:200
    GWF{1,i} = randn(500,3);
    GWF{2,i} = randn(600,3);
end

% WRITE
[fno, stat, f_norm, sha_w] = fwf.silu.gwf_to_bin(GWF, 'test_gwf2bin_siemens.bin', 1);

% READ
[GWFR, ver, sha_r] = fwf.silu.bin_read(fno);

% PLOT DIFFERENCE
clf
for i = 1:size(GWF,2)
    diff = [(GWF{1,i}/f_norm-GWFR{1,i}); (GWF{2,i}/f_norm-GWFR{2,i})];
    er(i) = sum(diff(:).^2);
end

plot(er)
xlabel('Shot')
ylabel('SSE')
title('Errors in gwf write-to-read process')

disp(['Encoded hash: ' char(sha_w)])
disp(['Read hash   : ' sha_r])