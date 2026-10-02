function txt = conv_gwf2cpp(gwf_a, gwf_b, name, hdr, nsd)
% function txt = fwf.util.conv_gwf2cpp(gwf_a, gwf_b, name, hdr, nsd)


std_prefix = 'm_FWF_HC_';

if ischar(gwf_a) && ischar(gwf_b)
    wfa = mdm_gwf_read(gwf_a);
    wfb = mdm_gwf_read(gwf_b);
    
else
    wfa = gwf_a;
    wfb = gwf_b;
end


txt = {['//' hdr]};


for i = 1:2
    if i == 1
        wf = wfa;
        sfx = 'A';
    else
        wf = wfb;
        sfx = 'B';
    end
    
    txt{end+1} = sprintf('static long  %s%s_%s_n = %d;', std_prefix, name, sfx, size(wf,1));
    
    
    for j = 1:3
        if all(wf(:,j) == 0)
            txt{end+1} = sprintf('static float %s%s_%s_%s [%d] = {0.0};', std_prefix, name, sfx, char(87+j), size(wf,1) );
        else
            wf_str = num2str(wf(:,j)', [' %2.' num2str(nsd) 'f,']);
            
            txt{end+1} = sprintf('static float %s%s_%s_%s [] = {%s};', std_prefix, name, sfx, char(87+j), wf_str(1:end-1)  );
        end
    end
    
    txt{end+1} = ' ';
    
end


for c = 1:numel(txt)
    disp(strrep(txt{c}, '\\', '\'));
end





