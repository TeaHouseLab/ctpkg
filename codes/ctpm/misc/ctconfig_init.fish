function ctconfig_init
    if test -e /etc/centerlinux/conf.d/ctpm.conf
    else
        set_color red
        echo "$prefix Detected First Launching,We need your password to create the config file"
        set_color normal
        if test -d /etc/centerlinux/conf.d/
        else
            sudo mkdir -p /etc/centerlinux/conf.d/
        end
        sudo sh -c "echo "source=https://cdngit.ruzhtw.top/ctpm/" > /etc/centerlinux/conf.d/ctpm.conf"
    end
end
