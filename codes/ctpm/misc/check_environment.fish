function check_environment
    logger 2 'Testing for sys level'
    if test -d /var/lib/ctpm/package_info
    else
        sudo mkdir -p /var/lib/ctpm/package_info
    end
    logger 2 'Tesing for user level'
    if test -d ~/.ctpm/package_info
    else
        sudo mkdir -p ~/.ctpm/package_info
    end
    if test -d ~/ctpm_pkg
    else
        mkdir -p ~/.ctpm_pkg
    end
end
