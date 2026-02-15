function conv_gwf2txt(gwf, fn_out, prec)
% function fwf.util.conv_gwf2txt(gwf, fn_out, prec)

if nargin < 3
    switch class(gwf)
        case 'single'
            prec = 6;

        case 'double'
            prec = 12;

        otherwise
            error('GWF must be single or double precision!')
    end
end

format = ['  %0.' num2str(prec) 'f'];

fid = fopen(fn_out, 'w');

% Check if file opening was successful
if fid == -1
    error('Cannot access file for writing: %s', fn_out);
end

% Write the matrix to the file
for i = 1:size(gwf, 1)
    fprintf(fid, [format format format '\n'], gwf(i, 1), gwf(i, 2), gwf(i, 3));
end

% Close the file
fclose(fid);