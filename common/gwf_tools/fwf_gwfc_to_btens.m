function bt_1x6 = fwf_gwfc_to_btens(gwfc, rfc, dtc, gamma)
% function btl = fwf_gwfc_to_btens(gwfc, rfc, dtc, gamma)

bt_1x6 = zeros(numel(gwfc), 6);

for i = 1:numel(gwfc)
    bt_3x3      = fwf_gwf_to_btens(gwfc{i}, rfc{i}, dtc{i}, gamma);
    bt_1x6(i,:) = bt_3x3([1 5 9 2 3 6]) .* [1 1 1 sqrt(2)*[1 1 1]];
end