function this_path = goToFolder()
% function this_path = goToFolder()

this_path = fileparts(mfilename('fullpath'));
cd(this_path)
