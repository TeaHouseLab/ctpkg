function install
    switch $package_manager
        case apt aptitude
            sudo $package_manager install $argv
        case pacman
            sudo $package_manager -S $argv
        case apk
            sudo $package_manager add $argv
        case dnf yum
            sudo $package_manager install $argv
        case xbps
            sudo $package_manager-install $argv
        case '*'
            logger 5 "No support package manager detected"
    end
end
