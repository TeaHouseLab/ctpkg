function sys_install
    logger 0 "installing $package_name ver:$package_ver pakver:$package_relver as sys level"
    cat src/file_list | sudo tee /var/lib/ctpm/package_info/$package_name >/dev/null
    echo package_name=$package_name | sudo tee /var/lib/ctpm/package_info/$package_name.info >/dev/null
    echo package_ver=$package_ver | sudo tee -a /var/lib/ctpm/package_info/$package_name.info >/dev/null
    echo package_relver=$package_relver | sudo tee -a /var/lib/ctpm/package_info/$package_name.info >/dev/null
    echo package_packager=$package_packager | sudo tee -a /var/lib/ctpm/package_info/$package_name.info >/dev/null
    echo package_level=$package_level | sudo tee -a /var/lib/ctpm/package_info/$package_name.info >/dev/null
    echo package_unis=$package_unis | sudo tee -a /var/lib/ctpm/package_info/$package_name.info >/dev/null
    if [ -s src/unis_hooks ]
        cat src/unis_hooks | sudo tee /var/lib/ctpm/package_info/$package_name.unis >/dev/null
        sudo chmod +x /var/lib/ctpm/package_info/$package_name.unis
    end
    for src_file in (cat src/file_list)
        set src_file_dirname (dirname $src_file)
        if test -d "$src_file_dirname"
        else
            sudo mkdir -p "$src_file_dirname" &>/dev/null
        end
        if test -e $src_file
            sudo rm -rf $src_file
        end
        sudo mv -f src$src_file $src_file &>/dev/null
    end
    if [ -s hooks ]
        logger 0 "Running install hooks for $package_name"
        sudo chmod +x hooks
        sudo ./hooks
    end
end
