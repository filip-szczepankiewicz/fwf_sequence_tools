function b = fwf_gwf_to_bval(gwf, rf, dt)
% function b = fwf_gwf_to_bval(gwf, rf, dt)

btens = fwf_gwf_to_btens(gwf, rf, dt);
b     = trace(btens);