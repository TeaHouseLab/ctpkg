function check_environment
    if test -d /var/lib/ctpm/package_info
    else
        sudo mkdir -p /var/lib/ctpm/package_info
    end
    if test -d ~/.ctpm/package_info
    else
        mkdir -p ~/.ctpm/package_info
    end
end
