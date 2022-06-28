function sys_purge
    for package_ctpm in $argv
        set package_unis (sed -n '/package_unis=/'p /var/lib/ctpm/package_info/$package_ctpm.info | sed 's/package_unis=//g')
        if test -e /var/lib/ctpm/package_info/$package_ctpm
            for src_file in (cat /var/lib/ctpm/package_info/$package_ctpm)
                sudo rm -rf $src_file
            end
            if [ "$package_unis" = 1 ]
                if test -e /var/lib/ctpm/package_info/$package_ctpm.unis
                    sudo /var/lib/ctpm/package_info/$package_ctpm.unis
                end
            end
            sudo rm /var/lib/ctpm/package_info/$package_ctpm
            sudo rm /var/lib/ctpm/package_info/$package_ctpm.info
            if test -d /var/lib/ctpm/package_info/$package_ctpm.unis
                sudo rm /var/lib/ctpm/package_info/$package_ctpm.unis
            end
            logger 2 "Purged package:$package_ctpm"
        else
            logger 5 "Info file of package:$package_ctpm has been lost, abort"
        end
    end
end
