function ctpm_show
    for package_ctpm in $argv[1..-1]
        if test -e /var/lib/ctpm/package_info/$package_ctpm.info
            set package_name (sed -n '/package_name=/'p /var/lib/ctpm/package_info/$package_ctpm.info | sed 's/package_name=//g')
            set package_ver (sed -n '/package_ver=/'p /var/lib/ctpm/package_info/$package_ctpm.info | sed 's/package_ver=//g')
            set package_relver (sed -n '/package_relver=/'p /var/lib/ctpm/package_info/$package_ctpm.info | sed 's/package_relver=//g')
            set package_level (sed -n '/package_level=/'p /var/lib/ctpm/package_info/$package_ctpm.info | sed 's/package_level=//g')
            set package_unis (sed -n '/package_unis=/'p /var/lib/ctpm/package_info/$package_ctpm.info | sed 's/package_unis=//g')
            echo "-----------"
            echo "package name: $package_name"
            echo "package software ver: $package_ver"
            echo "package relver:$package_relver"
            echo "package level: $package_level"
            echo "package unis hook: $package_unis"
            echo "-----------"
        end
        if test -e ~/.ctpm/package_info/$package_ctpm.info
            set package_name (sed -n '/package_name=/'p ~/.ctpm/package_info/$package_ctpm.info | sed 's/package_name=//g')
            set package_ver (sed -n '/package_ver=/'p ~/.ctpm/package_info/$package_ctpm.info | sed 's/package_ver=//g')
            set package_relver (sed -n '/package_relver=/'p ~/.ctpm/package_info/$package_ctpm.info | sed 's/package_relver=//g')
            set package_level (sed -n '/package_level=/'p ~/.ctpm/package_info/$package_ctpm.info | sed 's/package_level=//g')
            set package_unis (sed -n '/package_unis=/'p ~/.ctpm/package_info/$package_ctpm.info | sed 's/package_unis=//g')
            echo "-----------"
            echo "package name: $package_name"
            echo "package software ver: $package_ver"
            echo "package relver:$package_relver"
            echo "package level: $package_level"
            echo "package unis hook: $package_unis"
            echo "-----------"
        end
    end
end
