function pack
    set package_level (sed -n '/package_level=/'p ctpm_pkg_info | sed 's/package_level=//g')
    set package_name (sed -n '/package_name=/'p ctpm_pkg_info | sed 's/package_name=//g')
    set package_ver (sed -n '/package_ver=/'p ctpm_pkg_info | sed 's/package_ver=//g')
    if [ "$package_name" = "" ]
        logger 4 'No package_name defined,abort'
        exit
    end
    if [ "$package_ver" = "" ]
        logger 4 'No package_ver defined,abort'
        exit
    end
    if [ "$package_level" = "" ]
        logger 4 'No package_level defined,abort'
        exit
    end
    if test -d src
        if test -e src/file_list
        else
            logger 4 'No src/file_list defined,abort'
        end
    else
        logger 4 'No src directory,abort'
    end
    tar zcf $package_name.ctpkg .
    logger 0 "Processed,store at $package_name.ctpkg"
end
