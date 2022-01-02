function sys_install
    logger 0 "installing $package_name ver:$package_ver as sys level"
    cat src/file_list | sudo tee /var/lib/ctpm/package_info/$package_name >/dev/null
    echo package_name=$package_name | sudo tee /var/lib/ctpm/package_info/$package_name.info >/dev/null
    echo package_ver=$package_ver | sudo tee -a /var/lib/ctpm/package_info/$package_name.info >/dev/null
    echo package_level=$package_level | sudo tee -a /var/lib/ctpm/package_info/$package_name.info >/dev/null
    for src_file in (cat src/file_list)
        if test -d "$src_file_dirname"
        else
            sudo mkdir "$src_file_dirname"
        end
        sudo mv -f src$src_file $src_file >/dev/null
    end
end
