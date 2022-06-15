function grab
    switch $argv[1]
        case upd
            logger 0 "+ Refreshing ctpm-grab[R] package database"
            if sudo curl --progress-bar -L -o /var/lib/ctpm/world $ctpm_source/list
                logger 1 "- ctpm-grab[R] package database refreshed"
            else
                logger 4 "! Failed to refresh ctpm-grab[R] database, abort"
                exit
            end
        case upg
            grab upd
            logger 0 "+ Checking for update"
            if ls -1qA ~/.ctpm/package_info/ | grep -q .
                for ctpm_package in (cd ~/.ctpm/package_info/ && list_menu *.info | sed 's/.info//g')
                    set package_relver (sed -n '/package_relver=/'p ~/.ctpm/package_info/$ctpm_package.info | sed 's/package_relver=//g')
                    if grep -qs $ctpm_package /var/lib/ctpm/world
                        set package_relver_repo (sed -n /$ctpm_package=/p /var/lib/ctpm/world | sed s/$ctpm_package=//g)
                        if test $package_relver_repo -gt $package_relver
                            set upgrade_package "$ctpm_package $upgrade_package"
                        end
                    end
                end
            end
            if ls -1qA /var/lib/ctpm/package_info/ | grep -q .
                for ctpm_package in (cd /var/lib/ctpm/package_info/ && list_menu *.info | sed 's/.info//g')
                    set package_relver (sed -n '/package_relver=/'p /var/lib/ctpm/package_info/$ctpm_package.info | sed 's/package_relver=//g')
                    if grep -qs $ctpm_package /var/lib/ctpm/world
                        set package_relver_repo (sed -n /$ctpm_package=/p /var/lib/ctpm/world | sed s/$ctpm_package=//g)
                        if test $package_relver_repo -gt $package_relver
                            set upgrade_package "$ctpm_package $upgrade_package"
                        end
                    end
                end
            end
            if test "$upgrade_package" = ""
                logger 0 "√ Your system is up to date"
            else
                logger 0 "* The following packages is upgradable,upgrade them all?[y/N]"
                echo -----------
                echo "$upgrade_package"
                echo -----------
                read -n1 -P "$prefix >>> " upgrade_confirm
                switch $upgrade_confirm
                    case y Y
                        grab $upgrade_package
                    case n N '*'
                        logger 3 "- Aborted by user"
                        exit
                end
            end
        case l
            echo "* found in source:"
            cat /var/lib/ctpm/world
        case s
            echo "* found in source:"
            for ctpm_package in $argv[2..-1]
                grep $ctpm_package /var/lib/ctpm/world
            end
        case '*'
            for ctpm_package in $argv
                logger 0 "+ Grabbing $ctpm_package"
                if curl --progress-bar -L -o /tmp/$ctpm_package.ctpkg $ctpm_source/$ctpm_package.ctpkg
                    if file /tmp/$ctpm_package.ctpkg | grep -q 'gzip compressed'
                    else
                        logger 4 "- The package seems not a ctpkg file,remove and abort,please try to download again and check the package name you typed"
                        rm /tmp/$ctpm_package.ctpkg
                        exit
                    end
                    logger 1 "+ package:$ctpm_package Downloaded,installing..."
                    cd /tmp
                    extract $ctpm_package.ctpkg
                    rm $ctpm_package.ctpkg
                else
                    logger 4 "! package:$ctpm_package failed to download,ignored"
                end
            end
    end
end
