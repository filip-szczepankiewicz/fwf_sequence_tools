function str_out = fwf_string_truncate(str_in)
% function str_out = fwf_string_truncate(str_in)

if nargin<1 || isempty(str_in)
    str_in = ' ';
end

if ~ischar(str_in)
    error('Input must be a character array!')
end

str_out = str_in;

if length(str_out) > 253
    warning('String is too long! Truncating.')
    str_out(243:256) = ['[TRUNCATED]' sprintf('\n\f\n')];
else
    str_out(254:256) = [sprintf('\n\f\n')];
end
