function sys_list
    if ls -1qA /var/lib/ctpm/package_info/ | grep -q .
        set_color red
        echo ">Installed-SysLevel<"
        set_color normal
        cd /var/lib/ctpm/package_info/
        list_menu *.info | sed 's/.info//g'
    else
        set_color red
        echo ">Installed-SysLevel<"
        set_color normal
    end
end
