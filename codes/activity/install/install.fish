function install
    detectos
    switch $package_manager
        case apt aptitude
            sudo $package_manager install $argv
        case pacman
            sudo $package_manager -S $argv
        case apk
            sudo $package_manager add $argv
        case dnf
            sudo $package_manager install $argv
        case '*'
            logger 4 "$prefix No support package manager detected"
    end
end
