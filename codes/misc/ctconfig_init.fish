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
        sudo sh -c "echo "source=https://ctpm.ruzhtw.top/" > /etc/centerlinux/conf.d/ctpm.conf"
    end
    if test -d /var/lib/ctpm/package_info
    else
        logger 3 'Creating ctpm package info database'
        sudo mkdir -p /var/lib/ctpm/package_info
    end
    if test -d ~/.ctpm/package_info
    else
        logger 3 'Creating ctpm user package info database'
        mkdir -p ~/.ctpm/package_info
    end
end
