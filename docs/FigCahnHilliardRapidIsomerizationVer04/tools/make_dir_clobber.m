function make_dir_clobber(dirpath)
%MAKE_DIR_CLOBBER Ensures a clean directory exists at `dirpath`
% WARNING: This function deletes existing contents without prompt.

if exist(dirpath, 'dir')
    rmdir(dirpath, 's');
end

mkdir(dirpath);
end


