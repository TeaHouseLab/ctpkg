function ctconfig_init
    if test -e /etc/centerlinux/conf.d/ctpkg.conf
    else
        set_color red
        echo "$prefix Detected First Launching,We need your password to create the config file"
        set_color normal
        if test -d /etc/centerlinux/conf.d/
        else
            sudo mkdir -p /etc/centerlinux/conf.d/
        end
        echo "main=https://ctpm.ruzhtw.top/" | sudo tee /etc/centerlinux/conf.d/ctpkg.source &>/dev/null
        echo "backend=" | sudo tee -a /etc/centerlinux/conf.d/ctpkg.conf &>/dev/null
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
