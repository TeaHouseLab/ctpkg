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
            logger 1 purged package:$package_ctpm
        else
            logger 4 "no info file of package:$package_ctpm,abort"
        end
    end
end
