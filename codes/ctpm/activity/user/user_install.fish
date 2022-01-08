function user_install
    logger 0 "installing $package_name as user level"
    cat src/file_list | tee ~/.ctpm/package_info/$package_name >/dev/null
    echo package_name=$package_name | tee ~/.ctpm/package_info/$package_name.info >/dev/null
    echo package_ver=$package_ver | tee -a ~/.ctpm/package_info/$package_name.info >/dev/null
    echo package_level=$package_level | tee -a ~/.ctpm/package_info/$package_name.info >/dev/null
    echo package_unis=$package_unis | tee -a ~/.ctpm/package_info/$package_name.info >/dev/null
    if [ -s src/unis_hooks ]
        cat src/unis_hooks | tee -a ~/.ctpm/package_info/$package_name.unis >/dev/null
        chmod +x ~/.ctpm/package_info/$package_name.unis
    end
    for src_file in (cat src/file_list)
        set src_file_dirname (dirname $src_file)
        if test -d $src_file_dirname
        else
            mkdir -p ~/.$src_file_dirname &>/dev/null
        end
        mv -f src$src_file ~/.$src_file &>/dev/null
    end
    if [ -s hooks ]
        logger 0 "Running install hooks for $package_name"
        chmod +x hooks
        ./hooks
    end
end
