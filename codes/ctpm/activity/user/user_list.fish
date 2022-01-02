function user_list
    if ls -1qA ~/.ctpm/package_info/ | grep -q .
        echo ">Installed-UserLevel<"
        cd ~/.ctpm/package_info/
        list_menu *.info | sed 's/.info//g'
    else
        echo ">Installed-UserLevel<"
    end
end
