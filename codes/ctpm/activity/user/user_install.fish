function user_install
    logger 0 "installing $package_name as user level"
    cat src/file_list | tee ~/.ctpm/package_info/$package_name >/dev/null
    echo package_name=$package_name | tee ~/.ctpm/package_info/$package_name.info >/dev/null
    echo package_ver=$package_ver | tee -a ~/.ctpm/package_info/$package_name.info >/dev/null
    echo package_level=$package_level | tee -a ~/.ctpm/package_info/$package_name.info >/dev/null
    for src_file in (cat src/file_list)
        set src_file_dirname (dirname $src_file)
        if test -d $src_file_dirname
        else
            mkdir -p ~/.$src_file_dirname
        end
        mv -f src$src_file ~/.$src_file
    end
end
