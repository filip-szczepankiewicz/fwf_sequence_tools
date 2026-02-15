function b = toBvalue(gwf, rf, dt)
% function b = fwf.gwf.toBvalue(gwf, rf, dt)

btens = fwf.gwf.toBtensor(gwf, rf, dt);
b     = trace(btens);