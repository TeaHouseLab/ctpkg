function sys_list
    if ls -1qA /var/lib/ctpm/package_info/ | grep -q .
        echo ">Installed-SysLevel<"
        cd /var/lib/ctpm/package_info/
        list_menu *.info | sed 's/.info//g'
    else
        echo ">Installed-SysLevel<"
    end
end
