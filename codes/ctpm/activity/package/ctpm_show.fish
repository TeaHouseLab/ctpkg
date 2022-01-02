function ctpm_show
    for package_ctpm in $argv[1..-1]
        if test -e /var/lib/ctpm/package_info/$package_ctpm.info
            set package_level (sed -n '/package_level=/'p /var/lib/ctpm/package_info/$package_ctpm.info | sed 's/package_level=//g')
            set package_name (sed -n '/package_name=/'p /var/lib/ctpm/package_info/$package_ctpm.info | sed 's/package_name=//g')
            set package_ver (sed -n '/package_ver=/'p /var/lib/ctpm/package_info/$package_ctpm.info | sed 's/package_ver=//g')
            echo "-----------"
            echo "package_name: $package_name"
            echo "package_ver: $package_ver"
            echo "package_level: $package_level"
            echo "-----------"
        end
        if test -e ~/.ctpm/package_info/$package_ctpm.info
            set package_level (sed -n '/package_level=/'p ~/.ctpm/package_info/$package_ctpm.info | sed 's/package_level=//g')
            set package_name (sed -n '/package_name=/'p ~/.ctpm/package_info/$package_ctpm.info | sed 's/package_name=//g')
            set package_ver (sed -n '/package_ver=/'p ~/.ctpm/package_info/$package_ctpm.info | sed 's/package_ver=//g')
            echo "-----------"
            echo "package_name: $package_name"
            echo "package_ver: $package_ver"
            echo "package_level: $package_level"
            echo "-----------"
        end
    end
end
