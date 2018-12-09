function v = fwf_b64_to_version(b64arr)
% function v = fwf_b64_to_version(b64arr)
% 
% Get the version of the encoded base-64 character array.

uint8arr = matlab.net.base64decode(b64arr);

v = char(uint8arr(5:8));
