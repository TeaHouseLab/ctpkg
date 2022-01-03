function user_list
    if ls -1qA ~/.ctpm/package_info/ | grep -q .
        set_color red
        echo ">Installed-UserLevel<"
        set_color normal
        cd ~/.ctpm/package_info/
        list_menu *.info | sed 's/.info//g'
    else
        set_color red
        echo ">Installed-UserLevel<"
        set_color normal
    end
end
