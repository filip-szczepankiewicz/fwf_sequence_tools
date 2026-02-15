function b = toBvalue(gwf, rf, dt)
% function b = fwf_gwf_to_bval(gwf, rf, dt)

btens = fwf.gwf.toBtensor(gwf, rf, dt);
b     = trace(btens);