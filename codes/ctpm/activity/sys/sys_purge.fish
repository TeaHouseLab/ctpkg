function sys_purge
    for package_ctpm in $argv
        if test -e /var/lib/ctpm/package_info/$package_ctpm
            for src_file in (cat /var/lib/ctpm/package_info/$package_ctpm)
                sudo rm -rf $src_file
            end
            sudo rm /var/lib/ctpm/package_info/$package_ctpm
            sudo rm /var/lib/ctpm/package_info/$package_ctpm.info
            logger 1 purged package:$package_ctpm
        else
            logger 4 "no info file of package:$package_ctpm,abort"
        end
    end
end
