function user_purge
    for package_ctpm in $argv[1..-1]
        set package_unis (sed -n '/package_unis=/'p ~/.ctpm/package_info/$package_ctpm | sed 's/package_unis=//g')
        switch $package_unis
            case 0
                if test -d ~/ctpm_pkg/$package_ctpm
                    rm -rf ~/ctpm_pkg/$package_ctpm
                    logger 1 "src files of package:$package_ctpm Purged"
                else
                    logger 4 "no such directoryof package:$package_ctpm,abort"
                end
                if test -e ~/.ctpm/package_info/$package_ctpm
                    rm ~/.ctpm/package_info/$package_ctpm
                    logger 1 "info file of package:$package_ctpm Purged"
                    logger 1 purged package $package_ctpm
                else
                    logger 4 "no info file of package:$package_ctpm,abort"
                end
            case 1
                if test -e ~/ctpm_pkg/$package_ctpm/unis.sh
                    chmod +x ~/ctpm_pkg/$package_ctpm/unis.sh
                    logger 0 'Exec the autopurge script'
                    ~/ctpm_pkg/$package_ctpm/unis.sh
                else
                    logger 4 'no autopurge script of package:$package_ctpm,abort'
                end
        end
    end
end
