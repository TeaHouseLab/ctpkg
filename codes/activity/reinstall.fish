function reinstall
    switch $package_manager
    case apt aptitude
        sudo $package_manager reinstall $argv
    case pacman
        sudo $package_manager -S $argv
    case apk
        sudo $package_manager dev $argv
        sudo $package_manager add $argv
    case dnf
        sudo $package_manager reinstall $argv
    case xbps
        sudo $package_manager-install -f $argv
    case '*'
        logger 4 "No support package manager detected"
end
end