function ctconfig_init
    if test -d /etc/centerlinux/conf.d/
    else
        set_color red
        echo "$prefix Detected First Launching,We need your password to create the config file"
        set_color normal
        sudo mkdir -p /etc/centerlinux/conf.d/
        sudo sh -c "echo "source=https://cdngit.ruzhtw.top/ctpm/" > /etc/centerlinux/conf.d/ctpm.conf"
    end
end
