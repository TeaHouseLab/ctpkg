function grab
    argparse -i -n $prefix y/no_confirm -- $argv
    set counter_source 0
    for source in (cat /etc/centerlinux/conf.d/ctpkg.source)
        set counter_source (math "$counter_source+1")
        set ctpm_source[$counter_source] (echo $source | awk -F "=" '{print $1}')
        set ctpm_source_link[$counter_source] (echo $source | awk -F "=" '{print $2}')
    end
    switch $argv[1]
        case upd
            if echo | sudo tee /var/lib/ctpm/world &>/dev/null
            else
                logger 5 "Failed to clean ctpm package database cache, abort"
                exit 1
            end
            if for target_source in (seq 1 $counter_source)
                    logger 0 "Refreshing source $ctpm_source[$target_source] from $ctpm_source_link[$target_source]"
                    curl --progress-bar -L "$ctpm_source_link[$target_source]/list" | sed -e "s/^/$ctpm_source[$target_source]\//" | sudo tee -a /var/lib/ctpm/world &>/dev/null
                end
                logger 2 "ctpm database is up to date"
            else
                logger 5 "Critical error when trying to update ctpm[R] database, abort"
                exit 1
            end
        case upg
            set counter_upg 0
            grab upd
            if ls -1qA ~/.ctpm/package_info/ | grep -q .
                for ctpm_package in (cd ~/.ctpm/package_info/ && list_menu *.info | sed 's/.info//g')
                    set package_relver (sed -n '/package_relver=/'p ~/.ctpm/package_info/$ctpm_package.info | sed 's/package_relver=//g')
                    if grep -qsF "$ctpm_package=" /var/lib/ctpm/world
                        set package_repo (cat /var/lib/ctpm/world | grep -F "$ctpm_package=" | awk -F "/" '{print $1}')
                        set package_relver_repo (cat /var/lib/ctpm/world | awk -F "/" '{print $2}' | sed -n "/$ctpm_package=/"p | awk -F "=" '{print $2}')
                        if test $package_relver_repo -gt $package_relver
                            set counter_upg (math $counter_upg+1)
                            set upgrade_package[$counter_upg] "$package_repo/$ctpm_package"
                        end
                    else
                        logger 4 "Package: $ctpm_package is not found in the source, ignore it"
                    end
                end
            end
            if ls -1qA /var/lib/ctpm/package_info/ | grep -q .
                for ctpm_package in (cd /var/lib/ctpm/package_info/ && list_menu *.info | sed 's/.info//g')
                    set package_relver (sed -n '/package_relver=/'p /var/lib/ctpm/package_info/$ctpm_package.info | sed 's/package_relver=//g')
                    if grep -qsF "$ctpm_package=" /var/lib/ctpm/world
                        set package_repo (cat /var/lib/ctpm/world | grep -F "$ctpm_package=" | awk -F "/" '{print $1}')
                        set package_relver_repo (cat /var/lib/ctpm/world | awk -F "/" '{print $2}' | sed -n "/$ctpm_package=/"p | awk -F "=" '{print $2}')
                        if test $package_relver_repo -gt $package_relver
                            set counter_upg (math $counter_upg+1)
                            set upgrade_package[$counter_upg] "$package_repo/$ctpm_package"
                        end
                    else
                        logger 4 "Package: $ctpm_package is not found in the source, ignore it"
                    end
                end
            end
            if test "$upgrade_package" = ""
                logger 2 "Your system is up to date"
            else
                if set -q _flag_no_confirm
                    grab $upgrade_package -y
                else
                    grab $upgrade_package
                end
            end
        case l
            echo "* Listing all package available in cloud repo..."
            cat /var/lib/ctpm/world
        case s
            echo "* Found in source:"
            for ctpm_package in $argv[2..-1]
                grep $ctpm_package /var/lib/ctpm/world
            end
        case sc
            cat /etc/centerlinux/conf.d/ctpkg.source
        case '*'
            logger 0 "Checking for packages..."
            set counter_grab 0
            set counter_grab_ignore 0
            for ctpm_package in $argv
                if grep -qsF "$ctpm_package=" /var/lib/ctpm/world
                    set counter_grab (math $counter_grab+1)
                    set grab_package[$counter_grab] $ctpm_package
                else
                    set counter_grab_ignore (math $counter_grab+1)
                    set grab_ignore[$counter_grab_ignore] $ctpm_package
                end
            end
            if test "$grab_package" = ""
                logger 5 "Nothing to grab, abort"
                logger 4 "The following packages won't be installed, cuz they're not available in any cloudrepo"
                logger 0 -----------
                logger 0 "$grab_ignore"
                logger 0 -----------
            else
                logger 4 "The following packages is available,grab them all?[y/N]"
                logger 0 -----------
                logger 0 "$grab_package"
                logger 0 -----------
                if test "$grab_ignore" = ""
                else
                    logger 4 "The following packages won't be installed, cuz they're not available in any cloudrepo"
                    logger 0 -----------
                    logger 0 "$grab_ignore"
                    logger 0 -----------
                end
                if set -q _flag_no_confirm
                else
                    read -n1 -P "$prefix >>> " grab_confirm
                    switch $grab_confirm
                        case y Y
                        case n N '*'
                            logger 1 "Aborted by user"
                            exit
                    end
                end
            end
            for ctpm_package in $grab_package
                if echo $ctpm_package | grep -qs /
                    set target_source (echo $ctpm_package | awk -F "/" '{print $1}')
                    set ctpm_package (echo $ctpm_package | awk -F "/" '{print $2}')
                else
                    set target_source (grep -F "$ctpm_package=" /var/lib/ctpm/world | awk -F "/" '{print $1}')
                end
                for sources in (seq 1 $counter_source)
                    if test "$ctpm_source[$sources]" = "$target_source"
                        set target_source_link $ctpm_source_link[$sources]
                    end
                end
                logger 0 "Grabbing $ctpm_package"
                if curl --progress-bar -L -o /tmp/$ctpm_package.ctpkg $target_source_link/$ctpm_package.ctpkg
                    if file /tmp/$ctpm_package.ctpkg | grep -q 'gzip compressed'
                        logger 1 "Package:$ctpm_package Downloaded,installing..."
                        cd /tmp
                        extract $ctpm_package.ctpkg
                        rm $ctpm_package.ctpkg
                    else
                        logger 4 "The package downloaded for $ctpm_package seems not a ctpkg file,remove and skip it,please try to download again and check the package name you typed"
                        rm /tmp/$ctpm_package.ctpkg
                    end
                else
                    logger 4 "Package:$ctpm_package failed to download,ignored"
                end
            end
    end
end
