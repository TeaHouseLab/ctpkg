function grab
    switch $argv[1]
        case upd
            if sudo curl -s -L -o /var/lib/ctpm/world $ctpm_source/list
                logger 1 "Package List downloaded"
            else
                logger 4 "Failed to download package list from online repo,abort"
                exit
            end
        case upg
            logger 0 "Checking for update"
            for ctpm_package in (cd ~/.ctpm/package_info/ && list_menu *.info | sed 's/.info//g')
                set package_relver (sed -n '/package_relver=/'p ~/.ctpm/package_info/$ctpm_package.info | sed 's/package_relver=//g')
                set package_relver_repo (sed -n /$ctpm_package=/p /var/lib/ctpm/world | sed s/$ctpm_package=//g)
                if test $package_relver_repo -gt $package_relver
                    logger 0 "Upgrading $ctpm_package to version:$package_relver_repo"
                    grab $ctpm_package
                else
                    logger 0 "$ctpm_package is the latest package,skip"
                end
            end
            for ctpm_package in (cd /var/lib/ctpm/package_info/ && list_menu *.info | sed 's/.info//g')
                set package_relver (sed -n '/package_relver=/'p /var/lib/ctpm/package_info/$ctpm_package.info | sed 's/package_relver=//g')
                set package_relver_repo (sed -n /$ctpm_package=/p /var/lib/ctpm/world | sed s/$ctpm_package=//g)
                if test $package_relver_repo -gt $package_relver
                    logger 0 "Upgrading $ctpm_package to version:$package_relver_repo"
                    grab $ctpm_package
                else
                    logger 0 "$ctpm_package is the latest package,skip"
                end
            end
        case l
            echo "found in source:"
            cat /var/lib/ctpm/world
        case s
            echo "found in source:"
            for ctpm_package in $argv[2..-1]
                grep $ctpm_package /var/lib/ctpm/world
            end
        case '*'
            for ctpm_package in $argv
                logger 0 "Grabbing $ctpm_package"
                if curl -s -L -o /tmp/$ctpm_package.ctpkg $ctpm_source/$ctpm_package.ctpkg
                    if file /tmp/$ctpm_package.ctpkg | grep -q 'gzip compressed'
                    else
                        logger 4 "The package seems not a ctpkg file,remove and abort,please try to download again"
                        rm /tmp/$ctpm_package.ctpkg
                        exit
                    end
                    logger 1 "package:$ctpm_package downloaded,installing..."
                    cd /tmp
                    extract $ctpm_package.ctpkg
                    rm $ctpm_package.ctpkg
                else
                    logger 4 "package:$ctpm_package failed to download,ignored"
                end
            end
    end
end
