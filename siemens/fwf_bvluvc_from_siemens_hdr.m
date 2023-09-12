function [b, u, n] = fwf_bvluvc_from_siemens_hdr(hdr)
% function [b, u, n] = fwf_bvluvc_from_siemens_hdr(hdr)

% Try to find user defined dvs first
csa        = fwf_csa_from_siemens_hdr(hdr);
[dvs, nrm] = fwf_dvs_from_siemens_csa(csa);
seq        = fwf_seq_from_siemens_csa(csa);

if ~isempty(dvs)

    b = [];
    u = [];
    n = [];

    for j = 1:max(seq.avgs_req)

        for i = 1:seq.no_bvals

            if seq.avgs_req(i) >= j
                if seq.bval_req(i) <= 1
                    b = [b; 0];
                    u = [u; [0 0 0]];
                    n = [n; 0];
                else
                    b = [b; nrm.^2 * seq.bval_req(i) * 1e6 ];
                    u = [u; dvs];
                    n = [n; nrm];
                end
            end

        end

    end

    u = u ./ sqrt(sum(u.^2, 2));
    u(isnan(u)) = 0;

    % WIP: This is still not the correct rotation for u (dvs is not rotated with the FOV).

    if max(seq.avgs_req) > 1
        warning('This code is entirely guesswork! If you use multiple avereages, please check the result!')
    end

    % Check that we are in the ballpark
    worst_diff = max(abs(b/1e6-hdr.bval));

    if worst_diff > 100
        error(['Large differences in b-values detected! (' num2str(worst_diff) ' s/mm^2)']);
    elseif worst_diff > 5
        warning(['Slight differences in b-values detected! (' num2str(worst_diff) ' s/mm^2)']);
    end


else % Use bval and bvec exported by the system, which may be slightly wrong!

    try
        b = hdr.bval * 1e6; % s/m2
        u = hdr.bvec;
    catch
        b = hdr.B_value * 1e6; % s/m2
        u = hdr.DiffusionGradientDirection';
    end

    n = sqrt(b/max(b));

end








