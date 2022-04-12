function user_purge
    for package_ctpm in $argv
        set package_unis (sed -n '/package_unis=/'p ~/.ctpm/package_info/$package_ctpm.info | sed 's/package_unis=//g')
        if test -e ~/.ctpm/package_info/$package_ctpm
            for src_file in (cat ~/.ctpm/package_info/$package_ctpm)
                rm -rf ~/$src_file
            end
            if [ "$package_unis" = "1" ]
                if test -e ~/.ctpm/package_info/$package_ctpm.unis
                    ~/.ctpm/package_info/$package_ctpm.unis
                end
            end
            rm ~/.ctpm/package_info/$package_ctpm
            rm ~/.ctpm/package_info/$package_ctpm.info
            if test -e ~/.ctpm/package_info/$package_ctpm.unis
            rm ~/.ctpm/package_info/$package_ctpm.unis
            end
            logger 1 purged package:$package_ctpm
        else
            logger 4 "no info file of package:$package_ctpm,abort"
        end
    end
end
