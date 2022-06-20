function extract
    set -lx recudir (pwd)
    set -lx package_ctpm
    if test -d /tmp/ctpm
    else
        mkdir /tmp/ctpm
    end
    if [ -w /tmp/ctpm ]
    else
        logger 4 'x /tmp/ctpm is not accessable to this user,abort'
    end
    for package_ctpm in $argv
        if test -e $package_ctpm
        else
            logger 4 "x $package_ctpm not found,abort"
            exit
        end
        tar xf $package_ctpm -C /tmp/ctpm
        cd /tmp/ctpm
        logger 0 '-> Extracted package'
        set -lx package_name (sed -n '/package_name=/'p ctpm_pkg_info | sed 's/package_name=//g')
        set -lx package_ver (sed -n '/package_ver=/'p ctpm_pkg_info | sed 's/package_ver=//g')
        set -lx package_relver (sed -n '/package_relver=/'p ctpm_pkg_info | sed 's/package_relver=//g')
        set -lx package_packager (sed -n '/package_packager=/'p ctpm_pkg_info | sed 's/package_packager=//g')
        set -lx package_level (sed -n '/package_level=/'p ctpm_pkg_info | sed 's/package_level=//g')
        set -lx package_unis (sed -n '/package_unis=/'p ctpm_pkg_info | sed 's/package_unis=//g')
        switch $package_level
            case user
                user_install
            case sys
                sys_install
            case h '*'
                logger 4 "x Unknown package level,abort"
                exit
        end
        cd $recudir
        rm -rf ctpm
        logger 0 "√ Processed"
    end
end
