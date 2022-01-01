function sys_install
    logger 0 "installing $package_name ver:$package_ver as sys level"
    sudo sh -c 'echo package_unis=$package_unis > /var/lib/ctpm/package_info/$package_name'
    for src_file in (ls -a src/)
        sudo sh -c 'echo /$src_file >> /var/lib/ctpm/package_info/$package_name'
        sudo mv src/$src_file /
    end
end
