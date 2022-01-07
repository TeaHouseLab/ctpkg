function extract
    set -lx package_ctpm
    check_environment
    if test -d /tmp/ctpm
    else
        mkdir /tmp/ctpm
    end
    if [ -w /tmp/ctpm ]
    else
        logger 4 '/tmp/ctpm is not accessable to this user,abort'
    end
    for package_ctpm in $argv
        if test -e $package_ctpm
        else
            logger 4 "$package_ctpm not found,abort"
            exit
        end
        cp $package_ctpm /tmp/ctpm
        cd /tmp/ctpm
        logger 0 'Extracting the package'
        tar xf $package_ctpm
        set -lx package_name (sed -n '/package_name=/'p ctpm_pkg_info | sed 's/package_name=//g')
        set -lx package_ver (sed -n '/package_ver=/'p ctpm_pkg_info | sed 's/package_ver=//g')
        set -lx package_level (sed -n '/package_level=/'p ctpm_pkg_info | sed 's/package_level=//g')
        set -lx package_unis (sed -n '/package_unis=/'p ctpm_pkg_info | sed 's/package_unis=//g')
        switch $package_level
            case user
                user_install
            case sys
                sys_install
        end
        cd ..
        rm -rf ctpm
        logger 0 Processed
    end
end
