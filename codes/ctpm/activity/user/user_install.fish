function user_install
    logger 0 "installing $package_name as user level"
    cat src/file_list | tee ~/.ctpm/package_info/$package_name >/dev/null
    echo package_name=$package_name | sudo tee ~/.ctpm/package_info/$package_name.info >/dev/null
    echo package_ver=$package_ver | sudo tee -a ~/.ctpm/package_info/$package_name.info >/dev/null
    echo package_level=$package_level | sudo tee -a ~/.ctpm/package_info/$package_name.info >/dev/null
    for src_file in (cat src/file_list)
        sudo mv -f src$src_file ~/$src_file
    end
end
