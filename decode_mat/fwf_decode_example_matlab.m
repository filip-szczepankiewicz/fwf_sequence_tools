clear
clf

% This array is stored in the dicom header. Its location and format depends
% on the sequence and version.
b64arr = 'TURNUjAwMDEGAAAAAwAAAAcAAAAAAAAAAwAAAAcAAAAAAAAAAwAAAAcAAAAAAAAAAwAAAAkAAAAAAAAAAwAAAAkAAAAAAAAAAwAAAAkAAAAAAAAAAAAAAAAAgD8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgD8AAAAAAAAAAAAAgL8AAAAAAAAAAAAAAAAAAAAAAACAPwAAAAAAAAAAAAAAAAAAAAAAAAAAMzMzPwAAAAAAAAAAAAAAPwAAgD8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADNzMw9AAAAAAAAAD8AAAAA';

% The version is
v = fwf_b64_to_version(b64arr);

% All the data can be parsed by calling
res = fwf_b64_to_data(b64arr);

% The waveform data is contained in res.data
for i = 1:numel(res.data)
    plot(res.data{i}); hold on
end

% To reconstruct the actual waveform, please se the implementations
% specific to each system and version.